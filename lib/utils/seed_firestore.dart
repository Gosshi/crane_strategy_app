import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../data/seeds/initial_data.dart';

/// Firestoreに初期データを投入する
/// 既にデータがある場合は上書きする
Future<void> seedFirestoreData() async {
  if (!kDebugMode) {
    debugPrint('Seeding is only allowed in debug mode.');
    return;
  }

  final firestore = FirebaseFirestore.instance;

  try {
    // 攻略法データの投入
    final strategiesBatch = firestore.batch();
    final now = Timestamp.now();

    for (final strategy in initialStrategies) {
      final docRef = firestore.collection('strategies').doc(strategy.id);
      final data = strategy.toMap();
      data['updatedAt'] = now; // 現在時刻で上書き
      strategiesBatch.set(docRef, data);
    }
    await strategiesBatch.commit();
    debugPrint(
      'Strategies seeding completed: ${initialStrategies.length} items',
    );

    // 商品データの投入
    final productsBatch = firestore.batch();
    for (final product in initialProducts) {
      final docRef = firestore.collection('products').doc(product.id);
      productsBatch.set(docRef, product.toMap());
    }
    await productsBatch.commit();
    debugPrint('Products seeding completed: ${initialProducts.length} items');
  } catch (e) {
    debugPrint('Seeding failed: $e');
    rethrow;
  }
}
