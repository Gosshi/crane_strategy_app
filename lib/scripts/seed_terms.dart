import 'package:cloud_firestore/cloud_firestore.dart';

/// 用語データの初期データ投入スクリプト
///
/// 使い方:
/// dart run lib/scripts/seed_terms.dart
///
/// 注: Firebase CLIでエミュレータを起動している場合、
/// または本番環境に接続している場合に実行可能です。

Future<void> main() async {
  final firestore = FirebaseFirestore.instance;
  final termsCollection = firestore.collection('terms');

  // 初期用語データ
  final terms = [
    // 基本用語
    {
      'name': 'クッション',
      'reading': 'くっしょん',
      'description': '景品の下に敷かれている台。これを押し出すことで景品を落とす攻略法がある。',
      'category': 'basic',
      'imageUrl': null,
      'relatedTermIds': ['箱押し'],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'アーム',
      'reading': 'あーむ',
      'description': '景品を掴むための機械部分。一定時間後に自動的に閉じて景品を掴む。',
      'category': 'basic',
      'imageUrl': null,
      'relatedTermIds': ['爪', 'アームパワー'],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },
    {
      'name': '爪',
      'reading': 'つめ',
      'description': 'アームの先端部分。この爪の力や開き方で難易度が大きく変わる。',
      'category': 'basic',
      'imageUrl': null,
      'relatedTermIds': ['アーム', '開閉幅'],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'ユーフォーキャッチャー',
      'reading': 'ゆーふぉーきゃっちゃー',
      'description': 'クレーンゲームの正式名称。UFOキャッチャーはセガの登録商標。',
      'category': 'basic',
      'imageUrl': null,
      'relatedTermIds': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },

    // 技術・攻略
    {
      'name': '箱押し',
      'reading': 'はこおし',
      'description': '箱型の景品の側面をアームで押して、少しずつ穴に落としていく技術。',
      'category': 'technique',
      'imageUrl': null,
      'relatedTermIds': ['クッション', '直取り'],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },
    {
      'name': '橋渡し',
      'reading': 'はしわたし',
      'description': '2本のバーの上に景品を渡すように配置し、少しずつずらして落とす技術。',
      'category': 'technique',
      'imageUrl': null,
      'relatedTermIds': ['直取り'],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },
    {
      'name': '直取り',
      'reading': 'じかどり',
      'description': '景品を直接掴んで持ち上げて取る方法。アームパワーが強い台で有効。',
      'category': 'technique',
      'imageUrl': null,
      'relatedTermIds': ['アームパワー', '箱押し'],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },
    {
      'name': 'ハマリ',
      'reading': 'はまり',
      'description': '景品が取れない位置に固定されてしまった状態。店員に相談すると直してもらえることが多い。',
      'category': 'technique',
      'imageUrl': null,
      'relatedTermIds': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },

    // 機械・設定
    {
      'name': 'アームパワー',
      'reading': 'あーむぱわー',
      'description': '爪の力の強さ。この設定が強いほど景品を掴みやすい。',
      'category': 'machine',
      'imageUrl': null,
      'relatedTermIds': ['爪', '直取り'],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },
    {
      'name': '開閉幅',
      'reading': 'かいへいはば',
      'description': '爪が開く幅。この設定によって掴める景品のサイズが変わる。',
      'category': 'machine',
      'imageUrl': null,
      'relatedTermIds': ['爪'],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },

    // 景品関連
    {
      'name': 'プライズ',
      'reading': 'ぷらいず',
      'description': 'クレーンゲームで獲得できる景品のこと。ぬいぐるみ、フィギュア、お菓子など様々。',
      'category': 'prize',
      'imageUrl': null,
      'relatedTermIds': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },
    {
      'name': '重心',
      'reading': 'じゅうしん',
      'description': '景品の重心位置。これを把握することで効率的に景品を動かせる。',
      'category': 'prize',
      'imageUrl': null,
      'relatedTermIds': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },
  ];

  // ignore_for_file: avoid_print
  print('用語データの投入を開始します...');

  for (var i = 0; i < terms.length; i++) {
    final term = terms[i];
    await termsCollection.add(term);
    print('${i + 1}/${terms.length}: ${term['name']} を追加しました');
  }

  print('完了！${terms.length}件の用語を投入しました。');
}
