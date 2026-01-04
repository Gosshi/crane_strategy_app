import '../seeds/initial_data.dart';
import '../models/strategy.dart';
import '../models/product.dart';
import 'strategy_repository.dart';

/// ダミーデータを返すリポジトリ
class MockStrategyRepository implements StrategyRepository {
  // ダミーの攻略法データ
  final List<Strategy> _strategies = initialStrategies;

  // ダミーの商品データ
  final List<Product> _products = initialProducts;

  /// ダミーの攻略法データを返す
  @override
  Future<List<Strategy>> fetchStrategies() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _strategies;
  }

  /// IDリストに紐づく攻略法リストを返す
  @override
  Future<List<Strategy>> fetchStrategiesByIds(List<String> ids) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _strategies.where((s) => ids.contains(s.id)).toList();
  }

  /// バーコードから商品を検索する
  @override
  Future<Product?> fetchProductByBarcode(String barcode) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      return _products.firstWhere((p) => p.id == barcode);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _products.add(product);
  }
}
