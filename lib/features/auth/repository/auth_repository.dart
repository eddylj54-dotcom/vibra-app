import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get user;
  User? get currentUser;

  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<User?> signInWithGoogle();

  Future<void> signOut();

  Future<void> sendEmailVerification();
}
