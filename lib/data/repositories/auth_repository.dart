import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserCredential> signInAnonymously();
  Future<UserCredential> linkWithGoogle();
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> linkWithApple();
  Future<UserCredential> signInWithApple();
  Future<void> signOut();
}
