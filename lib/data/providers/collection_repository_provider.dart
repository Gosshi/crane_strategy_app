import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/collection_repository.dart';
import '../repositories/firestore_collection_repository.dart';
import '../repositories/mock_collection_repository.dart';

// フラグで切り替え可能にする (基本はFirestoreを使用)
const bool useFirestoreForCollection = true;

final collectionRepositoryProvider = Provider<CollectionRepository>((ref) {
  if (useFirestoreForCollection) {
    return FirestoreCollectionRepository(FirebaseFirestore.instance);
  } else {
    return MockCollectionRepository();
  }
});
