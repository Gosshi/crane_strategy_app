import 'dart:math';
import 'package:flutter/material.dart';
import 'package:crane_strategy_app/presentation/painters/bridge_painter.dart';

/// 橋渡し攻略のアニメーションタイプ
enum BridgeAnimationType {
  /// 縦ハメ: 景品を縦向きにしてバーの間に落とす
  vertical,

  /// 横ハメ: 景品を横向きのまま片側を沈めて落とす
  horizontal,
}

/// 攻略法の図解を表示するウィジェット
///
/// クレーンゲームの攻略タイプに応じて、CustomPainterを使用した
/// 図解を16:9のアスペクト比で表示します。
///
/// ## 橋渡し攻略のアニメーション
///
/// ### 縦ハメ（Vertical Fitting）
/// 景品をバーに対して垂直になるよう制御し、左右に振りながら落とす王道戦略。
/// 1. 初期回転: 角を狙って斜めにする
/// 2. 対角線攻撃: 左右交互に振ってシーソーのように動かす
/// 3. フィニッシュ: 縦向きになったら押して落下
///
/// ### 横ハメ（Horizontal Fitting）
/// 景品をバーに対して平行に保ち、片側を脱輪させて落とす戦略。
/// 1. 片側沈め: 片方を深く沈める
/// 2. スライド: 横にずらしてバーから外す
/// 3. 落下
class StrategyDiagram extends StatefulWidget {
  /// 攻略タイプ（例: 'bridge', 'kenzan', '3-claw'）
  final String strategyType;

  /// 景品の傾き角度（ラジアン、オプション）
  final double? prizeAngle;

  /// 重心の位置（0.0-1.0の相対座標、オプション）
  final Offset? centerOfGravity;

  /// アニメーションを有効にするかどうか（デフォルト: true）
  final bool animate;

  /// 橋渡し攻略のアニメーションタイプ（デフォルト: vertical）
  final BridgeAnimationType bridgeAnimationType;

  const StrategyDiagram({
    super.key,
    required this.strategyType,
    this.prizeAngle,
    this.centerOfGravity,
    this.animate = true,
    this.bridgeAnimationType = BridgeAnimationType.vertical,
  });

  @override
  State<StrategyDiagram> createState() => _StrategyDiagramState();
}

