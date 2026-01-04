import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/strategy.dart';
import '../models/product.dart'; // Product class
import '../repositories/strategy_repository.dart';
import '../repositories/mock_strategy_repository.dart';
import '../repositories/firestore_strategy_repository.dart';

/// リポジトリの実装を切り替えるフラグ
/// (本来は環境変数やRemoteConfigで管理するが、今回は定数で管理)
const bool useFirestore = true;

/// StrategyRepositoryのプロバイダー
final strategyRepositoryProvider = Provider<StrategyRepository>((ref) {
  if (useFirestore) {
    return FirestoreStrategyRepository();
  } else {
    return MockStrategyRepository();
  }
});

/// 検索クエリに基づいた商品リストプロバイダー
final productSearchListProvider = FutureProvider.family<List<Product>, String>((
  ref,
  query,
) async {
  final repository = ref.watch(strategyRepositoryProvider);
  return repository.searchProducts(query);
});

/// 攻略法リストの FutureProvider
final strategiesProvider = FutureProvider<List<Strategy>>((ref) async {
  final repository = ref.watch(strategyRepositoryProvider);
  return repository.fetchStrategies();
});
