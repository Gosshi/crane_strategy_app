/// 商品データのモデル
class Product {
  /// JANコード (バーコード)
  final String id;

  /// 商品名
  final String name;

  /// 商品画像URL
  final String imageUrl;

  /// 関連する攻略法IDのリスト
  final List<String> strategyIds;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.strategyIds,
  });

  /// Firestoreのデータからモデルを作成
  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      strategyIds: List<String>.from(map['strategyIds'] ?? []),
    );
  }

  /// モデルをFirestore用データに変換
  Map<String, dynamic> toMap() {
    return {'name': name, 'imageUrl': imageUrl, 'strategyIds': strategyIds};
  }
}
