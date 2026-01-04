import '../models/strategy.dart';
import '../models/product.dart';

/// 攻略法および商品データのリポジトリインターフェース
abstract class StrategyRepository {
  /// 全ての攻略法を取得する
  Future<List<Strategy>> fetchStrategies();

  /// 指定されたIDリストに対応する攻略法を取得する
  Future<List<Strategy>> fetchStrategiesByIds(List<String> ids);

  /// バーコードから商品を検索する
  Future<Product?> fetchProductByBarcode(String barcode);
}
