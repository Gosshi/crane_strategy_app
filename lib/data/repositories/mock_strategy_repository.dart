import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/strategy.dart';
import '../models/product.dart';

import 'strategy_repository.dart';

/// ダミーデータを返すリポジトリ
class MockStrategyRepository implements StrategyRepository {
  // ダミーの攻略法データ
  final List<Strategy> _strategies = [
    const Strategy(
      id: '1',
      title: {'ja': '橋渡し・基本の縦ハメ', 'en': 'Vertical Stuck Method'},
      description: {
        'ja': '橋渡しの基本となる縦ハメの手順です。アームのパワーが強い場合に有効です。',
        'en':
            'Basic vertical stuck method for bridge setting. Effective when arm power is strong.',
      },
      settingType: '橋渡し',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      videoId: 'dQw4w9WgXcQ',
    ),
    const Strategy(
      id: '2',
      title: {'ja': '橋渡し・横ハメのコツ', 'en': 'Horizontal Stuck Tips'},
      description: {
        'ja': '横にはまってしまった場合のリカバリー方法と、そこからの寄せについて解説します。',
        'en':
            'Recovery methods when stuck horizontally and how to move from there.',
      },
      settingType: '橋渡し',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
      videoId: 'dQw4w9WgXcQ',
    ),
    const Strategy(
      id: '3',
      title: {'ja': '3本爪・初期位置からの攻略', 'en': '3-Claw Initial Position'},
      description: {
        'ja': '3本爪機種で初期位置から確率無視で獲得するための寄せ技です。',
        'en':
            'Technique to win from initial position on 3-claw machines ignoring probability.',
      },
      settingType: '3本爪',
      thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/mqdefault.jpg',
      videoId: 'dQw4w9WgXcQ',
    ),
  ];

  // ダミーの商品データ
  final List<Product> _products = [
    const Product(
      id: '4901234567890', // ダミーJAN
      name: 'アニメフィギュア A賞',
      imageUrl: 'https://placehold.co/200x200.png?text=Figure+A',
      strategyIds: ['1', '2'],
    ),
  ];

  /// ダミーの攻略法データを返す
  Future<List<Strategy>> fetchStrategies() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _strategies;
  }

  /// IDリストに紐づく攻略法リストを返す
  Future<List<Strategy>> fetchStrategiesByIds(List<String> ids) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _strategies.where((s) => ids.contains(s.id)).toList();
  }

  /// バーコードから商品を検索する
  Future<Product?> fetchProductByBarcode(String barcode) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      return _products.firstWhere((p) => p.id == barcode);
    } catch (_) {
      return null;
    }
  }
}
