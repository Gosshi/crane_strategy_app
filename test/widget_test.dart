import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crane_strategy_app/main.dart';

void main() {
  testWidgets('HomeScreen displays app title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CraneStrategyApp(),
      ),
    );

    // アプリタイトルが表示されていることを確認
    expect(find.text('クレーンゲーム攻略'), findsOneWidget);
  });
}
