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

/// キーフレームデータ（箱の状態）
class BoxKeyframe {
  final double time; // 0.0〜1.0
  final double angle; // 度数法（degree）
  final double x; // 水平オフセット
  final double y; // 垂直オフセット（落下方向が正）
  final double pivot; // 支点位置（-1=手前, 1=奥）

  const BoxKeyframe({
    required this.time,
    required this.angle,
    this.x = 0,
    this.y = 0,
    this.pivot = 0,
  });
}

/// キーフレームデータ（アームの状態）
class ArmKeyframe {
  final double time; // 0.0〜1.0
  final double vertical; // 垂直位置（0=上, 1=接触, 1.5=深押し）
  final double horizontal; // 水平位置（-1=左, 0=中央, 1=右）
  final bool visible; // 表示するか

  const ArmKeyframe({
    required this.time,
    required this.vertical,
    this.horizontal = 0,
    this.visible = true,
  });
}

/// 攻略法の図解を表示するウィジェット
///
/// ## キーフレームアニメーション方式
/// 物理シミュレーションではなく、事前定義された「正解フォーム」の
/// キーフレームを滑らかに補間して表示する。
class StrategyDiagram extends StatefulWidget {
  final String strategyType;
  final double? prizeAngle;
  final Offset? centerOfGravity;
  final bool animate;
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
  bool _isInitialized = false;

  // ========================================
  // 縦ハメ用キーフレーム（正解フォーム）
  // ========================================
  static const List<BoxKeyframe> _verticalBoxKeyframes = [
    // Phase 0: 初期状態（水平）
    BoxKeyframe(time: 0.00, angle: 0, x: 0, y: 0, pivot: 0),

    // Phase 1: きっかけ（右を払う → 左に傾く）
    BoxKeyframe(time: 0.05, angle: 0, x: 0, y: 0, pivot: -1), // アーム接触直前
    BoxKeyframe(time: 0.12, angle: 8, x: -3, y: 0, pivot: -1), // 衝撃
    BoxKeyframe(time: 0.15, angle: 5, x: -2, y: 1, pivot: -1), // 少し戻る
    // Phase 2: 対角線攻め（左を払う → 右に大きく傾く）
    BoxKeyframe(time: 0.20, angle: 5, x: -2, y: 1, pivot: 1), // アーム移動中
    BoxKeyframe(time: 0.30, angle: -15, x: 8, y: 2, pivot: 1), // 逆方向へ
    BoxKeyframe(time: 0.35, angle: -12, x: 6, y: 3, pivot: 1), // 少し戻る
    // Phase 3: 深いハマり（右を強く押す）
    BoxKeyframe(time: 0.40, angle: -12, x: 6, y: 3, pivot: -1), // アーム移動中
    BoxKeyframe(time: 0.50, angle: 35, x: -5, y: 8, pivot: -1), // 大きく傾く
    BoxKeyframe(time: 0.55, angle: 30, x: -3, y: 10, pivot: -1), // 少し戻る
    // Phase 4: 背面ずり上げ（裏側から引く）
    BoxKeyframe(time: 0.60, angle: 30, x: -3, y: 10, pivot: -1), // 準備
    BoxKeyframe(time: 0.68, angle: 55, x: 0, y: 18, pivot: -1), // 1回目ガガッ
    BoxKeyframe(time: 0.72, angle: 50, x: 2, y: 16, pivot: -1), // 少し滑る
    BoxKeyframe(time: 0.80, angle: 75, x: 0, y: 28, pivot: -1), // 2回目ガガッ
    // Phase 5: 縦ハメ完成 → 落下
    BoxKeyframe(time: 0.82, angle: 80, x: 0, y: 32, pivot: -1), // ほぼ垂直
    BoxKeyframe(time: 0.84, angle: 80, x: 0, y: 32, pivot: -1), // 一瞬止まる
    BoxKeyframe(time: 0.86, angle: 78, x: 0, y: 35, pivot: -1), // 重力で少し戻る
    BoxKeyframe(time: 0.95, angle: 75, x: 0, y: 150, pivot: -1), // 加速落下
    // Phase 6: リセット
    BoxKeyframe(time: 1.00, angle: 0, x: 0, y: 0, pivot: 0),
  ];

