/// 攻略法のデータモデル
class Strategy {
  final String id;
  final Map<String, String> title;
  final Map<String, String> description;
  final String settingType;
  final String thumbnailUrl;
  final String videoId;

  const Strategy({
    required this.id,
    required this.title,
    required this.description,
    required this.settingType,
    required this.thumbnailUrl,
    required this.videoId,
  });

  /// Firestoreのデータからモデルを作成
  factory Strategy.fromMap(String id, Map<String, dynamic> map) {
    return Strategy(
      id: id,
      title: Map<String, String>.from(map['title'] ?? {}),
      description: Map<String, String>.from(map['description'] ?? {}),
      settingType: map['settingType'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      videoId: map['videoId'] ?? '',
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
    };
  }
}
