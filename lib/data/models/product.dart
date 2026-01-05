/// 商品データのモデル
class Product {
  /// JANコード (バーコード)
  final String id;

  /// 商品名
  final String name;

  /// 商品画像URL
  final String imageUrl;

  /// 商品画像のストレージパス (アップロード用)
  /// [imageUrl] はダウンロードURLだが、こちらは削除や更新時に使う
  final String? imagePath;

  /// カテゴリリスト (例: フィギュア, ぬいぐるみ)
  final List<String> categories;

  /// 重心情報リスト (例: 上, 中, 個体差あり)
  final List<String> centerOfGravity;

  /// タグリスト (例: Grandista, ウマ娘)
  final List<String> tags;

  /// 関連する攻略法IDのリスト
  final List<String> strategyIds;

  /// 作成者ID (Firebase Auth UID)
  /// nullの場合は誰でも編集可能(既存データ)またはシステム作成
  final String? creatorId;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.imagePath,
    this.categories = const [],
    this.centerOfGravity = const [],
    this.tags = const [],
    required this.strategyIds,
    this.creatorId,
  });

  /// Firestoreのデータからモデルを作成
  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      imagePath: map['imagePath'],
      categories: List<String>.from(map['categories'] ?? []),
      centerOfGravity: List<String>.from(map['centerOfGravity'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
      strategyIds: List<String>.from(map['strategyIds'] ?? []),
      creatorId: map['creatorId'],
    );
  }

  /// モデルをFirestore用データに変換
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'categories': categories,
      'centerOfGravity': centerOfGravity,
      'tags': tags,
      'strategyIds': strategyIds,
      'creatorId': creatorId,
    };
  }
}
