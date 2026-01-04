import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import '../models/post.dart';

/// 投稿関連のリポジトリ
class PostRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  PostRepository({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  /// 指定された商品の投稿リストを取得 (作成日時降順)
  Stream<List<Post>> watchPostsByProductId(String productId) {
    return _firestore
        .collection('posts')
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Post.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  /// 投稿を作成
  Future<void> addPost(Post post) async {
    await _firestore.collection('posts').add(post.toMap());
  }

  /// 画像をアップロードし、ダウンロードURLを返す
  Future<String> uploadImage(String userId, File file) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = path.extension(file.path);
    final filename = '$timestamp$extension';
    final storageRef = _storage.ref().child('posts/$userId/$filename');

    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}

/// PostRepositoryのプロバイダー
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

/// 商品IDごとの投稿リストStreamプロバイダー
final postsStreamProvider = StreamProvider.family<List<Post>, String>((
  ref,
  productId,
) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.watchPostsByProductId(productId);
});
