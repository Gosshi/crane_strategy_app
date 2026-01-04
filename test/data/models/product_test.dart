import 'package:flutter_test/flutter_test.dart';
import 'package:crane_strategy_app/data/models/product.dart';

void main() {
  group('Product Model Tests', () {
    const productId = '1234567890123';
    final productData = {
      'name': 'Test Product',
      'imageUrl': 'http://example.com/image.jpg',
      'imagePath': 'products/123.jpg',
      'categories': ['Figure'],
      'centerOfGravity': ['Top'],
      'tags': ['Anime'],
      'strategyIds': ['s1', 's2'],
    };

    test('fromMap creates valid Product instance', () {
      final product = Product.fromMap(productId, productData);

      expect(product.id, productId);
      expect(product.name, 'Test Product');
      expect(product.categories, contains('Figure'));
      expect(product.centerOfGravity, contains('Top'));
      expect(product.tags, contains('Anime'));
      expect(product.strategyIds, hasLength(2));
    });

    test('toMap creates valid Map', () {
      final product = Product(
        id: productId,
        name: 'Test Product',
        imageUrl: 'http://example.com/image.jpg',
        imagePath: 'products/123.jpg',
        categories: ['Figure'],
        centerOfGravity: ['Top'],
        tags: ['Anime'],
        strategyIds: ['s1', 's2'],
      );

      final map = product.toMap();

      expect(map['name'], 'Test Product');
      expect(map['categories'], contains('Figure'));
      expect(map['centerOfGravity'], contains('Top'));
      expect(map['tags'], contains('Anime'));
      expect(map['strategyIds'], hasLength(2));
    });

    test('fromMap handles missing optional fields', () {
      final minimalData = {
        'name': 'Minimal Product',
        'imageUrl': '',
        'strategyIds': <String>[],
      };

      final product = Product.fromMap(productId, minimalData);

      expect(product.categories, isEmpty);
      expect(product.centerOfGravity, isEmpty);
      expect(product.tags, isEmpty);
      expect(product.imagePath, isNull);
    });
  });
}
