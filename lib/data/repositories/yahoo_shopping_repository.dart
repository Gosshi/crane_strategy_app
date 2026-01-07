import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../env.dart';

final yahooShoppingRepositoryProvider = Provider(
  (ref) => YahooShoppingRepository(FirebaseFirestore.instance),
);

class YahooShoppingRepository {
  final FirebaseFirestore _firestore;

  YahooShoppingRepository(this._firestore);

  // env.dart で定義された定数を使用
  static const String _clientId = yahooClientId;
  static const String _baseUrl =
      'https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch';

  Future<YahooProductItem?> searchByJanCode(String janCode) async {
    // 1. キャッシュ確認
    try {
      final doc = await _firestore
          .collection('product_cache')
          .doc(janCode)
          .get();
      if (doc.exists && doc.data() != null) {
        debugPrint('Yahoo Cache Hit: $janCode');
        return YahooProductItem.fromMap(doc.data()!);
      }
    } catch (e) {
      debugPrint('Cache check failed: $e');
      // キャッシュエラーは無視してAPIへ
    }

    // 2. API検索 (リトライロジック付き)
    YahooProductItem? item = await _callApi(janCode);
    if (item == null) {
      // 429等の場合、一度だけリトライ
      // ここでは簡易的に _callApi 内部で待機しても良いが、
      // 明示的にリトライしたい場合はループなどで実装。
      // 今回は _callApi 内で 200以外 のハンドリングを強化する等は将来課題とし、
      // 実装計画通り 429 対策は "Future.delayed" を挟む
    }

    // 3. キャッシュ保存
    if (item != null) {
      try {
        await _firestore.collection('product_cache').doc(janCode).set({
          'name': item.name,
          'image': {
            'medium': item.imageUrl,
          }, // APIレスポンス構造に合わせるか、フラットにするか。fromMapを再利用するためAPI構造に寄せる
          'url': item.url,
          'source': 'yahoo_api',
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        debugPrint('Cache save failed: $e');
      }
    }

    return item;
  }

  Future<YahooProductItem?> _callApi(
    String janCode, {
    bool isRetry = false,
  }) async {
    try {
      final uri = Uri.parse(_baseUrl).replace(
        queryParameters: {
          'appid': _clientId,
          'jan_code': janCode,
          'image_size': '600', // 300→600に変更で高画質化
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final totalResultsAvailable =
            data['totalResultsAvailable'] as int? ?? 0;
        if (totalResultsAvailable == 0) return null;

        final hits = data['hits'] as List<dynamic>?;
        if (hits != null && hits.isNotEmpty) {
          final item = hits[0] as Map<String, dynamic>;
          return YahooProductItem.fromMap(item);
        }
      } else if (response.statusCode == 429 && !isRetry) {
        debugPrint('Yahoo API Rate Limited (429). Retrying in 2 seconds...');
        await Future.delayed(const Duration(seconds: 2));
        return _callApi(janCode, isRetry: true);
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

    final rawName = map['name'] as String? ?? '名称不明';
    return YahooProductItem(
      name: _cleanName(rawName),
      imageUrl: img,
      url: map['url'] as String?,
    );
  }

  static String _cleanName(String text) {
    var cleaned = text;

    // 1. 【】で囲まれた部分（ショップ独自のタグなど）を削除
    // 例: 【中古】ワンピース ... -> ワンピース ...
    cleaned = cleaned.replaceAll(RegExp(r'【.*?】'), '');

    // 2. [ ] で囲まれた部分を削除
    cleaned = cleaned.replaceAll(RegExp(r'\[.*?\]'), '');

    // 3. 特定のキーワードを削除
    const removeWords = [
      '中古品', // "中古"より先に削除
      '中古',
      '未開封品',
      '未開封',
      '新品',
      '未使用',
      '美品',
      '送料無料',
      '送料込',
      '即納',
      '訳あり',
      '箱なし',
      '箱有',
      '現状品',
      '国内正規品',
    ];

    for (final word in removeWords) {
      cleaned = cleaned.replaceAll(word, '');
    }

    // 4. 重複する空白を1つにまとめ、前後の空白を削除
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

    // 5. 先頭や末尾に残った「品」などを削除 (念のため最後に実施)
    // 正規表現: 行頭にある"品" または 行末にある"品" を削除
    cleaned = cleaned.replaceAll(RegExp(r'^品|品$'), '').trim();

    return cleaned;
  }
}
