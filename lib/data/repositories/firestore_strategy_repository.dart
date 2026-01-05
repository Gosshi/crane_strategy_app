import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/strategy.dart';
import 'strategy_repository.dart';

/// Firestoreを使ったリポジトリ実装
class FirestoreStrategyRepository implements StrategyRepository {
  final FirebaseFirestore _firestore;

  FirestoreStrategyRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Strategy>> fetchStrategies() async {
    final snapshot = await _firestore.collection('strategies').get();
    return snapshot.docs
        .map((doc) => Strategy.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<List<Strategy>> fetchStrategiesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    // FirestoreのwhereInは最大10件までなので、必要なら分割処理が必要だが
    // 今回は簡易的に実装し、10件を超える場合はクライアントサイドフィルタリングなどを検討
    // または分割クエリを実行する
    if (ids.length > 10) {
      // 簡易実装: 10件ずつ取得して結合
      final List<Strategy> results = [];
      for (var i = 0; i < ids.length; i += 10) {
        final end = (i + 10 < ids.length) ? i + 10 : ids.length;
        final chunk = ids.sublist(i, end);
        final snapshot = await _firestore
            .collection('strategies')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        results.addAll(
          snapshot.docs.map((doc) => Strategy.fromMap(doc.id, doc.data())),
        );
      }
      return results;
    } else {
      final snapshot = await _firestore
          .collection('strategies')
          .where(FieldPath.documentId, whereIn: ids)
          .get();
      return snapshot.docs
          .map((doc) => Strategy.fromMap(doc.id, doc.data()))
          .toList();
    }
  }

  @override
  Future<List<Product>> fetchProductsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    if (ids.length > 10) {
      final List<Product> results = [];
      for (var i = 0; i < ids.length; i += 10) {
        final end = (i + 10 < ids.length) ? i + 10 : ids.length;
        final chunk = ids.sublist(i, end);
        final snapshot = await _firestore
            .collection('products')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        results.addAll(
          snapshot.docs.map((doc) => Product.fromMap(doc.id, doc.data())),
        );
      }
      return results;
    } else {
      final snapshot = await _firestore
          .collection('products')
          .where(FieldPath.documentId, whereIn: ids)
          .get();
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList();
    }
  }

  @override
  Future<Product?> fetchProductByBarcode(String barcode) async {
    final doc = await _firestore.collection('products').doc(barcode).get();
    if (doc.exists && doc.data() != null) {
      return Product.fromMap(doc.id, doc.data()!);
    }
    return null;
  }

  @override
  Future<void> addProduct(Product product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .set(product.toMap());
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    // Firestoreでの全文検索は難しいため、簡易的に全件取得してフィルタリングする
    // (データ量が少ないうちはこれで十分。多くなったらAlgolia等の導入が必要)
    final snapshot = await _firestore.collection('products').get();
    final allProducts = snapshot.docs
        .map((doc) => Product.fromMap(doc.id, doc.data()))
        .toList();

    if (query.isEmpty) {
      return allProducts;
    }

    final lowerQuery = query.toLowerCase();
    return allProducts.where((product) {
      final nameMatch = product.name.toLowerCase().contains(lowerQuery);
      final tagMatch = product.tags.any(
        (tag) => tag.toLowerCase().contains(lowerQuery),
      );
      return nameMatch || tagMatch;
    }).toList();
  }
}
