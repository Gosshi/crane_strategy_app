import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../env.dart';

final yahooShoppingRepositoryProvider = Provider(
  (ref) => YahooShoppingRepository(),
);

class YahooShoppingRepository {
  // env.dart で定義された定数を使用
  static const String _clientId = yahooClientId;
  static const String _baseUrl =
      'https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch';

  Future<YahooProductItem?> searchByJanCode(String janCode) async {
    try {
      final uri = Uri.parse(_baseUrl).replace(
        queryParameters: {
          'appid': _clientId,
          'jan_code': janCode,
          'image_size': '300', // 画像サイズ指定 (任意)
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // ヒット件数確認
        final totalResultsAvailable =
            data['totalResultsAvailable'] as int? ?? 0;
        if (totalResultsAvailable == 0) {
          return null;
        }

        // 検索結果の最初の商品を取得
        final hits = data['hits'] as List<dynamic>?;
        if (hits != null && hits.isNotEmpty) {
          final item = hits[0] as Map<String, dynamic>;
          return YahooProductItem.fromMap(item);
        }
      } else {
        debugPrint(
          'Yahoo API Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Yahoo API Exception: $e');
    }
    return null;
  }
}

class YahooProductItem {
  final String name;
  final String? imageUrl;
  final String? url;

  YahooProductItem({required this.name, this.imageUrl, this.url});

  factory YahooProductItem.fromMap(Map<String, dynamic> map) {
    // レスポンス構造に合わせてパース
    // "name": 商品名
    // "image": { "medium": "URL" } など
    // "exImage": { "url": "URL" } (高画質版がある場合)

    String? img;
    if (map['image'] != null && map['image']['medium'] != null) {
      img = map['image']['medium'] as String;
    }
    // exImageがあればそちらを優先しても良い

    return YahooProductItem(
      name: map['name'] as String? ?? '名称不明',
      imageUrl: img,
      url: map['url'] as String?,
    );
  }
}
