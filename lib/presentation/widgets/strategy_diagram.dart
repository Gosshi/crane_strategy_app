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
  // ドキュメント参照: Setup → Insertion(Walking) → Execution
  // ========================================
  static const List<BoxKeyframe> _verticalBoxKeyframes = [
    // ──────────────────────────────────────
    // Phase 1: Setup（セットアップ/回転）
    // 寄せ技術で箱を20-45度に傾ける
    // ──────────────────────────────────────
    BoxKeyframe(time: 0.00, angle: 0, x: 0, y: 0, pivot: 0), // 初期状態（水平）
    // 1手目: 寄せ（右奥を引く → 左に傾く）
    BoxKeyframe(time: 0.02, angle: 0, x: 0, y: 0, pivot: 1), // アーム右奥に配置
    BoxKeyframe(time: 0.06, angle: 12, x: -4, y: 0, pivot: 1), // 引いて傾斜開始
    BoxKeyframe(time: 0.10, angle: 18, x: -6, y: 1, pivot: 1), // 引き続ける
    BoxKeyframe(time: 0.12, angle: 15, x: -5, y: 2, pivot: 1), // 少し戻る（摩擦）
    // 2手目: 逆寄せ（左奥を引く → 右に傾く）
    BoxKeyframe(time: 0.16, angle: 15, x: -5, y: 2, pivot: -1), // アーム左奥へ移動
    BoxKeyframe(time: 0.20, angle: -8, x: 5, y: 2, pivot: -1), // 逆方向へ傾斜
    BoxKeyframe(time: 0.24, angle: -12, x: 7, y: 3, pivot: -1), // さらに傾斜
    BoxKeyframe(time: 0.26, angle: -10, x: 6, y: 3, pivot: -1), // 少し戻る
    // 3手目: 再度寄せ（右奥を引く → 左に大きく傾く）
    BoxKeyframe(time: 0.30, angle: -10, x: 6, y: 3, pivot: 1), // アーム右奥へ
    BoxKeyframe(time: 0.34, angle: 25, x: -8, y: 4, pivot: 1), // 大きく傾斜
    BoxKeyframe(
      time: 0.38,
      angle: 30,
      x: -10,
      y: 5,
      pivot: 1,
    ), // セットアップ完了（約30度）
    BoxKeyframe(time: 0.40, angle: 28, x: -9, y: 6, pivot: 1), // 少し安定
    // ──────────────────────────────────────
    // Phase 2: Insertion（挿入/Walking歩行）
    // 左奥→右奥を交互に持ち上げて「歩かせる」
    // ──────────────────────────────────────

    // Walking 1歩目: 左奥を持ち上げ
    BoxKeyframe(time: 0.44, angle: 28, x: -9, y: 6, pivot: -1), // アーム左奥へ
    BoxKeyframe(time: 0.48, angle: 40, x: -6, y: 8, pivot: -1), // 持ち上げて角度増加
    BoxKeyframe(time: 0.50, angle: 38, x: -5, y: 9, pivot: -1), // 着地
    // Walking 2歩目: 右奥を持ち上げ
    BoxKeyframe(time: 0.54, angle: 38, x: -5, y: 9, pivot: 1), // アーム右奥へ
    BoxKeyframe(time: 0.58, angle: 52, x: -3, y: 12, pivot: 1), // 持ち上げて角度増加
    BoxKeyframe(time: 0.60, angle: 50, x: -2, y: 13, pivot: 1), // 着地
    // Walking 3歩目: 左奥を持ち上げ（ダイヤモンド形状へ）
    BoxKeyframe(time: 0.64, angle: 50, x: -2, y: 13, pivot: -1), // アーム左奥へ
    BoxKeyframe(time: 0.68, angle: 68, x: 0, y: 18, pivot: -1), // 持ち上げて角度増加
    BoxKeyframe(time: 0.70, angle: 65, x: 1, y: 20, pivot: -1), // 着地（縦ハメ形状完成）
    // ──────────────────────────────────────
    // Phase 3: Execution（決済/落とし）
    // スライド/ズリ落としで獲得
    // ──────────────────────────────────────

    // ズリ落とし（重心移動で自然落下）
    BoxKeyframe(time: 0.74, angle: 65, x: 1, y: 20, pivot: 0), // 準備
    BoxKeyframe(time: 0.78, angle: 72, x: 0, y: 25, pivot: 0), // 軽く押して重心移動
    BoxKeyframe(time: 0.82, angle: 78, x: 0, y: 35, pivot: 0), // 滑り始める
    BoxKeyframe(time: 0.84, angle: 80, x: 0, y: 45, pivot: 0), // 加速
    BoxKeyframe(time: 0.86, angle: 82, x: 0, y: 60, pivot: 0), // 落下開始
    BoxKeyframe(time: 0.92, angle: 85, x: 0, y: 150, pivot: 0), // 落下
    // リセット
    BoxKeyframe(time: 1.00, angle: 0, x: 0, y: 0, pivot: 0),
  ];

  static const List<ArmKeyframe> _verticalArmKeyframes = [
    // ──────────────────────────────────────
    // Phase 1: Setup（セットアップ/回転）
    // ──────────────────────────────────────
    ArmKeyframe(
      time: 0.00,
      vertical: 0.0,
      horizontal: 0.5,
      visible: true,
    ), // 初期
    // 1手目: 右奥を寄せる（引く動作）
    ArmKeyframe(time: 0.02, vertical: 0.0, horizontal: 0.5), // 右奥に配置
    ArmKeyframe(time: 0.04, vertical: 0.8, horizontal: 0.5), // 降下
    ArmKeyframe(time: 0.06, vertical: 1.0, horizontal: 0.5), // 掴む
    ArmKeyframe(time: 0.10, vertical: 1.0, horizontal: 0.3), // 引く（寄せ）
    ArmKeyframe(time: 0.12, vertical: 0.3, horizontal: 0.3), // 離す
    // 2手目: 左奥を逆寄せ
    ArmKeyframe(time: 0.14, vertical: 0.0, horizontal: 0.3),
    ArmKeyframe(time: 0.16, vertical: 0.0, horizontal: -0.5), // 左奥へ移動
    ArmKeyframe(time: 0.18, vertical: 0.8, horizontal: -0.5), // 降下
    ArmKeyframe(time: 0.20, vertical: 1.0, horizontal: -0.5), // 掴む
    ArmKeyframe(time: 0.24, vertical: 1.0, horizontal: -0.3), // 引く（逆寄せ）
    ArmKeyframe(time: 0.26, vertical: 0.3, horizontal: -0.3), // 離す
    // 3手目: 右奥を再度寄せ
    ArmKeyframe(time: 0.28, vertical: 0.0, horizontal: -0.3),
    ArmKeyframe(time: 0.30, vertical: 0.0, horizontal: 0.5), // 右奥へ移動
    ArmKeyframe(time: 0.32, vertical: 0.8, horizontal: 0.5), // 降下
    ArmKeyframe(time: 0.34, vertical: 1.0, horizontal: 0.5), // 掴む
    ArmKeyframe(time: 0.38, vertical: 1.0, horizontal: 0.2), // 引く（寄せ）
    ArmKeyframe(time: 0.40, vertical: 0.3, horizontal: 0.2), // 離す
    // ──────────────────────────────────────
    // Phase 2: Insertion（Walking歩行）
    // ──────────────────────────────────────

    // Walking 1歩目: 左奥を持ち上げ
    ArmKeyframe(time: 0.42, vertical: 0.0, horizontal: 0.2),
    ArmKeyframe(time: 0.44, vertical: 0.0, horizontal: -0.4), // 左奥へ移動
    ArmKeyframe(time: 0.46, vertical: 0.8, horizontal: -0.4), // 降下
    ArmKeyframe(time: 0.48, vertical: 1.2, horizontal: -0.4), // 持ち上げ（リフト）
    ArmKeyframe(time: 0.50, vertical: 0.3, horizontal: -0.4), // 離す
    // Walking 2歩目: 右奥を持ち上げ
    ArmKeyframe(time: 0.52, vertical: 0.0, horizontal: -0.4),
    ArmKeyframe(time: 0.54, vertical: 0.0, horizontal: 0.4), // 右奥へ移動
    ArmKeyframe(time: 0.56, vertical: 0.8, horizontal: 0.4), // 降下
    ArmKeyframe(time: 0.58, vertical: 1.2, horizontal: 0.4), // 持ち上げ（リフト）
    ArmKeyframe(time: 0.60, vertical: 0.3, horizontal: 0.4), // 離す
    // Walking 3歩目: 左奥を持ち上げ
    ArmKeyframe(time: 0.62, vertical: 0.0, horizontal: 0.4),
    ArmKeyframe(time: 0.64, vertical: 0.0, horizontal: -0.4), // 左奥へ移動
    ArmKeyframe(time: 0.66, vertical: 0.8, horizontal: -0.4), // 降下
    ArmKeyframe(time: 0.68, vertical: 1.2, horizontal: -0.4), // 持ち上げ（リフト）
    ArmKeyframe(time: 0.70, vertical: 0.3, horizontal: -0.4), // 離す
    // ──────────────────────────────────────
    // Phase 3: Execution（決済）
    // ──────────────────────────────────────

    // ズリ落とし（軽く押して重心移動）
    ArmKeyframe(time: 0.72, vertical: 0.0, horizontal: -0.4),
    ArmKeyframe(time: 0.74, vertical: 0.0, horizontal: 0.0), // 中央へ
    ArmKeyframe(time: 0.76, vertical: 0.6, horizontal: 0.0), // 降下
    ArmKeyframe(time: 0.78, vertical: 0.8, horizontal: 0.0), // 軽く押す
    ArmKeyframe(time: 0.82, vertical: 0.4, horizontal: 0.0), // 離れる
    // 離脱
    ArmKeyframe(time: 0.84, vertical: 0.0, horizontal: 0.0, visible: false),

    // リセット
    ArmKeyframe(time: 1.00, vertical: 0.0, horizontal: 0.5, visible: true),
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
      duration: const Duration(seconds: 16),
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
