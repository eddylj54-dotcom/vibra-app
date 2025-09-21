import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? mainGoal;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.mainGoal,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'mainGoal': mainGoal,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      displayName: data['displayName'],
      mainGoal: data['mainGoal'],
    );
  }
}
