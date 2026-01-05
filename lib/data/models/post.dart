import 'package:cloud_firestore/cloud_firestore.dart';

/// ユーザー投稿データモデル
class Post {
  final String id;
  final String productId;
  final String userId;
  final String text;
  final String? imageUrl;
  final String? youtubeUrl;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.productId,
    required this.userId,
    required this.text,
    this.imageUrl,
    this.youtubeUrl,
    required this.createdAt,
  });

  /// Firestoreのデータからモデルを作成
  factory Post.fromMap(String id, Map<String, dynamic> map) {
    return Post(
      id: id,
      productId: map['productId'] ?? '',
      userId: map['userId'] ?? '',
      text: map['text'] ?? '',
      imageUrl: map['imageUrl'],
      youtubeUrl: map['youtubeUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  /// モデルをFirestore用データに変換
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'userId': userId,
      'text': text,
      'imageUrl': imageUrl,
      'youtubeUrl': youtubeUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
