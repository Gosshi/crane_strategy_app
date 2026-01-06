import 'package:cloud_firestore/cloud_firestore.dart';

/// 用語データモデル
class Term {
  final String id;
  final String name;
  final String? reading;
  final String description;
  final String category;
  final String? imageUrl;
  final List<String> relatedTermIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Term({
    required this.id,
    required this.name,
    this.reading,
    required this.description,
    required this.category,
    this.imageUrl,
    this.relatedTermIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Firestoreのデータからモデルを作成
  factory Term.fromMap(String id, Map<String, dynamic> map) {
    return Term(
      id: id,
      name: map['name'] ?? '',
      reading: map['reading'],
      description: map['description'] ?? '',
      category: map['category'] ?? 'basic',
      imageUrl: map['imageUrl'],
      relatedTermIds: List<String>.from(map['relatedTermIds'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// モデルをFirestore用データに変換
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'reading': reading,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'relatedTermIds': relatedTermIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

/// 用語のカテゴリ
class TermCategory {
  static const String basic = 'basic';
  static const String technique = 'technique';
  static const String prize = 'prize';
  static const String machine = 'machine';

  static const Map<String, String> labels = {
    basic: '基本用語',
    technique: '技術・攻略',
    prize: '景品関連',
    machine: '機械・設定',
  };
}
