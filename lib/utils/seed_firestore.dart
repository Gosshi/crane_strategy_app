import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../data/seeds/initial_data.dart';

/// Firestoreに初期データを投入する
/// 既にデータがある場合は上書きする
Future<void> seedFirestoreData() async {
  if (!kDebugMode) {
    debugPrint('Seeding is only allowed in debug mode.');
    return;
  }

  final firestore = FirebaseFirestore.instance;

  try {
    // 攻略法データの投入
    final strategiesBatch = firestore.batch();
    final now = Timestamp.now();

    for (final strategy in initialStrategies) {
      final docRef = firestore.collection('strategies').doc(strategy.id);
      final data = strategy.toMap();
      data['updatedAt'] = now; // 現在時刻で上書き
      strategiesBatch.set(docRef, data);
    }
    await strategiesBatch.commit();
    debugPrint(
      'Strategies seeding completed: ${initialStrategies.length} items',
    );

    // 商品データの投入
    final productsBatch = firestore.batch();
    for (final product in initialProducts) {
      final docRef = firestore.collection('products').doc(product.id);
      productsBatch.set(docRef, product.toMap());
    }
    await productsBatch.commit();
    debugPrint('Products seeding completed: ${initialProducts.length} items');

    // 用語データの投入
    final termsBatch = firestore.batch();
    for (final term in initialTerms) {
      final docRef = firestore.collection('terms').doc(term.id);
      termsBatch.set(docRef, term.toMap());
    }
    await termsBatch.commit();
    debugPrint('Terms seeding completed: ${initialTerms.length} items');
  } catch (e) {
    debugPrint('Seeding failed: $e');
    rethrow;
  }
}

