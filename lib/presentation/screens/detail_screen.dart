import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../data/models/strategy.dart';

/// 攻略法詳細画面
class DetailScreen extends StatefulWidget {
  final Strategy strategy;

  const DetailScreen({
    super.key,
    required this.strategy,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.strategy.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        forceHD: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // ページを離れる際にプレーヤーを一時停止
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // フルスクリーン終了時にステータスバーを元に戻す
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: colorScheme.primary,
        progressColors: ProgressBarColors(
          playedColor: colorScheme.primary,
          handleColor: colorScheme.primary,
          bufferedColor: colorScheme.primaryContainer,
          backgroundColor: colorScheme.surfaceContainerHighest,
        ),
        onReady: () {
          debugPrint('YouTube Player is ready.');
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.strategy.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            centerTitle: true,
            elevation: 0,
            scrolledUnderElevation: 2,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // YouTube プレーヤー
                // Web の場合は AspectRatio でラップして表示
                if (kIsWeb)
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: player,
                  )
                else
                  player,

                // コンテンツエリア
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 設定タイプのチップ
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildChip(
                            context,
                            icon: Icons.settings,
                            label: widget.strategy.settingType,
                            color: colorScheme.primaryContainer,
                            textColor: colorScheme.onPrimaryContainer,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // タイトル
                      Text(
                        widget.strategy.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 区切り線
                      Divider(color: colorScheme.outlineVariant),
                      const SizedBox(height: 16),

                      // 解説セクション
                      Text(
                        '攻略のポイント',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 解説テキスト（ダミー）
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                        child: Text(
                          _getDescriptionText(widget.strategy.settingType),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ヒントカード
                      Card(
                        color: colorScheme.tertiaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: colorScheme.onTertiaryContainer,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '動画を見ながら、アームの動きをよく観察してみましょう！',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onTertiaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  String _getDescriptionText(String settingType) {
    switch (settingType) {
      case '橋渡し':
        return '''橋渡し設定は、クレーンゲームの中でも基本的な設定の一つです。

【縦ハメのコツ】
1. まずは景品の端をアームで押し込む
2. 景品が橋の隙間に落ち込む角度を作る
3. 反対側を持ち上げて落とす

重要なのは「一度で取ろうとしない」こと。少しずつ角度をつけていきましょう。''';
      case '3本爪':
        return '''3本爪設定は、アームの力が弱いため工夫が必要です。

【攻略のコツ】
1. 景品のバランスが崩れやすい位置を狙う
2. 爪を景品の下にしっかり入れる
3. 手前に引き出すイメージで操作

確率機の場合もあるので、店員さんに確認してみるのも◎''';
      default:
        return '''この設定の攻略法を動画で確認してみましょう。

景品の形状や重心によって最適な取り方が変わります。繰り返し練習することで、コツが掴めるようになります。''';
    }
  }
}
