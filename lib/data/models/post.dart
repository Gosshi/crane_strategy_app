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
  final DateTime? updatedAt;

  const Post({
    required this.id,
    required this.productId,
    required this.userId,
    required this.text,
    this.imageUrl,
    this.youtubeUrl,
    required this.createdAt,
    this.updatedAt,
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
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
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
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  /// コピーを作成（編集用）
  Post copyWith({
    String? id,
    String? productId,
    String? userId,
    String? text,
    String? imageUrl,
    String? youtubeUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Post(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
