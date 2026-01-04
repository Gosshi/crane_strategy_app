import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionItem {
  final String id;
  final String productId;
  final DateTime acquiredAt;
  final String? shopName;
  final String? note;

  const CollectionItem({
    required this.id,
    required this.productId,
    required this.acquiredAt,
    this.shopName,
    this.note,
  });

  factory CollectionItem.fromMap(String id, Map<String, dynamic> map) {
    return CollectionItem(
      id: id,
      productId: map['productId'] as String? ?? '',
      acquiredAt: (map['acquiredAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      shopName: map['shopName'] as String?,
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'acquiredAt': Timestamp.fromDate(acquiredAt),
      'shopName': shopName,
      'note': note,
    };
  }

  CollectionItem copyWith({
    String? id,
    String? productId,
    DateTime? acquiredAt,
    String? shopName,
    String? note,
  }) {
    return CollectionItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      acquiredAt: acquiredAt ?? this.acquiredAt,
      shopName: shopName ?? this.shopName,
      note: note ?? this.note,
    );
  }
}
