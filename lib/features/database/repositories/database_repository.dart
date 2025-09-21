import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibra/features/database/models/user_model.dart';

class DatabaseRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserData(UserModel user) async {
    try {
      await _db.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      print('Error guardando datos de usuario: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      print('Error obteniendo datos de usuario: $e');
      return null;
    }
  }

  Future<void> updateUserData(String uid, {String? displayName, String? mainGoal}) async {
    try {
      final data = <String, dynamic>{};
      if (displayName != null) data['displayName'] = displayName;
      if (mainGoal != null) data['mainGoal'] = mainGoal;

      if (data.isNotEmpty) {
        await _db.collection('users').doc(uid).update(data);
      }
    } catch (e) {
      print('Error actualizando datos de usuario: $e');
      rethrow;
    }
  }
}
