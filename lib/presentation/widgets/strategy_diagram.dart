import 'dart:math';
import 'package:flutter/material.dart';
import 'package:crane_strategy_app/presentation/painters/bridge_painter.dart';

/// 攻略法の図解を表示するウィジェット
///
/// クレーンゲームの攻略タイプに応じて、CustomPainterを使用した
/// 図解を16:9のアスペクト比で表示します。
///
/// ## サポートされている攻略タイプ
/// - `'bridge'` または `'橋渡し'`: 橋渡し設定の図解
/// - (将来) `'kenzan'`: 剣山設定の図解
/// - (将来) `'3-claw'`: 3本爪設定の図解
///
/// ## 使用例
/// ```dart
/// StrategyDiagram(
///   strategyType: 'bridge',
///   prizeAngle: 15 * pi / 180,  // 15度傾斜
///   centerOfGravity: Offset(0.6, 0.5),  // やや右寄りの重心
///   animate: true,  // アニメーションを有効化
/// )
/// ```
class StrategyDiagram extends StatefulWidget {
  /// 攻略タイプ（例: 'bridge', 'kenzan', '3-claw'）
  final String strategyType;

  /// 景品の傾き角度（ラジアン、オプション）
  final double? prizeAngle;

  /// 重心の位置（0.0-1.0の相対座標、オプション）
  final Offset? centerOfGravity;

  /// アニメーションを有効にするかどうか（デフォルト: true）
  final bool animate;

  const StrategyDiagram({
    super.key,
    required this.strategyType,
    this.prizeAngle,
    this.centerOfGravity,
    this.animate = true,
  });

  @override
  State<StrategyDiagram> createState() => _StrategyDiagramState();
}

class _StrategyDiagramState extends State<StrategyDiagram>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _angleAnimation;
  late Animation<Offset> _gravityAnimation;

  @override
  void initState() {
    super.initState();

    // アニメーションコントローラーの初期化（3秒で1サイクル）
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // 角度のアニメーション（0度 → 15度 → 0度）
    _angleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 15 * pi / 180,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 15 * pi / 180,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    // 重心のアニメーション（中央 → 右寄り → 中央）
    _gravityAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0.5, 0.5),
          end: const Offset(0.65, 0.5),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0.65, 0.5),
          end: const Offset(0.5, 0.5),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    // アニメーションが有効な場合、繰り返し再生
    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StrategyDiagram oldWidget) {
    super.didUpdateWidget(oldWidget);
    // アニメーション設定が変更された場合
    if (oldWidget.animate != widget.animate) {
      if (widget.animate) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildDiagram(),
        ),
      ),
    );
  }

  /// strategyTypeに応じて適切な図解を構築
  Widget _buildDiagram() {
    // strategyTypeに応じて適切なPainterを選択
    if (widget.animate) {
      // アニメーション有効時はAnimatedBuilderを使用
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final painter = _getPainter(
            angle: _angleAnimation.value,
            gravity: _gravityAnimation.value,
          );

          if (painter != null) {
            return CustomPaint(painter: painter, size: Size.infinite);
          } else {
            return _buildPlaceholder();
          }
        },
      );
    } else {
      // アニメーション無効時は静的な図解を表示
      final painter = _getPainter(
        angle: widget.prizeAngle ?? 0.0,
        gravity: widget.centerOfGravity ?? const Offset(0.5, 0.5),
      );

      if (painter != null) {
        return CustomPaint(painter: painter, size: Size.infinite);
      } else {
        return _buildPlaceholder();
      }
    }
  }

  /// 未実装タイプのプレースホルダーを構築
  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '「${widget.strategyType}」の図解は未実装です',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// strategyTypeに応じた適切なCustomPainterを返す
  ///
  /// 未実装のタイプの場合はnullを返します。
  CustomPainter? _getPainter({required double angle, required Offset gravity}) {
    // 空文字列チェック
    if (widget.strategyType.isEmpty) {
      return null;
    }

    switch (widget.strategyType.toLowerCase()) {
      case 'bridge':
      case '橋渡し':
        return BridgePainter(prizeAngle: angle, centerOfGravity: gravity);
      // 将来の拡張用
      // case 'kenzan':
      // case '剣山':
      //   return KenzanPainter(
      //     prizeAngle: angle,
      //     centerOfGravity: gravity,
      //   );
      // case '3-claw':
      // case '3本爪':
      //   return ThreeClawPainter(
      //     prizeAngle: angle,
      //     centerOfGravity: gravity,
      //   );
      default:
        return null;
    }
  }
}
