import '../models/product.dart';
import '../models/strategy.dart';
import '../models/term.dart';

/// 初期データの定義
/// FirestoreへのSeedingとMockリポジトリの両方で使用する

final List<Strategy> initialStrategies = [
  Strategy(
    id: '1',
    title: {'ja': '橋渡し・基本の縦ハメ', 'en': 'Bridge - Vertical Stuck Method'},
    description: {
      'ja': '橋渡しの基本となる縦ハメの手順です。アームのパワーが強い場合に有効です。',
      'en':
          'Basic vertical stuck method for bridge technique. Effective when arm power is strong.',
    },
    settingType: '橋渡し',
    thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
    videoId: 'dQw4w9WgXcQ',
    updatedAt: DateTime(2026, 1, 6, 23, 0),
  ),
  Strategy(
    id: '2',
    title: {'ja': '橋渡し・横ハメのコツ', 'en': 'Bridge - Horizontal Stuck Tips'},
    description: {
      'ja': '横にはまってしまった場合のリカバリー方法と、そこからの寄せについて解説します。',
      'en':
          'Recovery methods when stuck horizontally and how to move the prize from there.',
    },
    settingType: '橋渡し',
    thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
    videoId: 'dQw4w9WgXcQ',
    updatedAt: DateTime(2026, 1, 5, 14, 30),
  ),
  Strategy(
    id: '3',
    title: {'ja': '3本爪・初期位置からの攻略', 'en': '3-Claw Initial Position Strategy'},
    description: {
      'ja': '3本爪機種で初期位置から確率無視で獲得するための寄せ技です。',
      'en':
          'Technique to win from initial position on 3-claw machines, ignoring probability settings.',
    },
    settingType: '3本爪',
    thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/mqdefault.jpg',
    videoId: 'dQw4w9WgXcQ',
    updatedAt: DateTime(2026, 1, 4, 10, 15),
  ),
];

final List<Product> initialProducts = [
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

final List<Term> initialTerms = [
  Term(
    id: 'term_bridge',
    name: {'ja': '橋渡し', 'en': 'Bridge'},
    reading: 'はしわたし',
    description: {
      'ja': 'アームを左右に動かして景品を橋のように移動させる技術。連続して行うことで、確実に景品を取り口に近づけることができます。',
      'en':
          'A technique of moving the prize like a bridge by swinging the arm left and right. By doing repeatedly, you can reliably bring the prize closer to the chute.',
    },
    category: 'technique',
    imageUrl: null,
    relatedTermIds: const ['term_ceiling', 'term_send'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_ceiling',
    name: {'ja': '天井', 'en': 'Ceiling'},
    reading: 'てんじょう',
    description: {
      'ja': '横ハメ設定の景品を天井に押し付けて移動させる技術。アームのパワーが弱い場合でも有効です。',
      'en':
          'Technique to press horizontally placed prizes against the ceiling to move them. Effective even when arm power is weak.',
    },
    category: 'technique',
    imageUrl: null,
    relatedTermIds: const ['term_bridge'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_send',
    name: {'ja': '送り', 'en': 'Send'},
    reading: 'おくり',
    description: {
      'ja': '景品を奥から手前に少しずつ移動させる技術。取り口まで送ることで獲得を目指します。',
      'en':
          'Technique to gradually move the prize from back to front. Aim to win by sending it to the chute.',
    },
    category: 'technique',
    imageUrl: null,
    relatedTermIds: const ['term_bridge'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_plush',
    name: {'ja': 'ぬいぐるみ', 'en': 'Plush Toy'},
    reading: 'ぬいぐるみ',
    description: {
      'ja': '柔らかくて軽い景品。重心が低いものが取りやすい傾向があります。',
      'en':
          'Soft and light prize. Those with low center of gravity tend to be easier to win.',
    },
    category: 'prize',
    imageUrl: null,
    relatedTermIds: const ['term_figure'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_figure',
    name: {'ja': 'フィギュア', 'en': 'Figure'},
    reading: 'ふぃぎゅあ',
    description: {
      'ja': '硬くて重い景品。重心の位置を見極めることが重要です。',
      'en': 'Hard and heavy prize. Finding the center of gravity is crucial.',
    },
    category: 'prize',
    imageUrl: null,
    relatedTermIds: const ['term_plush'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_snacks',
    name: {'ja': 'お菓子', 'en': 'Snacks'},
    reading: 'おかし',
    description: {
      'ja': '箱に入ったお菓子類。箱の角を狙って掴むのが基本です。',
      'en':
          'Boxed snacks. Basic strategy is to aim for the corners of the box.',
    },
    category: 'prize',
    imageUrl: null,
    relatedTermIds: const [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_initial_position',
    name: {'ja': '初期位置', 'en': 'Initial Position'},
    reading: 'しょきいち',
    description: {
      'ja': '景品が最初に置かれている位置。店員がセットした状態です。',
      'en': 'The initial position where the prize is first placed by staff.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_arm',
    name: {'ja': 'アーム', 'en': 'Arm / Claw'},
    reading: 'あーむ',
    description: {
      'ja': '景品を掴むための爪。パワーや開き具合は機種や設定によって異なります。',
      'en':
          'The claw used to grab prizes. Power and opening angle vary by machine and settings.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const ['term_ufo_catcher'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_chute',
    name: {'ja': '取り口', 'en': 'Prize Chute'},
    reading: 'とりぐち',
    description: {
      'ja': '景品が落ちてくる穴。ここに景品を落とせば獲得できます。',
      'en':
          'The hole where prizes fall through. Win by dropping the prize here.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_ufo_catcher',
    name: {'ja': 'UFOキャッチャー', 'en': 'UFO Catcher'},
    reading: 'ゆーふぉーきゃっちゃー',
    description: {
      'ja': 'クレーンゲームの登録商標。一般的にはクレーンゲーム全般を指す言葉として使われます。',
      'en':
          'Registered trademark for crane games. Generally used to refer to all crane games.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const ['term_arm'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];
