import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/logger.dart';
import '../models/term.dart';

/// 用語データのリポジトリ
class TermRepository {
  final FirebaseFirestore _firestore;

  TermRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// 全用語を取得
  Future<List<Term>> fetchAllTerms() async {
    final snapshot = await _firestore.collection('terms').orderBy('name').get();

    final terms = snapshot.docs
        .map((doc) => Term.fromMap(doc.id, doc.data()))
        .toList();
    logger.i('[TermRepository] Fetched ${terms.length} terms');
    return terms;
  }

  /// カテゴリ別に用語を取得
  Future<List<Term>> fetchTermsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('terms')
        .where('category', isEqualTo: category)
        .orderBy('name')
        .get();

    return snapshot.docs
        .map((doc) => Term.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// 用語を検索（クライアント側フィルタリング）
  Future<List<Term>> searchTerms(String query) async {
    final allTerms = await fetchAllTerms();

    if (query.isEmpty) return allTerms;

    final lowerQuery = query.toLowerCase();
    return allTerms.where((term) {
      // Search in all language variations
      final nameMatch = term.name.values.any(
        (name) => name.toLowerCase().contains(lowerQuery),
      );
      final descriptionMatch = term.description.values.any(
        (desc) => desc.toLowerCase().contains(lowerQuery),
      );
      final readingMatch = term.reading?.contains(lowerQuery) ?? false;

      return nameMatch || descriptionMatch || readingMatch;
    }).toList();
  }

  /// IDで用語を取得
  Future<Term?> fetchTermById(String id) async {
    final doc = await _firestore.collection('terms').doc(id).get();

    if (!doc.exists) return null;

    return Term.fromMap(doc.id, doc.data()!);
  }

  /// 用語を追加（管理者用）
  Future<void> addTerm(Term term) async {
    await _firestore.collection('terms').add(term.toMap());
  }
}
