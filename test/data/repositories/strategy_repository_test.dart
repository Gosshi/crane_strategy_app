import 'package:flutter_test/flutter_test.dart';
import 'package:crane_strategy_app/data/repositories/mock_strategy_repository.dart';

void main() {
  group('MockStrategyRepository Tests', () {
    late MockStrategyRepository repository;

    setUp(() {
      repository = MockStrategyRepository();
    });

    test('searchProducts finds product by name (case insensitive)', () async {
      // Mock repository has "アニメフィギュア A賞"
      final results = await repository.searchProducts('アニメ');
      expect(results, isNotEmpty);
      expect(results.first.name, contains('アニメ'));
    });

    test('searchProducts finds product by tag', () async {
      // Mock repository has "人気アニメ" tag
      final results = await repository.searchProducts('人気');
      expect(results, isNotEmpty);
      expect(results.first.tags.toString(), contains('人気'));
    });

    test('searchProducts returns empty list for no match', () async {
      final results = await repository.searchProducts(
        'non_existent_product_xyz',
      );
      expect(results, isEmpty);
    });

    test('searchProducts returns all for empty query', () async {
      final results = await repository.searchProducts('');
      expect(results, isNotEmpty);
      expect(results.length, 1); // initialProducts has 1 item
    });
  });
}
