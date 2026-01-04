import 'package:cloud_firestore/cloud_firestore.dart';
import 'collection_repository.dart';
import '../models/collection_item.dart';

class FirestoreCollectionRepository implements CollectionRepository {
  final FirebaseFirestore _firestore;

  FirestoreCollectionRepository(this._firestore);

  @override
  Future<void> addCollectionItem(String userId, CollectionItem item) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('collections')
        .doc(item.id)
        .set(item.toMap());
  }

  @override
  Future<List<CollectionItem>> fetchCollectionItems(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('collections')
        .orderBy('acquiredAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => CollectionItem.fromMap(doc.id, doc.data()))
        .toList();
  }
}
