import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';
import 'package:vibra/features/transmissions/data/models/transmission_model.dart';

class TransmissionRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  TransmissionRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Stream<List<TransmissionModel>> getTransmissionsStream() {
    return _firestore
        .collection('transmissions')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransmissionModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> uploadImageAndCreateTransmission(
      List<File> images, User user) async {
    if (images.length > 5) {
      throw Exception('No se pueden subir más de 5 imágenes.');
    }

    List<String> imageUrls = [];
    for (var image in images) {
      final compressedImage = await _compressImage(image);
      final imageUrl = await _uploadImage(compressedImage, user.uid);
      imageUrls.add(imageUrl);
    }

    final transmission = TransmissionModel(
      authorId: user.uid,
      authorName: user.displayName ?? 'Usuario Anónimo',
      authorPhotoUrl: user.photoURL,
      imageUrls: imageUrls,
      timestamp: Timestamp.now(),
    );

    await _firestore
        .collection('transmissions')
        .add(transmission.toFirestore());
  }

  Future<File> _compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      quality: 50,
    );

    return File(compressedFile!.path);
  }

  Future<String> _uploadImage(File image, String userId) async {
    final imageId = const Uuid().v4();
    final ref = _storage.ref('transmissions').child(userId).child('$imageId.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}