  static const List<ArmKeyframe> _verticalArmKeyframes = [
    // Phase 0: 初期
    ArmKeyframe(time: 0.00, vertical: 0.0, horizontal: 0.4, visible: true),

    // Phase 1: 右側を払う
    ArmKeyframe(time: 0.05, vertical: 0.3, horizontal: 0.4),
    ArmKeyframe(time: 0.10, vertical: 1.0, horizontal: 0.4), // 接触
    ArmKeyframe(time: 0.15, vertical: 0.8, horizontal: 0.4), // 離れる
    // Phase 2: 左側へ移動して払う
    ArmKeyframe(time: 0.18, vertical: 0.0, horizontal: 0.4),
    ArmKeyframe(time: 0.22, vertical: 0.0, horizontal: -0.4), // 左へ移動
    ArmKeyframe(time: 0.28, vertical: 1.0, horizontal: -0.4), // 接触
    ArmKeyframe(time: 0.35, vertical: 0.5, horizontal: -0.4), // 離れる
    // Phase 3: 右側を強く押す
    ArmKeyframe(time: 0.38, vertical: 0.0, horizontal: -0.4),
    ArmKeyframe(time: 0.42, vertical: 0.0, horizontal: 0.4), // 右へ移動
    ArmKeyframe(time: 0.48, vertical: 1.2, horizontal: 0.4), // 強く押す
    ArmKeyframe(time: 0.55, vertical: 0.3, horizontal: 0.4), // 離れる
    // Phase 4: 背面へ移動して深押し
    ArmKeyframe(time: 0.58, vertical: 0.0, horizontal: 0.4),
    ArmKeyframe(time: 0.62, vertical: 0.0, horizontal: 0.0), // 中央へ
    ArmKeyframe(time: 0.66, vertical: 1.5, horizontal: 0.0), // 深押し1
    ArmKeyframe(time: 0.70, vertical: 1.3, horizontal: 0.0), // 少し戻る
    ArmKeyframe(time: 0.78, vertical: 1.8, horizontal: 0.0), // 深押し2
    ArmKeyframe(time: 0.82, vertical: 1.8, horizontal: 0.0), // 維持
    // Phase 5: 離脱
    ArmKeyframe(time: 0.84, vertical: 0.5, horizontal: 0.0),
    ArmKeyframe(time: 0.90, vertical: 0.0, horizontal: 0.0, visible: false),

    // Phase 6: リセット
    ArmKeyframe(time: 1.00, vertical: 0.0, horizontal: 0.4, visible: true),
  ];

  // ========================================
  // 横ハメ用キーフレーム（正解フォーム）
  // ========================================
  static const List<BoxKeyframe> _horizontalBoxKeyframes = [
    // Phase 0: 初期状態
    BoxKeyframe(time: 0.00, angle: 0, x: 0, y: 0, pivot: 0),

    // Phase 1: 片側を沈める
    BoxKeyframe(time: 0.10, angle: 0, x: 0, y: 0, pivot: -1),
    BoxKeyframe(time: 0.25, angle: 25, x: -5, y: 5, pivot: -1),
    BoxKeyframe(time: 0.30, angle: 22, x: -3, y: 6, pivot: -1),

    // Phase 2: 維持してスライド準備
    BoxKeyframe(time: 0.40, angle: 22, x: -3, y: 6, pivot: -1),

    // Phase 3: 横にスライド
    BoxKeyframe(time: 0.55, angle: 20, x: 25, y: 8, pivot: -1),
    BoxKeyframe(time: 0.60, angle: 18, x: 35, y: 10, pivot: -1),

    // Phase 4: バーから外れて落下
    BoxKeyframe(time: 0.65, angle: 15, x: 40, y: 15, pivot: -1),
    BoxKeyframe(time: 0.75, angle: 10, x: 45, y: 80, pivot: -1),
    BoxKeyframe(time: 0.85, angle: 5, x: 50, y: 150, pivot: -1),

    // Phase 5: リセット
    BoxKeyframe(time: 1.00, angle: 0, x: 0, y: 0, pivot: 0),
  ];

  static const List<ArmKeyframe> _horizontalArmKeyframes = [
    // Phase 0: 初期
    ArmKeyframe(time: 0.00, vertical: 0.0, horizontal: 0.4),

    // Phase 1: 片側を押す
    ArmKeyframe(time: 0.08, vertical: 0.5, horizontal: 0.4),
    ArmKeyframe(time: 0.15, vertical: 1.0, horizontal: 0.4),
    ArmKeyframe(time: 0.28, vertical: 1.0, horizontal: 0.4),
    ArmKeyframe(time: 0.35, vertical: 0.3, horizontal: 0.4),

    // Phase 2: スライド用に押す
    ArmKeyframe(time: 0.40, vertical: 0.0, horizontal: 0.4),
    ArmKeyframe(time: 0.45, vertical: 0.0, horizontal: -0.3),
    ArmKeyframe(time: 0.50, vertical: 0.8, horizontal: -0.3),
    ArmKeyframe(time: 0.60, vertical: 0.8, horizontal: 0.5), // 横に押す
    // Phase 3: 離脱
    ArmKeyframe(time: 0.65, vertical: 0.3, horizontal: 0.5),
    ArmKeyframe(time: 0.70, vertical: 0.0, horizontal: 0.5, visible: false),

    // Phase 4: リセット
    ArmKeyframe(time: 1.00, vertical: 0.0, horizontal: 0.4, visible: true),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _isInitialized = true;
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    if (widget.animate) {
      _controller?.repeat();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StrategyDiagram oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bridgeAnimationType != widget.bridgeAnimationType ||
        oldWidget.animate != widget.animate) {
      _controller?.dispose();
      _setupAnimation();
    }
  }