class _StrategyDiagramState extends State<StrategyDiagram>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  // 共通アニメーション
  Animation<double>? _angleAnimation;
  Animation<double>? _armVerticalAnimation;
  Animation<double>? _verticalOffsetAnimation;

  // 拡張アニメーション
  Animation<double>? _horizontalOffsetAnimation;
  Animation<double>? _armHorizontalAnimation;
  Animation<double>? _pivotAnimation;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _isInitialized = true;
  }

  void _setupAnimations() {
    // アニメーションタイプに応じてセットアップ
    if (widget.bridgeAnimationType == BridgeAnimationType.vertical) {
      _setupVerticalFittingAnimation();
    } else {
      _setupHorizontalFittingAnimation();
    }

    if (widget.animate) {
      _controller?.repeat();
    }
  }

  /// 縦ハメアニメーションのセットアップ
  ///
  /// 景品の角を左右交互に狙い、シーソーのように振りながら
  /// 徐々に縦向きにして落とす。
  void _setupVerticalFittingAnimation() {
    // 12秒サイクル
    _controller = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    );

    // 縦ハメの角度アニメーション
    // 右下がり → 左下がり → さらに右下がり → 縦向き → 落下
    _angleAnimation = TweenSequence<double>([
      // Phase 1: 初期状態（0-1秒）
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 8.33),
      // Phase 2: アーム下降中（1-2秒）
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 8.33),
      // Phase 3: 右を押して左下がりに（2-3秒）- 右バーを支点
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: -25 * pi / 180,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 8.33,
      ),
      // Phase 4: アーム上昇（3-4秒）
      TweenSequenceItem(
        tween: ConstantTween<double>(-25 * pi / 180),
        weight: 8.33,
      ),
      // Phase 5-6: 左アームで右下がりに（4-6秒）- 左バーを支点
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -25 * pi / 180,
          end: 30 * pi / 180,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 16.66,
      ),
      // Phase 7: アーム上昇（6-7秒）
      TweenSequenceItem(
        tween: ConstantTween<double>(30 * pi / 180),
        weight: 8.33,
      ),
      // Phase 8-9: 再度右を押してさらに傾ける（7-9秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 30 * pi / 180,
          end: -45 * pi / 180,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 16.66,
      ),
      // Phase 10: 縦向きで維持（9-10秒）
      TweenSequenceItem(
        tween: ConstantTween<double>(-45 * pi / 180),
        weight: 8.33,
      ),
      // Phase 11: 落下（10-11秒）
      TweenSequenceItem(
        tween: ConstantTween<double>(-45 * pi / 180),
        weight: 8.33,
      ),
      // Phase 12: 初期状態に戻る（11-12秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -45 * pi / 180,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 8.33,
      ),
    ]).animate(_controller!);

    // アーム垂直位置アニメーション
    _armVerticalAnimation = TweenSequence<double>([
      // Phase 1: アームなし（0-1秒）
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 8.33),
      // Phase 2: 右アーム下降（1-2秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 8.33,
      ),
      // Phase 3: 押し中（2-3秒）
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 8.33),
      // Phase 4: 右アーム上昇（3-4秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 8.33,
      ),
      // Phase 5: 左アーム下降（4-5秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 8.33,
      ),
      // Phase 6: 押し中（5-6秒）
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 8.33),
      // Phase 7: 左アーム上昇（6-7秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 8.33,
      ),
      // Phase 8: 右アーム下降（7-8秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 8.33,
      ),
      // Phase 9: 押し中（8-9秒）
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 8.33),
      // Phase 10-12: アームなし（9-12秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 8.33,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 16.66),
    ]).animate(_controller!);

    // アーム水平位置アニメーション（右→左→右）
    _armHorizontalAnimation = TweenSequence<double>([
      // Phase 1-4: 右側を狙う（0-4秒）
      TweenSequenceItem(tween: ConstantTween<double>(0.4), weight: 33.32),
      // Phase 5-7: 左側を狙う（4-7秒）
      TweenSequenceItem(tween: ConstantTween<double>(-0.4), weight: 25.0),
      // Phase 8-12: 右側を狙う（7-12秒）
      TweenSequenceItem(tween: ConstantTween<double>(0.4), weight: 41.68),
    ]).animate(_controller!);

    // 支点アニメーション（右バー→左バー→右バー）
    _pivotAnimation = TweenSequence<double>([
      // Phase 1-4: 右バーを支点（左下がりに）
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 33.32),
      // Phase 5-7: 左バーを支点（右下がりに）
      TweenSequenceItem(tween: ConstantTween<double>(-1.0), weight: 25.0),
      // Phase 8-12: 右バーを支点（左下がりに）
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 41.68),
    ]).animate(_controller!);

    // 垂直位置アニメーション（落下）
    _verticalOffsetAnimation = TweenSequence<double>([
      // Phase 1-10: バー上（0-10秒）
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 83.33),
      // Phase 11: 落下（10-11秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 8.33,
      ),
      // Phase 12: 初期状態に戻る（11-12秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.2,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 8.33,
      ),
    ]).animate(_controller!);

    // 水平位置は固定
    _horizontalOffsetAnimation = ConstantTween<double>(
      0.0,
    ).animate(_controller!);
  }

  /// 横ハメアニメーションのセットアップ
  ///
  /// 片側を深く沈めてから、横にスライドさせてバーから外す。
  void _setupHorizontalFittingAnimation() {
    // 10秒サイクル
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    // 横ハメの角度アニメーション（小さな傾斜のみ）
    _angleAnimation = TweenSequence<double>([
      // Phase 1: 初期状態（0-1秒）
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 10.0),
      // Phase 2: アーム下降中（1-2秒）
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 10.0),
      // Phase 3: 片側を沈める（2-3秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 20 * pi / 180,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 10.0,
      ),
      // Phase 4: 角度維持（3-4秒）
      TweenSequenceItem(
        tween: ConstantTween<double>(20 * pi / 180),
        weight: 10.0,
      ),
      // Phase 5: 角度維持しながらスライド準備（4-5秒）
      TweenSequenceItem(
        tween: ConstantTween<double>(20 * pi / 180),
        weight: 10.0,
      ),
      // Phase 6-7: スライド中（5-7秒）
      TweenSequenceItem(
        tween: ConstantTween<double>(20 * pi / 180),
        weight: 20.0,
      ),
      // Phase 8: 落下開始（7-8秒）
      TweenSequenceItem(
        tween: ConstantTween<double>(20 * pi / 180),
        weight: 10.0,
      ),
      // Phase 9: 落下中（8-9秒）
      TweenSequenceItem(
        tween: ConstantTween<double>(20 * pi / 180),
        weight: 10.0,
      ),
      // Phase 10: 初期状態に戻る（9-10秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 20 * pi / 180,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10.0,
      ),
    ]).animate(_controller!);

    // アーム垂直位置アニメーション
    _armVerticalAnimation = TweenSequence<double>([
      // Phase 1: アームなし（0-1秒）
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 10.0),
      // Phase 2: アーム下降（1-2秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10.0,
      ),
      // Phase 3-4: 押し中（2-4秒）
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 20.0),
      // Phase 5: アーム上昇（4-5秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10.0,
      ),
      // Phase 6: 左アーム下降（5-6秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10.0,
      ),
      // Phase 7: スライド中（6-7秒）
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 10.0),
      // Phase 8-10: アームなし（7-10秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10.0,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 20.0),
    ]).animate(_controller!);

    // アーム水平位置（右→左）
    _armHorizontalAnimation = TweenSequence<double>([
      // Phase 1-5: 右側を狙う（0-5秒）
      TweenSequenceItem(tween: ConstantTween<double>(0.4), weight: 50.0),
      // Phase 6-10: 左側を狙う（5-10秒）
      TweenSequenceItem(tween: ConstantTween<double>(-0.4), weight: 50.0),
    ]).animate(_controller!);

    // 支点（左バーを支点に右下がり）
    _pivotAnimation = ConstantTween<double>(-1.0).animate(_controller!);

    // 水平位置アニメーション（スライド）
    _horizontalOffsetAnimation = TweenSequence<double>([
      // Phase 1-5: 中央（0-5秒）
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 50.0),
      // Phase 6-7: 右にスライド（5-7秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.8,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20.0,
      ),
      // Phase 8-9: スライド位置維持（7-9秒）
      TweenSequenceItem(tween: ConstantTween<double>(0.8), weight: 20.0),
      // Phase 10: 初期状態に戻る（9-10秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.8,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10.0,
      ),
    ]).animate(_controller!);

    // 垂直位置アニメーション（落下）
    _verticalOffsetAnimation = TweenSequence<double>([
      // Phase 1-7: バー上（0-7秒）
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 70.0),
      // Phase 8: 落下（7-8秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10.0,
      ),
      // Phase 9-10: 初期状態に戻る（8-10秒）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.2,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20.0,
      ),
    ]).animate(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StrategyDiagram oldWidget) {
    super.didUpdateWidget(oldWidget);

    // アニメーションタイプが変更された場合は再セットアップ
    if (oldWidget.bridgeAnimationType != widget.bridgeAnimationType) {
      _controller?.stop();
      _controller?.dispose();
      _setupAnimations();
      if (mounted) {
        setState(() {});
      }
    } else if (oldWidget.animate != widget.animate) {
      if (widget.animate) {
        _controller?.repeat();
      } else {
        _controller?.stop();
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

  Widget _buildDiagram() {
    if (!_isInitialized || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.animate) {
      return AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          final painter = _getPainter(
            angle: _angleAnimation?.value ?? 0.0,
            armVerticalPosition: _armVerticalAnimation?.value ?? 0.0,
            verticalOffset: _verticalOffsetAnimation?.value ?? 0.0,
            horizontalOffset: _horizontalOffsetAnimation?.value ?? 0.0,
            armHorizontalPosition: _armHorizontalAnimation?.value ?? 0.4,
            pivotPosition: _pivotAnimation?.value ?? 0.0,
          );

          if (painter != null) {
            return CustomPaint(painter: painter, size: Size.infinite);
          } else {
            return _buildPlaceholder();
          }
        },
      );
    } else {
      final painter = _getPainter(
        angle: widget.prizeAngle ?? 0.0,
        armVerticalPosition: 0.0,
        verticalOffset: 0.0,
        horizontalOffset: 0.0,
        armHorizontalPosition: 0.4,
        pivotPosition: 0.0,
      );

      if (painter != null) {
        return CustomPaint(painter: painter, size: Size.infinite);
      } else {
        return _buildPlaceholder();
      }
    }
  }

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

  CustomPainter? _getPainter({
    required double angle,
    required double armVerticalPosition,
    required double verticalOffset,
    required double horizontalOffset,
    required double armHorizontalPosition,
    required double pivotPosition,
  }) {
    if (widget.strategyType.isEmpty) {
      return null;
    }

    switch (widget.strategyType.toLowerCase()) {
      case 'bridge':
      case '橋渡し':
        return BridgePainter(
          prizeAngle: angle,
          centerOfGravity: widget.centerOfGravity ?? const Offset(0.5, 0.5),
          armVerticalPosition: armVerticalPosition,
          prizeVerticalOffset: verticalOffset,
          prizeHorizontalOffset: horizontalOffset,
          armHorizontalPosition: armHorizontalPosition,
          pivotPosition: pivotPosition,
          showArm: widget.animate,
          showTargetArrow: !widget.animate,
        );
      default:
        return null;
    }
  }
}
