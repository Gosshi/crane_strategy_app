import 'package:cloud_firestore/cloud_firestore.dart';

/// 攻略法のデータモデル
class Strategy {
  final String id;
  final Map<String, String> title;
  final Map<String, String> description;
  final String settingType;
  final String thumbnailUrl;
  final String videoId;
  final DateTime updatedAt;

  const Strategy({
    required this.id,
    required this.title,
    required this.description,
    required this.settingType,
    required this.thumbnailUrl,
    required this.videoId,
    required this.updatedAt,
  });

  /// Firestoreのデータからモデルを作成
  factory Strategy.fromMap(String id, Map<String, dynamic> map) {
    return Strategy(
      id: id,
      title: Map<String, String>.from(map['title'] ?? {}),
      description: Map<String, String>.from(map['description'] ?? {}),
      settingType: map['settingType'] ?? '',
      thumbnailUrl:
          map['thumbnailUrl'] != null &&
              (map['thumbnailUrl'] as String).isNotEmpty
          ? map['thumbnailUrl'] as String
          : 'https://via.placeholder.com/640x360.png?text=No+Thumbnail',
      videoId: map['videoId'] ?? '',
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// モデルをFirestore用データに変換
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'settingType': settingType,
      'thumbnailUrl': thumbnailUrl,
      'videoId': videoId,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
