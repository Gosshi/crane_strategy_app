import 'package:share_plus/share_plus.dart';
import '../data/models/post.dart';
import '../data/models/product.dart';

/// 共有機能を一元管理するユーティリティクラス
class ShareUtils {
  /// 投稿を共有
  static void sharePost(Post post, {String? productName}) {
    final name = productName ?? '商品';
    final text = post.text.isNotEmpty ? post.text : '';
    final youtube = post.youtubeUrl != null ? '\n動画: ${post.youtubeUrl}' : '';

    final shareText =
        '【$name】の攻略情報\n'
        '$text$youtube\n'
        '#クレーンゲーム攻略アプリ';

    // ignore: deprecated_member_use
    Share.share(shareText);
  }

  /// 商品を共有
  static void shareProduct(Product product) {
    final shareText =
        '【${product.name}】\n'
        'この商品の攻略法をチェック！\n'
        '#クレーンゲーム攻略アプリ';

    // ignore: deprecated_member_use
    Share.share(shareText);
  }

  /// 獲得コレクションを共有
  static void shareCollectionItem({
    required String productName,
    String? shopName,
    required DateTime acquiredAt,
    String? note,
  }) {
    final shop = shopName ?? 'ゲームセンター';
    final date = acquiredAt.toString().split(' ')[0];
    final noteText = note ?? '';

    final shareText =
        '【$productName】をGETしました！\n'
        '店舗: $shop\n'
        '獲得日: $date\n'
        '$noteText\n'
        '#クレーンゲーム攻略アプリ';

    // ignore: deprecated_member_use
    Share.share(shareText);
  }
}