/// 拡張攻略戦略データを追加（正しいMap形式）
Future<void> addExtendedStrategies() async {
  if (!kDebugMode) {
    debugPrint('Extended seeding is only allowed in debug mode.');
    return;
  }

  final firestore = FirebaseFirestore.instance;
  final now = Timestamp.now();

  final strategies = [
    // テスト用: アニメーション図解を表示する橋渡し攻略データ
    {
      'title': {'ja': '橋渡し攻略 - 横ハメ図解', 'en': 'Bridge Strategy - Sideways Drop'},
      'description': {
        'ja': '''橋渡し攻略の代表的な手法「横ハメ」をアニメーション図解で学べます。

【横ハメの手順】
1. 景品が2本のバーの上に水平に乗っている
2. アームを景品の端に合わせて下げる
3. アームで押して景品を90度回転させる
4. 景品が縦向きになり、バーの間を通り抜けて落下

図解のアニメーションで実際の動きを確認できます。''',
        'en': '''Learn the "sideways drop" technique with animated diagrams.

【Steps】
1. Prize rests horizontally on two bars
2. Position claw at prize edge
3. Push to rotate prize 90 degrees
4. Prize becomes vertical and drops through bars

Watch the animated diagram to understand the motion.''',
      },
      'thumbnailUrl': '',
      'videoId': '',
      'settingType': '橋渡し',
      'updatedAt': now,
    },
    {
      'title': {'ja': '重量設定攻略 - 重い景品の取り方', 'en': 'Heavy Prize Strategy'},
      'description': {
        'ja': '''重量設定の台では、以下のポイントが重要です：

【基本戦略】
1. アームパワーを確認：最初の1-2回は様子見
2. 景品の重心を見極める
3. 少しずつ移動させる戦略が有効

重い景品は複数回プレイが前提。計画的にお金を使いましょう。''',
        'en': '''For heavy prize machines:

【Basic Strategy】
1. Check claw power with first tries
2. Identify center of gravity  
3. Move gradually

Heavy prizes require multiple plays.''',
      },
      'thumbnailUrl':
          'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      'videoId': 'dQw4w9WgXcQ',
      'settingType': '重量設定',
      'updatedAt': now,
    },
    {
      'title': {'ja': 'アームパワー別攻略', 'en': 'Claw Power Strategy'},
      'description': {
        'ja': '''アームのパワー設定によって戦略を変えることが重要です。

【弱パワー】景品を少しずつずらす
【中パワー】標準的な橋渡しが有効
【強パワー】一気に取れる可能性あり（注意）''',
        'en': '''Adjust strategy based on claw power:

【Weak】Gradual sliding
【Medium】Standard bridge
【Strong】Quick win possible''',
      },
      'thumbnailUrl':
          'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      'videoId': 'dQw4w9WgXcQ',
      'settingType': 'アームパワー',
      'updatedAt': now,
    },
    {
      'title': {'ja': 'ぬいぐるみ専用攻略', 'en': 'Plushie Strategy'},
      'description': {
        'ja': '''ぬいぐるみは柔らかく形が変わるため、専用の戦略が必要です。

【効果的】タグ引っかけ、耳や手足を狙う
【注意】柔らかすぎる場合は引っかけ一択''',
        'en': '''Plushies need special techniques:

【Effective】Tag hooking, target ears/limbs
【Tips】Use hooking if too soft''',
      },
      'thumbnailUrl':
          'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      'videoId': 'dQw4w9WgXcQ',
      'settingType': 'ぬいぐるみ',
      'updatedAt': now,
    },
    {
      'title': {'ja': 'フィギュア専用攻略', 'en': 'Figure/Box Strategy'},
      'description': {
        'ja': '''箱入りフィギュアは硬くて重いため、専用の戦略が必要です。

【基本】箱の角を狙う、橋渡しで少しずつ移動''',
        'en': '''Box figures require patience:

【Basic】Target corners, bridge gradually''',
      },
      'thumbnailUrl':
          'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      'videoId': 'dQw4w9WgXcQ',
      'settingType': 'フィギュア',
      'updatedAt': now,
    },
    {
      'title': {'ja': 'お菓子の取り方', 'en': 'Snack Strategy'},
      'description': {
        'ja': '''お菓子は軽くて取りやすい景品ですが、コツがあります。

【効果的】押し出し、引っかけ、重ね取り''',
        'en': '''Snacks are light but tricky:

【Methods】Push out, hook, multi-grab''',
      },
      'thumbnailUrl':
          'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      'videoId': 'dQw4w9WgXcQ',
      'settingType': 'お菓子',
      'updatedAt': now,
    },
    {
      'title': {'ja': '箱物攻略', 'en': 'Large Box Strategy'},
      'description': {
        'ja': '''大きな箱の景品は重量があり、特別な戦略が必要です。

【基本】角を利用、少しずつ移動、計画的に''',
        'en': '''Large boxes need strategy:

【Basic】Use corners, move gradually''',
      },
      'thumbnailUrl':
          'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      'videoId': 'dQw4w9WgXcQ',
      'settingType': '箱物',
      'updatedAt': now,
    },
    {
      'title': {'ja': '引っかけ技', 'en': 'Hooking Technique'},
      'description': {
        'ja': '''タグや紐を引っかける技術は基本中の基本です。

【対象】タグ、紐、耳や手足''',
        'en': '''Hooking is fundamental:

【Target】Tags, strings, ears/limbs''',
      },
      'thumbnailUrl':
          'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      'videoId': 'dQw4w9WgXcQ',
      'settingType': '引っかけ',
      'updatedAt': now,
    },
    {
      'title': {'ja': '回転技', 'en': 'Rotation Technique'},
      'description': {
        'ja': '''景品を回転させて有利な位置に調整する高度なテクニックです。

【使用】景品が斜め、タグが見えない時''',
        'en': '''Advanced rotation technique:

【When】Prize angled, tag not visible''',
      },
      'thumbnailUrl':
          'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      'videoId': 'dQw4w9WgXcQ',
      'settingType': '回転',
      'updatedAt': now,
    },
    {
      'title': {'ja': '押し込み技', 'en': 'Push Technique'},
      'description': {
        'ja': '''アームで景品を押し込んで落とすシンプルながら効果的な技術です。

【対象】軽いもの、穴の近くの景品''',
        'en': '''Simple but effective:

【Best】Light items, near hole''',
      },
      'thumbnailUrl':
          'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      'videoId': 'dQw4w9WgXcQ',
      'settingType': '押し込み',
      'updatedAt': now,
    },
    {
      'title': {'ja': 'タイミング重視の取り方', 'en': 'Timing Strategy'},
      'description': {
        'ja': '''タイミングが重要な台の攻略法です。

【対象】揺れている台、回転している台''',
        'en': '''Timing machines need practice:

【Types】Swinging, rotating platforms''',
      },
      'thumbnailUrl':
          'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
      'videoId': 'dQw4w9WgXcQ',
      'settingType': 'タイミング',
      'updatedAt': now,
    },
  ];

  try {
    debugPrint('拡張攻略戦略データを追加中（Map形式）...');

    for (var i = 0; i < strategies.length; i++) {
      await firestore.collection('strategies').add(strategies[i]);
      debugPrint('${i + 1}/${strategies.length} 完了: ${strategies[i]['title']}');
    }

    debugPrint('全ての拡張攻略戦略データを追加しました！');
    debugPrint('合計: ${strategies.length}件（バイリンガル・動画付き）');
  } catch (e) {
    debugPrint('Extended strategy seeding failed: $e');
    rethrow;
  }
}
