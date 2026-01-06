import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crane_strategy_app/data/repositories/mock_strategy_repository.dart';
import 'package:crane_strategy_app/data/providers/strategy_repository_provider.dart';
import 'package:crane_strategy_app/data/models/strategy.dart';
import 'package:crane_strategy_app/data/models/product.dart';
import 'package:crane_strategy_app/presentation/screens/scan_result_screen.dart';

// モックリポジトリ
class MockTestRepository extends MockStrategyRepository {
  @override
  Future<Product?> fetchProductByBarcode(String barcode) async {
    if (barcode == 'found') {
      return const Product(
        id: 'found',
        name: 'Test Product',
        imageUrl: 'http://example.com/img.png',
        strategyIds: ['1'],
      );
    }
    return null;
  }

  @override
  Future<List<Strategy>> fetchStrategiesByIds(List<String> ids) async {
    return [
      Strategy(
        id: '1',
        title: {'ja': 'Test Strategy'},
        description: {'ja': 'Desc'},
        settingType: 'Type',
        thumbnailUrl: 'http://example.com/thumb.png',
        videoId: 'vid',
        updatedAt: DateTime.now(),
      ),
    ];
  }
}

void main() {
  // 画像読み込みをモック化 (あるいはエラーを許容)
  /*
  setUpAll(() {
    // NetworkImageのモックが必要だが、CachedNetworkImageが内部でハンドリングするため
    // テスト環境では placeholder や errorWidget が表示されることを確認できれば良い
  });
  */

  testWidgets('ScanResultScreen displays product when found', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          strategyRepositoryProvider.overrideWithValue(MockTestRepository()),
        ],
        child: const MaterialApp(home: ScanResultScreen(barcode: 'found')),
      ),
    );

    // ローディング中
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(); // データ取得完了

    // 商品名表示
    expect(find.text('Test Product'), findsOneWidget);

    await tester.pump(); // 攻略法の読み込み完了

    // 攻略法表示
    expect(find.text('Test Strategy'), findsOneWidget);
  });

  testWidgets('ScanResultScreen displays not found message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          strategyRepositoryProvider.overrideWithValue(MockTestRepository()),
        ],
        child: const MaterialApp(home: ScanResultScreen(barcode: 'not_found')),
      ),
    );

    await tester.pump(); // Firestore lookup finished -> Yahoo Search starts

    // Yahoo検索中のローディング確認
    expect(find.text('Yahoo!ショッピングから情報を検索中...'), findsOneWidget);

    // 500ms待機 (コード内の遅延) + タイムアウト待ち
    await tester.pump(const Duration(milliseconds: 600));
    // さらに非同期処理完了待ち
    await tester.pumpAndSettle();

    expect(find.text('商品が見つかりませんでした'), findsOneWidget);
    expect(find.text('スキャンしたコード: not_found'), findsOneWidget);
  });
}
