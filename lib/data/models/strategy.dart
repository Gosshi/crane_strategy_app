/// 攻略法のデータモデル
class Strategy {
  final String id;
  final String title;
  final String settingType;
  final String thumbnailUrl;
  final String videoId;

  const Strategy({
    required this.id,
    required this.title,
    required this.settingType,
    required this.thumbnailUrl,
    required this.videoId,
  });
}
