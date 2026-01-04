import '../models/product.dart';
import '../models/strategy.dart';

/// 初期データの定義
/// FirestoreへのSeedingとMockリポジトリの両方で使用する

const List<Strategy> initialStrategies = [
  Strategy(
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
  Strategy(
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
  Strategy(
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

const List<Product> initialProducts = [
  Product(
    id: '4901234567890', // ダミーJAN
    name: 'アニメフィギュア A賞',
    imageUrl: 'https://placehold.co/200x200.png?text=Figure+A',
    categories: ['フィギュア'],
    centerOfGravity: ['上', '裏'],
    tags: ['人気アニメ', 'プライズ限定'],
    strategyIds: ['1', '2'],
  ),
];
