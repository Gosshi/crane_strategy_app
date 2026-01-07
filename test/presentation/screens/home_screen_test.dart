import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:crane_strategy_app/l10n/app_localizations.dart';
import 'package:crane_strategy_app/presentation/screens/home_screen.dart';
import 'package:crane_strategy_app/data/repositories/mock_strategy_repository.dart';
import 'package:crane_strategy_app/data/providers/strategy_repository_provider.dart';
import 'package:crane_strategy_app/data/models/product.dart';
import 'package:crane_strategy_app/data/models/strategy.dart';

// Mock Repository
class MockHomeTestRepository extends MockStrategyRepository {
  @override
  Future<List<Strategy>> fetchStrategies() async {
    return [
      Strategy(
        id: '1',
        title: {'ja': 'Home Strategy'},
        description: {'ja': 'Desc'},
        settingType: 'Bridge',
        thumbnailUrl: 'thumb',
        videoId: 'vid',
        updatedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    if (query == 'found') {
      return [
        const Product(
          id: 'p1',
          name: 'Found Product',
          imageUrl: 'img',
          categories: ['Figure'],
          tags: ['Anime'],
          strategyIds: ['1'],
        ),
      ];
    }
    return [];
  }
}

void main() {
  testWidgets('HomeScreen displays strategies initially', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          strategyRepositoryProvider.overrideWithValue(
            MockHomeTestRepository(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ja')],
          locale: const Locale('ja'),
          home: const HomeScreen(),
        ),
      ),
    );

    // Initial load might need pump
    await tester.pumpAndSettle();

    // Updated expectations to match AppLocalizations
    expect(find.text('クレナビ'), findsOneWidget);
    expect(find.text('Home Strategy'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Search input shows results', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          strategyRepositoryProvider.overrideWithValue(
            MockHomeTestRepository(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ja')],
          locale: const Locale('ja'),
          home: const HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Enter query
    await tester.enterText(find.byType(TextField), 'found');
    await tester.pumpAndSettle(); // Wait for debounce or state update

    // Check result
    expect(find.text('Found Product'), findsOneWidget);
    expect(
      find.text('Home Strategy'),
      findsNothing,
    ); // List replaced by search result
  });

  testWidgets('Search shows empty message when not found', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          strategyRepositoryProvider.overrideWithValue(
            MockHomeTestRepository(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ja')],
          locale: const Locale('ja'),
          home: const HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Enter query
    await tester.enterText(find.byType(TextField), 'unknown');
    await tester.pumpAndSettle();

    expect(find.text('見つかりませんでした'), findsOneWidget);
  });
}
