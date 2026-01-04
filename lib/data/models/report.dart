import 'package:cloud_firestore/cloud_firestore.dart';

enum ReportType {
  wrongJan, // JANコード間違い
  inappropriateContent, // 不適切なコンテンツ
  other, // その他
}

class Report {
  final String id;
  final String targetProductId;
  final ReportType type;
  final String description;
  final String reporterId;
  final DateTime createdAt;

  const Report({
    required this.id,
    required this.targetProductId,
    required this.type,
    required this.description,
    required this.reporterId,
    required this.createdAt,
  });

  factory Report.fromMap(String id, Map<String, dynamic> map) {
    return Report(
      id: id,
      targetProductId: map['targetProductId'] as String? ?? '',
      type: ReportType.values.firstWhere(
        (e) => e.name == (map['type'] as String?),
        orElse: () => ReportType.other,
      ),
      description: map['description'] as String? ?? '',
      reporterId: map['reporterId'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'targetProductId': targetProductId,
      'type': type.name,
      'description': description,
      'reporterId': reporterId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
