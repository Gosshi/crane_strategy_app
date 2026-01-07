import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/ad_manager.dart';
import '../../utils/logger.dart';

/// リワード広告視聴ボタンウィジェット
///
/// ユーザーが広告を視聴することでプレミアム機能を24時間解放するボタンです。
class RewardAdButton extends ConsumerWidget {
  /// ボタンに表示するタイトル
  final String title;

  /// 広告視聴後のコールバック
  /// 広告を最後まで視聴した場合に呼ばれます
  final VoidCallback onRewarded;

  const RewardAdButton({
    required this.title,
    required this.onRewarded,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.play_circle_outline),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      onPressed: () async {
        // リワード広告を表示
        logger.d('[RewardAdButton] Requesting reward ad');
        final reward = await AdManager().showRewardedAd();
        logger.d('[RewardAdButton] Reward result: $reward');

        if (reward != null) {
          // 広告を視聴したので報酬を付与
          logger.i('[RewardAdButton] Calling onRewarded callback');
          onRewarded();

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✨ 24時間プレミアム機能が解放されました！'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else {
          // 広告が表示できなかったか、ユーザーがキャンセルした
          logger.w('[RewardAdButton] Reward is null');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('広告の読み込みに失敗しました。後でもう一度お試しください。'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      },
    );
  }
}