  /// キーフレーム間を補間して現在の箱の状態を取得
  BoxKeyframe _interpolateBox(double t, List<BoxKeyframe> keyframes) {
    // 該当するキーフレーム区間を探す
    int i = 0;
    while (i < keyframes.length - 1 && keyframes[i + 1].time <= t) {
      i++;
    }

    if (i >= keyframes.length - 1) {
      return keyframes.last;
    }

    final from = keyframes[i];
    final to = keyframes[i + 1];

    // 区間内での進行率を計算
    final segmentDuration = to.time - from.time;
    if (segmentDuration <= 0) return from;

    final segmentProgress = (t - from.time) / segmentDuration;

    // easeInOutで滑らかに補間
    final easedProgress = Curves.easeInOut.transform(
      segmentProgress.clamp(0.0, 1.0),
    );

    return BoxKeyframe(
      time: t,
      angle: _lerp(from.angle, to.angle, easedProgress),
      x: _lerp(from.x, to.x, easedProgress),
      y: _lerp(from.y, to.y, easedProgress),
      pivot: from.pivot, // 支点は補間しない（離散値）
    );
  }

  /// キーフレーム間を補間して現在のアームの状態を取得
  ArmKeyframe _interpolateArm(double t, List<ArmKeyframe> keyframes) {
    int i = 0;
    while (i < keyframes.length - 1 && keyframes[i + 1].time <= t) {
      i++;
    }

    if (i >= keyframes.length - 1) {
      return keyframes.last;
    }

    final from = keyframes[i];
    final to = keyframes[i + 1];

    final segmentDuration = to.time - from.time;
    if (segmentDuration <= 0) return from;

    final segmentProgress = (t - from.time) / segmentDuration;
    final easedProgress = Curves.easeInOut.transform(
      segmentProgress.clamp(0.0, 1.0),
    );

    return ArmKeyframe(
      time: t,
      vertical: _lerp(from.vertical, to.vertical, easedProgress),
      horizontal: _lerp(from.horizontal, to.horizontal, easedProgress),
      visible: from.visible, // 表示は補間しない
    );
  }

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox.shrink();
    }

    if (widget.animate && _controller != null) {
      return AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          return _buildDiagram(_controller!.value);
        },
      );
    } else {
      return _buildDiagram(0.0);
    }
  }

  Widget _buildDiagram(double t) {
    // キーフレームから現在の状態を補間
    final boxKeyframes =
        widget.bridgeAnimationType == BridgeAnimationType.vertical
        ? _verticalBoxKeyframes
        : _horizontalBoxKeyframes;
    final armKeyframes =
        widget.bridgeAnimationType == BridgeAnimationType.vertical
        ? _verticalArmKeyframes
        : _horizontalArmKeyframes;

    final box = _interpolateBox(t, boxKeyframes);
    final arm = _interpolateArm(t, armKeyframes);

    // 静的表示の場合
    final prizeAngle = widget.animate
        ? box.angle *
              pi /
              180 // 度数法 → ラジアン
        : (widget.prizeAngle ?? 0.0);

    final centerOfGravity = widget.centerOfGravity ?? const Offset(0.5, 0.5);

    switch (widget.strategyType) {
      case 'bridge':
      case '橋渡し':
        return AspectRatio(
          aspectRatio: 1.5,
          child: CustomPaint(
            painter: BridgePainter(
              prizeAngle: prizeAngle,
              centerOfGravity: centerOfGravity,
              prizeColor: const Color(0xFFB3E5FC),
              armVerticalPosition: widget.animate ? arm.vertical : 0.0,
              prizeVerticalOffset: widget.animate ? box.y / 100 : 0.0, // 正規化
              prizeHorizontalOffset: widget.animate ? box.x / 100 : 0.0, // 正規化
              armHorizontalPosition: widget.animate ? arm.horizontal : 0.0,
              pivotPosition: widget.animate ? box.pivot : 0.0,
              showArm: widget.animate && arm.visible,
              showTargetArrow: !widget.animate,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
