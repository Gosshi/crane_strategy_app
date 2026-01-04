import '../models/collection_item.dart';

abstract class CollectionRepository {
  Future<void> addCollectionItem(String userId, CollectionItem item);
  Future<List<CollectionItem>> fetchCollectionItems(String userId);
}
