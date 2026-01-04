import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crane_strategy_app/main.dart';
import 'package:crane_strategy_app/data/repositories/mock_strategy_repository.dart';
import 'package:crane_strategy_app/data/models/strategy.dart';

// テスト用の遅延なしリポジトリ
class TestStrategyRepository extends MockStrategyRepository {
  @override
  Future<List<Strategy>> fetchStrategies() async {
    return [
      const Strategy(
        id: '1',
        title: {'ja': 'Test Strategy'},
        description: {'ja': 'Test Description'},
        settingType: 'Test Type',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        videoId: 'test_video_id',
      ),
    ];
  }
}

void main() {
  testWidgets('HomeScreen displays app title and strategy list', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mockStrategyRepositoryProvider.overrideWithValue(
            TestStrategyRepository(),
          ),
        ],
        child: const CraneStrategyApp(),
      ),
    );

    // データ読み込み完了まで待機 (pumpAndSettleだと画像読み込み等でタイムアウトするため pump を使用)
    await tester.pump();

    // アプリタイトルが表示されていることを確認
    expect(find.text('クレーンゲーム攻略'), findsOneWidget);

    // リストアイテムが表示されていることを確認
    expect(find.text('Test Strategy'), findsOneWidget);
  });
}
