import 'package:cloud_firestore/cloud_firestore.dart';

/// 用語データモデル
class Term {
  final String id;
  final Map<String, String> name; // Multilingual: {"ja": "橋渡し", "en": "Bridge"}
  final String? reading; // Japanese reading only
  final Map<String, String> description; // Multilingual
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
      name: _parseMultilingualField(map['name']),
      reading: map['reading'],
      description: _parseMultilingualField(map['description']),
      category: map['category'] ?? 'basic',
      imageUrl: map['imageUrl'],
      relatedTermIds: List<String>.from(map['relatedTermIds'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Parse multilingual field - supports both String (legacy) and Map (new)
  static Map<String, String> _parseMultilingualField(dynamic field) {
    if (field == null) {
      return {'ja': ''};
    } else if (field is String) {
      // Legacy format: treat as Japanese
      return {'ja': field};
    } else if (field is Map) {
      return Map<String, String>.from(field);
    }
    return {'ja': ''};
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
}
