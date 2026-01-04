import 'collection_repository.dart';
import '../models/collection_item.dart';

class MockCollectionRepository implements CollectionRepository {
  final List<CollectionItem> _items = [];

  @override
  Future<void> addCollectionItem(String userId, CollectionItem item) async {
    _items.add(item);
  }

  @override
  Future<List<CollectionItem>> fetchCollectionItems(String userId) async {
    return List.from(_items);
  }
}
