import '../models/product.dart';
import '../models/strategy.dart';
import '../models/term.dart';

/// 初期データの定義
/// FirestoreへのSeedingとMockリポジトリの両方で使用する

final List<Strategy> initialStrategies = [
  Strategy(
    id: '1',
    title: {
      'ja': '橋渡し・基本の縦ハメ',
      'en': 'Bridge - Basic Vertical Positioning Technique',
    },
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
    title: {'ja': '橋渡し・横ハメのコツ', 'en': 'Bridge - Horizontal Positioning Tips'},
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
  // Additional 21 terms
  Term(
    id: 'term_center_gravity',
    name: {'ja': '重心', 'en': 'Center of Gravity'},
    reading: 'じゅうしん',
    description: {
      'ja': '景品の重さの中心点。重心を把握することで効率的に獲得できます。',
      'en':
          'The center point of the prize weight. Understanding it enables efficient wins.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const ['term_figure'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_claw_power',
    name: {'ja': '爪の力', 'en': 'Claw Power'},
    reading: 'つめのちから',
    description: {
      'ja': 'アームが景品を掴む力。店舗や機種によって異なります。',
      'en': 'The gripping power of the claw. Varies by store and machine.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const ['term_arm'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_probability',
    name: {'ja': '確率機', 'en': 'Probability Machine'},
    reading: 'かくりつき',
    description: {
      'ja': '一定回数プレイ後に爪の力が強くなる設定の機械。',
      'en':
          'Machine with settings that increase claw power after certain plays.',
    },
    category: 'setting',
    imageUrl: null,
    relatedTermIds: const ['term_claw_power'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_bar_setting',
    name: {'ja': 'バー設定', 'en': 'Bar Setting'},
    reading: 'ばーせってい',
    description: {
      'ja': '景品がバーに引っかかっている設定。橋渡しと似た攻略法が使えます。',
      'en':
          'Setting where prize is caught on bars. Similar strategy to bridge technique.',
    },
    category: 'setting',
    imageUrl: null,
    relatedTermIds: const ['term_bridge'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_single_claw',
    name: {'ja': '一本爪', 'en': 'Single Claw'},
    reading: 'いっぽんづめ',
    description: {
      'ja': '爪が1本の機種。主にお菓子などの箱物に使用されます。',
      'en':
          'Machine with a single claw. Mainly used for boxed items like snacks.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const ['term_arm'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_three_claw',
    name: {'ja': '3本爪', 'en': '3-Claw'},
    reading: 'さんぼんづめ',
    description: {
      'ja': '爪が3本の機種。一般的なUFOキャッチャーの形式です。',
      'en': 'Machine with three claws. The most common UFO Catcher format.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const ['term_ufo_catcher'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_horizontal_stuck',
    name: {'ja': '横ハメ', 'en': 'Horizontal Stuck'},
    reading: 'よこはめ',
    description: {
      'ja': '景品が横向きに設置されている状態。天井を使った攻略が有効です。',
      'en':
          'State where prize is placed horizontally. Ceiling technique is effective.',
    },
    category: 'setting',
    imageUrl: null,
    relatedTermIds: const ['term_ceiling'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_vertical_stuck',
    name: {'ja': '縦ハメ', 'en': 'Vertical Stuck'},
    reading: 'たてはめ',
    description: {
      'ja': '景品が縦向きに設置されている状態。橋渡しの基本形です。',
      'en':
          'State where prize is placed vertically. Basic form of bridge technique.',
    },
    category: 'setting',
    imageUrl: null,
    relatedTermIds: const ['term_bridge'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_move_technique',
    name: {'ja': '寄せ', 'en': 'Move Technique'},
    reading: 'よせ',
    description: {
      'ja': '景品を少しずつ取り口に近づける技術の総称。',
      'en': 'General term for techniques to gradually move prize toward chute.',
    },
    category: 'technique',
    imageUrl: null,
    relatedTermIds: const ['term_send'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_turn',
    name: {'ja': '回転', 'en': 'Rotation'},
    reading: 'かいてん',
    description: {
      'ja': '景品を回転させて向きを変える技術。',
      'en': 'Technique to rotate the prize to change its orientation.',
    },
    category: 'technique',
    imageUrl: null,
    relatedTermIds: const ['term_move_technique'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_push',
    name: {'ja': '押し', 'en': 'Push'},
    reading: 'おし',
    description: {
      'ja': 'アームで景品を押して移動させる技術。',
      'en': 'Technique to push and move the prize with the claw.',
    },
    category: 'technique',
    imageUrl: null,
    relatedTermIds: const ['term_move_technique'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_lift',
    name: {'ja': '持ち上げ', 'en': 'Lift'},
    reading: 'もちあげ',
    description: {
      'ja': '景品を一時的に持ち上げて位置を調整する技術。',
      'en': 'Technique to temporarily lift the prize to adjust its position.',
    },
    category: 'technique',
    imageUrl: null,
    relatedTermIds: const ['term_arm'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_staff_help',
    name: {'ja': '店員呼び', 'en': 'Call Staff'},
    reading: 'てんいんよび',
    description: {
      'ja': '景品が取れない位置にある時は店員を呼んで調整してもらいましょう。',
      'en':
          'Call staff to adjust prize position when stuck in unwinnable spot.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_floor_prize',
    name: {'ja': '平置き', 'en': 'Floor Placement'},
    reading: 'ひらおき',
    description: {
      'ja': '景品が床に平らに置かれている設定。難易度が高めです。',
      'en':
          'Setting where prize is placed flat on the floor. Higher difficulty.',
    },
    category: 'setting',
    imageUrl: null,
    relatedTermIds: const ['term_lift'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_tag',
    name: {'ja': 'タグ掴み', 'en': 'Tag Grab'},
    reading: 'たぐつかみ',
    description: {
      'ja': 'ぬいぐるみのタグを爪で掴んで獲得する技術。',
      'en': 'Technique to win by grabbing the tag of a plush toy.',
    },
    category: 'technique',
    imageUrl: null,
    relatedTermIds: const ['term_plush'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_box_corner',
    name: {'ja': '箱の角', 'en': 'Box Corner'},
    reading: 'はこのかど',
    description: {
      'ja': '箱物景品を獲得する際の狙い目。角を掴むと安定します。',
      'en':
          'Target point for boxed prizes. Grabbing corners provides stability.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const ['term_snacks'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_drop',
    name: {'ja': '落下', 'en': 'Drop'},
    reading: 'らっか',
    description: {
      'ja': '景品が取り口に落ちること。これで獲得成功です。',
      'en': 'When the prize falls into the chute. This means you won.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const ['term_chute'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_reset',
    name: {'ja': 'リセット', 'en': 'Reset'},
    reading: 'りせっと',
    description: {
      'ja': '景品を初期位置に戻すこと。店員に依頼できます。',
      'en': 'Returning prize to initial position. Can request from staff.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const ['term_initial_position'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_assist',
    name: {'ja': 'アシスト', 'en': 'Assist'},
    reading: 'あしすと',
    description: {
      'ja': '店員が景品の位置を調整してくれるサービス。',
      'en': 'Service where staff adjusts prize position to help you.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const ['term_staff_help'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_play_credit',
    name: {'ja': 'プレイ回数', 'en': 'Play Credit'},
    reading: 'ぷれいかいすう',
    description: {
      'ja': 'クレーンゲームをプレイできる回数。通常は100円で1-3回です。',
      'en': 'Number of plays available. Usually 1-3 plays per 100 yen.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  Term(
    id: 'term_prize_value',
    name: {'ja': '景品価値', 'en': 'Prize Value'},
    reading: 'けいひんかち',
    description: {
      'ja': '景品の市場価格。高価なものほど難易度が高い傾向があります。',
      'en':
          'Market value of the prize. Higher value often means higher difficulty.',
    },
    category: 'basic',
    imageUrl: null,
    relatedTermIds: const [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];
