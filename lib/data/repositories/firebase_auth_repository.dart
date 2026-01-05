import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository(this._firebaseAuth);

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInAnonymously() async {
    return _firebaseAuth.signInAnonymously();
  }

  @override
  Future<UserCredential> linkWithGoogle() async {
    try {
      // Googleログインフローを開始
      final googleUser = await gsi.GoogleSignIn.instance.authenticate();
      // authenticate calls throws on cancellation/error, so googleUser is non-null here

      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: null,
        idToken: googleAuth.idToken,
      );

      // 現在のユーザーにリンク
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'ERROR_NO_USER',
          message: 'No user to link',
        );
      }

      return await user.linkWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await gsi.GoogleSignIn.instance.authenticate();
      // authenticate calls throws on cancellation/error, so googleUser is non-null here

      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: null,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential> linkWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthProvider = OAuthProvider('apple.com');
      final credential = oauthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'ERROR_NO_USER',
          message: 'No user to link',
        );
      }

      return await user.linkWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthProvider = OAuthProvider('apple.com');
      final credential = oauthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await gsi.GoogleSignIn.instance.signOut();
    } catch (_) {} // Googleサインアウト失敗は無視してFirebaseサインアウトへ
    await _firebaseAuth.signOut();
  }
}
