import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vibra/features/comments/models/comment_model.dart'; // Importar el modelo de comentario

class PostRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PostRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<void> createPost({required String content}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    await _firestore.collection('posts').add({
      'content': content,
      'authorId': currentUser.uid,
      'authorName': currentUser.displayName ?? 'Anonymous',
      'authorPhotoURL': currentUser.photoURL,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Nuevo método para obtener un stream de comentarios para un post específico
  Stream<List<Comment>> getCommentsStream(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: false) // Ordenar por fecha ascendente
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Comment.fromFirestore(doc))
          .toList();
    });
  }

  // Nuevo método para añadir un comentario a un post específico
  Future<void> addComment(String postId, String text, User user) async {
    if (user.isAnonymous) {
      throw Exception('Guest users cannot add comments.');
    }
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(Comment(
          id: '', // Firestore generará el ID
          postId: postId,
          authorId: user.uid,
          authorName: user.displayName ?? 'Anonymous',
          text: text,
          timestamp: DateTime.now(),
        ).toFirestore());
  }
}