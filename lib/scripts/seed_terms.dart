// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;

/// 用語データのシードスクリプト (網羅版)
///
/// エミュレータに投入:
/// dart run lib/scripts/seed_terms.dart
///
/// 本番環境に投入:
/// dart run lib/scripts/seed_terms.dart --prod

const String projectId = 'crane-strategy-app-6da7e';
const String emulatorHost = '127.0.0.1:8080';
const String productionHost = 'firestore.googleapis.com';
const String collectionId = 'terms';

Future<void> main(List<String> args) async {
  final bool isProduction = args.contains('--prod');

  print('--- シードデータの投入を開始します (${isProduction ? "本番環境" : "エミュレータ"}) ---');

  if (isProduction) {
    print('⚠️ 注意: 本番環境にデータを投入します。');
  }

  final now = DateTime.now().toUtc().toIso8601String();
  final timestamp = now.endsWith('Z') ? now : '${now}Z';

  final terms = [
    // 基本用語 (basic)
    {
      'name': 'クレジット',
      'reading': 'くれじっと',
      'description': 'ゲームをプレイできる回数。100円1プレイが一般的。',
      'category': 'basic',
    },
    {
      'name': 'アーム',
      'reading': 'あーむ',
      'description': '景品を掴む・動かすための腕の部分。',
      'category': 'basic',
    },
    {
      'name': 'ツメ',
      'reading': 'つめ',
      'description': 'アームの先端部分。角度や形状が設定の重要ポイント。',
      'category': 'basic',
    },
    {
      'name': '落とし口',
      'reading': 'おとしぐち',
      'description': '景品を落とすゴール地点。シューターとも呼ばれる。',
      'category': 'basic',
    },
    {
      'name': '沼',
      'reading': 'ぬま',
      'description': '景品が取れずに多額の金額を費やしてしまう状態。',
      'category': 'basic',
    },
    {
      'name': 'アシスト',
      'reading': 'あしすと',
      'description': '店員が景品を取りやすい位置に移動させてくれるサービス。',
      'category': 'basic',
    },
    {
      'name': 'ハイエナ',
      'reading': 'はいえな',
      'description': '他人が諦めた、あと少しで取れそうな状態の台を狙う行為。',
      'category': 'basic',
    },

    // 技術・攻略 (technique)
    {
      'name': '縦ハメ',
      'reading': 'たてはめ',
      'description': '橋渡し設定などで、景品を縦向きにしてバーの間に落とす技。',
      'category': 'technique',
    },
    {
      'name': '横ハメ',
      'reading': 'よこはめ',
      'description': '景品を横向きにしてバーの隙間に落とす技。',
      'category': 'technique',
    },
    {
      'name': '角掛け',
      'reading': 'かどがけ',
      'description': '景品の角にツメを引っ掛けて大きく動かす技術。',
      'category': 'technique',
    },
    {
      'name': '押し技',
      'reading': 'おしわざ',
      'description': 'アームを閉じるだけでなく、景品を下方向に押して動かす技。',
      'category': 'technique',
    },
    {
      'name': 'バランスキャッチ',
      'reading': 'ばらんすきゃっち',
      'description': '重心を捉えて景品を持ち上げ、そのまま運んで落とすこと。',
      'category': 'technique',
    },
    {
      'name': 'ネジコン',
      'reading': 'ねじこん',
      'description': 'アームの付け根のネジを調整し、アームの挙動を変えること。',
      'category': 'technique',
    },
    {
      'name': '反動',
      'reading': 'はんどう',
      'description': '景品が動いた際の反動を利用して落とすテクニック。',
      'category': 'technique',
    },
    {
      'name': '突き',
      'reading': 'つき',
      'description': 'アームを景品の隙間に突き刺して強引に動かす技。',
      'category': 'technique',
    },

    // 機械・設定 (machine)
    {
      'name': '確率機',
      'reading': 'かくりつき',
      'description': '一定金額投入されるまでアームパワーが制限される機種。',
      'category': 'machine',
    },
    {
      'name': '橋渡し',
      'reading': 'はしわたし',
      'description': '2本の棒の上に景品が乗っている、最も一般的な設定。',
      'category': 'machine',
    },
    {
      'name': '3本爪',
      'reading': 'さんぼんづめ',
      'description': 'アームが3本ある機種。主にぬいぐるみ等の景品に使われる。',
      'category': 'machine',
    },
    {
      'name': '剣山',
      'reading': 'けんざん',
      'description': '多数の突起の上に景品が置かれている設定。',
      'category': 'machine',
    },
    {
      'name': 'たこ焼き',
      'reading': 'たこやき',
      'description': 'ピンポン玉を掴んで特定の穴に入れる運要素の強い設定。',
      'category': 'machine',
    },
    {
      'name': 'ペラ輪',
      'reading': 'ぺらわ',
      'description': '景品に付いた紙製のリングにアームを引っ掛けて動かす設定。',
      'category': 'machine',
    },
    {
      'name': 'シールド',
      'reading': 'しーるど',
      'description': '落とし口の周りにある壁。低いほど景品が落ちやすい。',
      'category': 'machine',
    },
  ];

  for (final term in terms) {
    await seedTerm(term, timestamp, isProduction);
  }

  print('--- シードデータの投入が完了しました (${terms.length}件) ---');
}

Future<void> seedTerm(
  Map<String, dynamic> data,
  String timestamp,
  bool isProduction,
) async {
  final url = isProduction
      ? Uri.parse(
          'https://$productionHost/v1/projects/$projectId/databases/(default)/documents/$collectionId',
        )
      : Uri.parse(
          'http://$emulatorHost/v1/projects/$projectId/databases/(default)/documents/$collectionId',
        );

  final body = {
    'fields': {
      'name': {'stringValue': data['name']},
      'reading': data['reading'] != null
          ? {'stringValue': data['reading']}
          : {'nullValue': null},
      'description': {'stringValue': data['description']},
      'category': {'stringValue': data['category']},
      'imageUrl': {'nullValue': null},
      'relatedTermIds': {
        'arrayValue': {'values': []},
      },
      'createdAt': {'timestampValue': timestamp},
      'updatedAt': {'timestampValue': timestamp},
    },
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('成功: ${data['name']}');
    } else {
      print('失敗: ${data['name']} (ステータス: ${response.statusCode})');
    }
  } catch (e) {
    print('エラー発生: ${data['name']} ($e)');
  }
}
