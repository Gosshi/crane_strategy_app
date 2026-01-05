class UserLevelService {
  static const List<UserRank> _ranks = [
    UserRank(name: 'ビギナー', threshold: 0, color: 0xFF808080), // Gray
    UserRank(name: 'クレーンゲーマー', threshold: 5, color: 0xFF4CAF50), // Green
    UserRank(name: '熟練の攻略家', threshold: 20, color: 0xFF2196F3), // Blue
    UserRank(name: '神の手', threshold: 50, color: 0xFFFFD700), // Gold
  ];

  static UserRank getRank(int collectionCount) {
    for (var i = _ranks.length - 1; i >= 0; i--) {
      if (collectionCount >= _ranks[i].threshold) {
        return _ranks[i];
      }
    }
    return _ranks.first;
  }

  static UserLevelProgress getProgress(int collectionCount) {
    final currentRank = getRank(collectionCount);
    final currentIndex = _ranks.indexOf(currentRank);

    if (currentIndex == _ranks.length - 1) {
      // 最高ランク
      return UserLevelProgress(
        currentRank: currentRank,
        nextRank: null,
        currentCount: collectionCount,
        requiredCountForNext: null,
        progress: 1.0,
      );
    }

    final nextRank = _ranks[currentIndex + 1];
    final countInLevel = collectionCount - currentRank.threshold;
    final requiredForLevel = nextRank.threshold - currentRank.threshold;
    final progress = countInLevel / requiredForLevel;

    return UserLevelProgress(
      currentRank: currentRank,
      nextRank: nextRank,
      currentCount: collectionCount,
      requiredCountForNext: nextRank.threshold,
      progress: progress.clamp(0.0, 1.0),
    );
  }
}

class UserRank {
  final String name;
  final int threshold;
  final int color;

  const UserRank({
    required this.name,
    required this.threshold,
    required this.color,
  });
}

class UserLevelProgress {
  final UserRank currentRank;
  final UserRank? nextRank;
  final int currentCount;
  final int? requiredCountForNext;
  final double progress;

  const UserLevelProgress({
    required this.currentRank,
    required this.nextRank,
    required this.currentCount,
    required this.requiredCountForNext,
    required this.progress,
  });
}
