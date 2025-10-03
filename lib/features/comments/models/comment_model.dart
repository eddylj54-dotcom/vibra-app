import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String text;
  final DateTime timestamp;

  const Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.timestamp,
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? authorId,
    String? authorName,
    String? text,
    DateTime? timestamp,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      postId: data['postId'] as String,
      authorId: data['authorId'] as String,
      authorName: data['authorName'] as String,
      text: data['text'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  @override
  List<Object?> get props => [id, postId, authorId, authorName, text, timestamp];
}
