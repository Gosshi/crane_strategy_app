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
/// ## 橋渡し攻略のアニメーション
///
/// ### 縦ハメ（Vertical Fitting）
/// 景品の角を左右交互に狙い、シーソーのように振りながら対角線で落とす。
///
/// 物理ロジック:
/// - アームが右奥角を押す → 左バーを支点に右下がりに傾く
/// - アームが左奥角を押す → 右バーを支点に左下がりに傾く
/// - 交互に繰り返し、角度を増幅させて落下
///
/// ### 横ハメ（Horizontal Fitting）
/// 景品をバーに平行に保ち、片側を脱輪させてスライドで引き抜く。
///
/// 物理ロジック:
/// - 片側を沈めて傾斜をつける
/// - アームで横方向に押し出し（スライド）
/// - バーとの掛かりが外れて落下
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

  Animation<double>? _angleAnimation;
  Animation<double>? _armVerticalAnimation;
  Animation<double>? _verticalOffsetAnimation;
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
    if (widget.bridgeAnimationType == BridgeAnimationType.vertical) {
      _setupVerticalFittingAnimation();
    } else {
      _setupHorizontalFittingAnimation();
    }

    if (widget.animate) {
      _controller?.repeat();
    }
  }

  /// ============================================================
  /// 縦ハメアニメーション（Vertical Fitting）
  /// ============================================================
  ///
  /// 物理モデル:
  /// - アームが景品の角に接触した瞬間から回転が始まる
  /// - 接触していない角の下にあるバーが回転の支点となる
  /// - 右奥角を押す → 左バー支点 → 右下がり（正の角度）
  /// - 左奥角を押す → 右バー支点 → 左下がり（負の角度）
  ///
  /// 質感改善:
  /// - 接触時に「ググッ」と重みを感じる easeOutCubic
  /// - フィニッシュ前に深押し（1.0→1.15）で落下のきっかけを明示
  ///
  /// タイムライン（10秒サイクル）:
  /// [0.0-1.0] Phase 1: 初期状態（水平）
  /// [1.0-1.5] Phase 2: アーム下降（右奥角へ）
  /// [1.5-2.5] Phase 3: 接触→回転（右下がり +25度）
  /// [2.5-3.0] Phase 4: アーム上昇
  /// [3.0-3.5] Phase 5: アーム下降（左奥角へ）
  /// [3.5-4.5] Phase 6: 接触→回転（左下がり -30度）
  /// [4.5-5.0] Phase 7: アーム上昇
  /// [5.0-5.5] Phase 8: アーム下降（右奥角へ）
  /// [5.5-6.3] Phase 9: 接触→回転（右下がり +50度）
  /// [6.3-6.5] Phase 9.5: 深押し（フィニッシュ準備）← NEW
  /// [6.5-7.0] Phase 10: アーム上昇
  /// [7.0-8.0] Phase 11: 対角線で落下
  /// [8.0-10.0] Phase 12: リセット
  void _setupVerticalFittingAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    // ========================================
    // 角度アニメーション
    // アームが接触した瞬間から回転開始
    // 「ググッ」と重みを感じる easeOutCubic を使用
    // ========================================
    _angleAnimation = TweenSequence<double>([
      // [0.0-1.0] Phase 1: 初期状態（水平）
      // 狙い: なし、景品は水平にバーの上
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 10.0),
      // [1.0-1.5] Phase 2: アーム下降中（まだ接触していない）
      // 狙い: 右奥角に向けてアームが下降中
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 5.0),
      // [1.5-2.5] Phase 3: アーム接触→景品が右下がりに傾く
      // 狙い: 右奥角、ベクトル: 下向き押し込み
      // 支点: 左バー、結果: 右下がり（正の角度）
      // 質感: 接触直後は抵抗があり、徐々に動く（easeOutCubic）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 25 * pi / 180,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 10.0,
      ),
      // [2.5-3.0] Phase 4: アーム上昇（角度維持）
      TweenSequenceItem(
        tween: ConstantTween<double>(25 * pi / 180),
        weight: 5.0,
      ),
      // [3.0-3.5] Phase 5: アーム下降中（左奥角へ）
      TweenSequenceItem(
        tween: ConstantTween<double>(25 * pi / 180),
        weight: 5.0,
      ),
      // [3.5-4.5] Phase 6: アーム接触→景品が左下がりに傾く
      // 狙い: 左奥角（対角線上）、ベクトル: 下向き押し込み
      // 支点: 右バー、結果: 左下がり（負の角度）
      // 質感: 重みで「ググッ」と動く
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 25 * pi / 180,
          end: -30 * pi / 180,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 10.0,
      ),
      // [4.5-5.0] Phase 7: アーム上昇（角度維持）
      TweenSequenceItem(
        tween: ConstantTween<double>(-30 * pi / 180),
        weight: 5.0,
      ),
      // [5.0-5.5] Phase 8: アーム下降中（右奥角へ）
      TweenSequenceItem(
        tween: ConstantTween<double>(-30 * pi / 180),
        weight: 5.0,
      ),
      // [5.5-6.3] Phase 9: アーム接触→景品がさらに右下がりに
      // 狙い: 右奥角（対角線上）、ベクトル: 下向き押し込み
      // 支点: 左バー、結果: 大きく右下がり（+50度）→落下準備
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -30 * pi / 180,
          end: 50 * pi / 180,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 8.0,
      ),
      // [6.3-6.5] Phase 9.5: 深押しによる最後の一押し
      // フィニッシュ前の「押し込み」で角度がさらに増加
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 50 * pi / 180,
          end: 55 * pi / 180,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 2.0,
      ),
      // [6.5-7.0] Phase 10: アーム上昇（角度維持）
      TweenSequenceItem(
        tween: ConstantTween<double>(55 * pi / 180),
        weight: 5.0,
      ),
      // [7.0-8.0] Phase 11: 落下（角度維持）
      TweenSequenceItem(
        tween: ConstantTween<double>(55 * pi / 180),
        weight: 10.0,
      ),
      // [8.0-10.0] Phase 12: リセット
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 55 * pi / 180,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20.0,
      ),
    ]).animate(_controller!);

    // ========================================
    // アーム垂直位置アニメーション
    // 0.0=上端、1.0=景品に接触、1.15=深押し
    // ========================================
    _armVerticalAnimation = TweenSequence<double>([
      // [0.0-1.0] Phase 1: アームなし
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 10.0),
      // [1.0-1.5] Phase 2: アーム下降（右奥角へ）
      // 加速しながら下降、接触直前で最速
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 5.0,
      ),
      // [1.5-2.5] Phase 3: 接触維持（押し込み中）
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 10.0),
      // [2.5-3.0] Phase 4: アーム上昇
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 5.0,
      ),
      // [3.0-3.5] Phase 5: アーム下降（左奥角へ）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 5.0,
      ),
      // [3.5-4.5] Phase 6: 接触維持（押し込み中）
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 10.0),
      // [4.5-5.0] Phase 7: アーム上昇
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 5.0,
      ),
      // [5.0-5.5] Phase 8: アーム下降（右奥角へ）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 5.0,
      ),
      // [5.5-6.3] Phase 9: 接触維持（押し込み中）
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 8.0),
      // [6.3-6.5] Phase 9.5: 深押し（フィニッシュ準備）
      // アームがさらに深く沈み込み、落下のきっかけを作る
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 2.0,
      ),
      // [6.5-7.0] Phase 10: アーム上昇
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.15,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 5.0,
      ),
      // [7.0-10.0] Phase 11-12: アームなし
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 30.0),
    ]).animate(_controller!);

    // ========================================
    // アーム水平位置アニメーション
    // 0.4=右奥角、-0.4=左奥角
    // ========================================
    _armHorizontalAnimation = TweenSequence<double>([
      // [0.0-3.0] Phase 1-4: 右奥角を狙う
      TweenSequenceItem(tween: ConstantTween<double>(0.4), weight: 30.0),
      // [3.0-5.0] Phase 5-7: 左奥角を狙う（対角線攻撃）
      TweenSequenceItem(tween: ConstantTween<double>(-0.4), weight: 20.0),
      // [5.0-10.0] Phase 8-12: 右奥角を狙う
      TweenSequenceItem(tween: ConstantTween<double>(0.4), weight: 50.0),
    ]).animate(_controller!);

    // ========================================
    // 回転支点アニメーション
    // -1.0=左バー支点、1.0=右バー支点
    // 押す角の反対側のバーが支点になる
    // ========================================
    _pivotAnimation = TweenSequence<double>([
      // [0.0-3.0] Phase 1-4: 左バー支点（右を押すので）
      TweenSequenceItem(tween: ConstantTween<double>(-1.0), weight: 30.0),
      // [3.0-5.0] Phase 5-7: 右バー支点（左を押すので）
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 20.0),
      // [5.0-10.0] Phase 8-12: 左バー支点（右を押すので）
      TweenSequenceItem(tween: ConstantTween<double>(-1.0), weight: 50.0),
    ]).animate(_controller!);

    // ========================================
    // 垂直位置アニメーション（落下）
    // ========================================
    _verticalOffsetAnimation = TweenSequence<double>([
      // [0.0-7.0] Phase 1-10: バー上
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 70.0),
      // [7.0-8.0] Phase 11: 落下
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.5,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10.0,
      ),
      // [8.0-10.0] Phase 12: リセット
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.5,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20.0,
      ),
    ]).animate(_controller!);

    // 水平位置は固定（縦ハメでは横移動しない）
    _horizontalOffsetAnimation = ConstantTween<double>(
      0.0,
    ).animate(_controller!);
  }

  /// ============================================================
  /// 横ハメアニメーション（Horizontal Fitting）
  /// ============================================================
  ///
  /// 物理モデル:
  /// - 片側を沈めて傾斜をつける
  /// - アームで横方向に押し出す（スライド/横引き）
  /// - バーとの掛かりが外れて落下
  ///
  /// 質感改善:
  /// - 接触時に「ググッ」と重みを感じる easeOutCubic
  /// - スライド中に摩擦を逃がす微小な垂直揺れ（持ち上げ）
  /// - スライド速度を非線形に（最初ゆっくり、後半加速）
  ///
  /// タイムライン（10秒サイクル）:
  /// [0.0-1.0] Phase 1: 初期状態（水平）
  /// [1.0-1.5] Phase 2: アーム下降（右側へ）
  /// [1.5-2.5] Phase 3: 接触→片側沈め（傾斜 +25度）
  /// [2.5-3.0] Phase 4: アーム上昇
  /// [3.0-3.5] Phase 5: アーム下降（左側バー際へ）
  /// [3.5-5.5] Phase 6: アームで右方向にスライド（脱輪）+ 垂直揺れ
  /// [5.5-6.5] Phase 7: 落下
  /// [6.5-10.0] Phase 8: リセット
  void _setupHorizontalFittingAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    // ========================================
    // 角度アニメーション
    // 片側を沈めて傾斜をつける
    // 「ググッ」と重みを感じる easeOutCubic
    // ========================================
    _angleAnimation = TweenSequence<double>([
      // [0.0-1.0] Phase 1: 初期状態（水平）
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 10.0),
      // [1.0-1.5] Phase 2: アーム下降中（まだ接触していない）
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 5.0),
      // [1.5-2.5] Phase 3: アーム接触→片側を沈める
      // 狙い: 右側、ベクトル: 下向き押し込み
      // 支点: 左バー、結果: 右下がり（正の角度）
      // 質感: 接触直後は抵抗があり、徐々に動く
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 25 * pi / 180,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 10.0,
      ),
      // [2.5-3.0] Phase 4: アーム上昇（角度維持）
      TweenSequenceItem(
        tween: ConstantTween<double>(25 * pi / 180),
        weight: 5.0,
      ),
      // [3.0-3.5] Phase 5: アーム下降（左側バー際へ）
      TweenSequenceItem(
        tween: ConstantTween<double>(25 * pi / 180),
        weight: 5.0,
      ),
      // [3.5-5.5] Phase 6: スライド中（角度維持）
      TweenSequenceItem(
        tween: ConstantTween<double>(25 * pi / 180),
        weight: 20.0,
      ),
      // [5.5-6.5] Phase 7: 落下中（角度維持）
      TweenSequenceItem(
        tween: ConstantTween<double>(25 * pi / 180),
        weight: 10.0,
      ),
      // [6.5-10.0] Phase 8: リセット
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 25 * pi / 180,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35.0,
      ),
    ]).animate(_controller!);

    // ========================================
    // アーム垂直位置アニメーション
    // ========================================
    _armVerticalAnimation = TweenSequence<double>([
      // [0.0-1.0] Phase 1: アームなし
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 10.0),
      // [1.0-1.5] Phase 2: アーム下降（右側へ）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 5.0,
      ),
      // [1.5-2.5] Phase 3: 接触維持
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 10.0),
      // [2.5-3.0] Phase 4: アーム上昇
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 5.0,
      ),
      // [3.0-3.5] Phase 5: アーム下降（左側バー際へ）
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 5.0,
      ),
      // [3.5-5.5] Phase 6: スライド中（接触維持）
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 20.0),
      // [5.5-6.0] Phase 7前半: アーム上昇
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 5.0,
      ),
      // [6.0-10.0] Phase 7後半-8: アームなし
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 40.0),
    ]).animate(_controller!);

    // ========================================
    // アーム水平位置アニメーション
    // 最初は右側、スライド時は左側から右へ押す
    // ========================================
    _armHorizontalAnimation = TweenSequence<double>([
      // [0.0-3.0] Phase 1-4: 右側を狙う（沈め用）
      TweenSequenceItem(tween: ConstantTween<double>(0.4), weight: 30.0),
      // [3.0-5.5] Phase 5-6: 左側から右へスライド
      // アームが左バー際から景品を右に押し出す
      TweenSequenceItem(tween: ConstantTween<double>(-0.3), weight: 25.0),
      // [5.5-10.0] Phase 7-8: 終了
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 45.0),
    ]).animate(_controller!);

    // 支点は常に左バー（右下がりを維持）
    _pivotAnimation = ConstantTween<double>(-1.0).animate(_controller!);

    // ========================================
    // 水平位置アニメーション（スライド）
    // アームで押されて右に移動→脱輪
    // 非線形: 最初ゆっくり（摩擦抵抗）、後半加速（脱輪）
    // ========================================
    _horizontalOffsetAnimation = TweenSequence<double>([
      // [0.0-3.5] Phase 1-5: 中央位置
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 35.0),
      // [3.5-4.5] Phase 6前半: アームに押されて動き始める
      // 物理: 静止摩擦を超えるまで抵抗、その後動く
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.3,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10.0,
      ),
      // [4.5-5.5] Phase 6後半: 摩擦が減り加速→脱輪
      // 物理: 動摩擦は静止摩擦より小さい→加速
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 10.0,
      ),
      // [5.5-6.5] Phase 7: 落下中（位置維持）
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 10.0),
      // [6.5-10.0] Phase 8: リセット
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35.0,
      ),
    ]).animate(_controller!);

    // ========================================
    // 垂直位置アニメーション（落下 + スライド中の摩擦揺れ）
    // スライド中に微小な持ち上げ（摩擦を逃がす動き）
    // ========================================
    _verticalOffsetAnimation = TweenSequence<double>([
      // [0.0-3.5] Phase 1-5: バー上（静止）
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 35.0),
      // [3.5-4.0] Phase 6-1: スライド開始時に微小持ち上げ
      // 物理: 摩擦を逃がすため景品がわずかに浮く
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: -0.03,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 5.0,
      ),
      // [4.0-4.5] Phase 6-2: 元の位置に戻りながらスライド
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -0.03,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 5.0,
      ),
      // [4.5-5.0] Phase 6-3: 脱輪直前の微小持ち上げ
      // 物理: バーから外れる瞬間に再度浮く
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: -0.02,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 5.0,
      ),
      // [5.0-5.5] Phase 6-4: 脱輪→落下開始
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -0.02,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 5.0,
      ),
      // [5.5-6.5] Phase 7: 落下
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.5,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10.0,
      ),
      // [6.5-10.0] Phase 8: リセット
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.5,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35.0,
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
