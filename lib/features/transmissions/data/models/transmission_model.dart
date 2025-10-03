import 'package:cloud_firestore/cloud_firestore.dart';

class TransmissionModel {
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final List<String> imageUrls;
  final bool isLive;
  final String? liveStreamId;
  final Timestamp timestamp;

  TransmissionModel({
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.imageUrls,
    this.isLive = false,
    this.liveStreamId,
    required this.timestamp,
  });

  factory TransmissionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TransmissionModel(
      authorId: data['authorId'],
      authorName: data['authorName'],
      authorPhotoUrl: data['authorPhotoUrl'],
      imageUrls: List<String>.from(data['imageUrls']),
      isLive: data['isLive'] ?? false,
      liveStreamId: data['liveStreamId'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorPhotoUrl': authorPhotoUrl,
      'imageUrls': imageUrls,
      'isLive': isLive,
      'liveStreamId': liveStreamId,
      'timestamp': timestamp,
    };
  }
}
