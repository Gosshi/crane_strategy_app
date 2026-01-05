import '../models/strategy.dart';
import '../models/product.dart';

/// 攻略法および商品データのリポジトリインターフェース
abstract class StrategyRepository {
  /// 全ての攻略法を取得する
  Future<List<Strategy>> fetchStrategies();

  /// 指定されたIDリストに対応する攻略法を取得する
  Future<List<Strategy>> fetchStrategiesByIds(List<String> ids);

  /// 指定されたIDリストに対応する商品を取得する
  Future<List<Product>> fetchProductsByIds(List<String> ids);

  /// バーコードから商品を検索する
  Future<Product?> fetchProductByBarcode(String barcode);

  /// 商品を追加する
  Future<void> addProduct(Product product);

  /// キーワードで商品を検索する (商品名またはタグ)
  Future<List<Product>> searchProducts(String query);
}
