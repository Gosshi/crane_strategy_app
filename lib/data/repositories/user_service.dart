import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ユーザー認証関連のリポジトリ (Service)
/// 匿名認証のみを扱う
class UserService {
  final FirebaseAuth _auth;

  UserService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  /// 現在のユーザーを取得
  User? get currentUser => _auth.currentUser;

  /// ユーザーIDのStream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 匿名ログインを実行
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }
}

/// UserServiceのプロバイダー
final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

/// 現在のユーザーのStreamプロバイダー
final authStateProvider = StreamProvider<User?>((ref) {
  final service = ref.watch(userServiceProvider);
  return service.authStateChanges;
});
