import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../data/models/strategy.dart';
import '../../data/models/report.dart';
import '../../data/providers/report_repository_provider.dart';
import '../../data/providers/auth_provider.dart';
import '../widgets/strategy_diagram.dart';

/// 攻略法詳細画面
class DetailScreen extends ConsumerStatefulWidget {
  final Strategy strategy;

  const DetailScreen({super.key, required this.strategy});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  late YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    // videoIdが存在する場合のみYouTubeコントローラーを初期化
    if (widget.strategy.videoId.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.strategy.videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
          forceHD: false,
        ),
      );
    } else {
      _controller = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller?.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final title =
        widget.strategy.title['ja'] ??
        widget.strategy.title.values.firstOrNull ??
        '';
    final description =
        widget.strategy.description['ja'] ??
        widget.strategy.description.values.firstOrNull ??
        '';

    // videoIdがある場合はYouTubeプレイヤー、ない場合は通常のScaffold
    if (_controller != null) {
      return YoutubePlayerBuilder(
        onExitFullScreen: () {
          SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        },
        player: YoutubePlayer(
          controller: _controller!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: colorScheme.primary,
          progressColors: ProgressBarColors(
            playedColor: colorScheme.primary,
            handleColor: colorScheme.primary,
            bufferedColor: colorScheme.primaryContainer,
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        ),
        builder: (context, player) {
          return _buildScaffold(
            context,
            title,
            description,
            theme,
            colorScheme,
            // YouTube Player
            kIsWeb ? AspectRatio(aspectRatio: 16 / 9, child: player) : player,
          );
        },
      );
    } else {
      // videoIdがない場合はStrategyDiagramを表示
      return _buildScaffold(
        context,
        title,
        description,
        theme,
        colorScheme,
        // Strategy Diagram
        StrategyDiagram(strategyType: widget.strategy.settingType),
      );
    }
  }

  /// Scaffoldを構築する共通メソッド
  Widget _buildScaffold(
    BuildContext context,
    String title,
    String description,
    ThemeData theme,
    ColorScheme colorScheme,
    Widget mediaWidget,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                _showReportDialog(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, color: theme.colorScheme.error),
                    const SizedBox(width: 8),
                    const Text('情報の誤りを報告'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media Widget (YouTube Player または StrategyDiagram)
            mediaWidget,

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags (Chips)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildNeonChip(
                        context,
                        label: widget.strategy.settingType,
                        icon: Icons.settings,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section Title
                  _buildSectionTitle(context, '攻略のポイント'),
                  const SizedBox(height: 12),

                  // Description Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Hint Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.tertiary.withValues(alpha: 0.2),
                          colorScheme.tertiary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.tertiary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: colorScheme.tertiary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '動画を見ながら、アームの動きや重心の位置をよく観察してみましょう！タイミングが重要です。',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildNeonChip(
    BuildContext context, {
    required String label,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showReportDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final descriptionController = TextEditingController();
    var selectedType = ReportType.wrongJan;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            title: Text('情報の誤りを報告', style: theme.textTheme.titleMedium),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('報告理由を選択してください:'),
                  const SizedBox(height: 8),
                  DropdownButton<ReportType>(
                    value: selectedType,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: ReportType.wrongJan,
                        child: Text('JANコード・商品情報の間違い'),
                      ),
                      DropdownMenuItem(
                        value: ReportType.inappropriateContent,
                        child: Text('不適切なコンテンツ'),
                      ),
                      DropdownMenuItem(
                        value: ReportType.other,
                        child: Text('その他'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => selectedType = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: '詳細 (任意)',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('キャンセル'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('送信'),
                onPressed: () async {
                  final user = ref.read(currentUserProvider);
                  if (user == null) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ログインが必要です')),
                      );
                    }
                    return;
                  }
                  final userId = user.uid;
                  final report = Report(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    targetProductId: widget.strategy.id,
                    type: selectedType,
                    description: descriptionController.text,
                    reporterId: userId,
                    createdAt: DateTime.now(),
                  );

                  try {
                    await ref.read(reportRepositoryProvider).addReport(report);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('報告を送信しました。ご協力ありがとうございます。'),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('エラーが発生しました: $e')));
                    }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
