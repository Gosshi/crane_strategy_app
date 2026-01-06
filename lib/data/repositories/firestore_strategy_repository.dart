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
    try {
      print('[FirestoreStrategyRepository] Fetching strategies...');
      print(
        '[FirestoreStrategyRepository] Firestore instance: ${_firestore.app.name}',
      );
      print(
        '[FirestoreStrategyRepository] Project: ${_firestore.app.options.projectId}',
      );

      // キャッシュを使わずにサーバーから直接取得
      final snapshot = await _firestore
          .collection('strategies')
          .get(const GetOptions(source: Source.server));
      print(
        '[FirestoreStrategyRepository] Retrieved ${snapshot.docs.length} documents from SERVER',
      );

      final strategies = <Strategy>[];
      for (final doc in snapshot.docs) {
        try {
          print('[FirestoreStrategyRepository] Processing doc: ${doc.id}');
          final strategy = Strategy.fromMap(doc.id, doc.data());
          strategies.add(strategy);
        } catch (e) {
          print(
            '[FirestoreStrategyRepository] Error parsing doc ${doc.id}: $e',
          );
          print('[FirestoreStrategyRepository] Doc data: ${doc.data()}');
        }
      }

      print(
        '[FirestoreStrategyRepository] Successfully parsed ${strategies.length} strategies',
      );
      return strategies;
    } on FirebaseException catch (e) {
      print('[FirestoreStrategyRepository] FirebaseException: ${e.code}');
      print('[FirestoreStrategyRepository] Message: ${e.message}');
      print('[FirestoreStrategyRepository] Plugin: ${e.plugin}');
      if (e.code == 'permission-denied') {
        print(
          '[FirestoreStrategyRepository] PERMISSION DENIED - Check Firestore Rules!',
        );
      }
      rethrow;
    } catch (e, stackTrace) {
      print('[FirestoreStrategyRepository] Error fetching strategies: $e');
      print('[FirestoreStrategyRepository] Stack trace: $stackTrace');
      rethrow;
    }
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
  Future<void> updateProduct(Product product) async {
    // ドキュメントが存在しない場合はエラーにしたいので、トランザクション内で存在確認を行う
    final docRef = _firestore.collection('products').doc(product.id);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Product with id ${product.id} does not exist');
      }
      // Productモデル全体を渡すが、merge:true で既存ドキュメントにマージする
      transaction.set(docRef, product.toMap(), SetOptions(merge: true));
    });
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
