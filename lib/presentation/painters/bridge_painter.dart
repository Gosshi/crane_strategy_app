import 'dart:math';
import 'package:flutter/material.dart';

/// 橋渡し設定のクレーンゲーム攻略図解を描画するPainter
///
/// ## 物理的リアリティの追求
/// - 一点透視図法による立体的な箱描画
/// - 奥側の辺が短くなるパース効果
/// - Top/Front/Sideの3面に明度差をつけた立体感
/// - 太いガッチリした金属アーム
/// - 箱の側面まで回り込む爪の動き
class BridgePainter extends CustomPainter {
  final double prizeAngle;
  final Offset centerOfGravity;
  final Color prizeColor;
  final double armVerticalPosition;
  final double prizeVerticalOffset;
  final double prizeHorizontalOffset;
  final double armHorizontalPosition;
  final double pivotPosition;
  final bool showArm;
  final bool showTargetArrow;

  const BridgePainter({
    this.prizeAngle = 0.0,
    this.centerOfGravity = const Offset(0.5, 0.5),
    this.prizeColor = const Color(0xFFB3E5FC),
    this.armVerticalPosition = 0.0,
    this.prizeVerticalOffset = 0.0,
    this.prizeHorizontalOffset = 0.0,
    this.armHorizontalPosition = 0.0,
    this.pivotPosition = 0.0,
    this.showArm = true,
    this.showTargetArrow = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ========================================
    // 1. 空間スケール定義（実機準拠）
    // ========================================

    // バー配置（固定座標）
    final backBarY = size.height * 0.35;
    final frontBarY = size.height * 0.72;
    final barWidth = size.width;
    final barHeight = size.height * 0.025;

    // 景品サイズ（実機比率）
    final prizeWidth = size.width * 0.42;
    final prizeHeight = prizeWidth * 0.55;
    final prizeDepth = prizeWidth * 0.5;

    // 一点透視のパース係数（奥が縮む度合い）
    final perspectiveFactor = 0.75;

    // アームサイズ
    final armUnitWidth = size.width * 0.18;
    final armUnitHeight = size.width * 0.10;
    final clawLength = prizeHeight * 1.1; // 箱の高さより長く

    // 景品の中心位置
    final basePrizeCenterX = size.width * 0.5;
    final basePrizeCenterY = (backBarY + frontBarY) / 2;

    final prizeCenterX =
        basePrizeCenterX + (prizeHorizontalOffset * size.width * 0.15);
    final prizeCenterY =
        basePrizeCenterY + (prizeVerticalOffset * size.height * 0.5);

    // 回転の支点（BackBarとの接触点）
    final pivotX = prizeCenterX + (prizeWidth * 0.3 * pivotPosition);
    final pivotY = pivotPosition < 0
        ? frontBarY - barHeight
        : (pivotPosition > 0 ? backBarY + barHeight : basePrizeCenterY);

    // ========================================
    // 2. 動的Z-order描画
    // ========================================

    final isSinking = prizeVerticalOffset > 0.25;

    // 奥のバー
    _drawBar(canvas, 0, backBarY, barWidth, barHeight, true, size);

    // 箱（バー間）- 沈み込み前
    if (!isSinking) {
      _drawPrize3D(
        canvas,
        size,
        prizeCenterX: prizeCenterX,
        prizeCenterY: prizeCenterY,
        prizeWidth: prizeWidth,
        prizeHeight: prizeHeight,
        prizeDepth: prizeDepth,
        perspectiveFactor: perspectiveFactor,
        pivotX: pivotX,
        pivotY: pivotY,
        backBarY: backBarY,
        frontBarY: frontBarY,
        barHeight: barHeight,
      );
    }

    // 手前のバー
    _drawBar(canvas, 0, frontBarY, barWidth, barHeight, false, size);

    // 箱（落下層）- 沈み込み後
    if (isSinking) {
      _drawPrize3D(
        canvas,
        size,
        prizeCenterX: prizeCenterX,
        prizeCenterY: prizeCenterY,
        prizeWidth: prizeWidth,
        prizeHeight: prizeHeight,
        prizeDepth: prizeDepth,
        perspectiveFactor: perspectiveFactor,
        pivotX: pivotX,
        pivotY: pivotY,
        backBarY: backBarY,
        frontBarY: frontBarY,
        barHeight: barHeight,
      );
    }

    // アーム
    if (showArm && armVerticalPosition > 0.0) {
      _drawMechanicalArm(
        canvas,
        size,
        prizeCenterX: prizeCenterX,
        prizeCenterY: basePrizeCenterY,
        prizeWidth: prizeWidth,
        prizeHeight: prizeHeight,
        prizeDepth: prizeDepth,
        armUnitWidth: armUnitWidth,
        armUnitHeight: armUnitHeight,
        clawLength: clawLength,
        backBarY: backBarY,
      );
    }

    // 狙い目矢印
    if (showTargetArrow) {
      _drawTargetIndicators(
        canvas,
        size,
        prizeCenterX: prizeCenterX,
        prizeCenterY: prizeCenterY,
        prizeWidth: prizeWidth,
        prizeHeight: prizeHeight,
        prizeDepth: prizeDepth,
        perspectiveFactor: perspectiveFactor,
        pivotX: pivotX,
        pivotY: pivotY,
      );
    }
  }

  /// バーを描画（3D効果付き）
  void _drawBar(
    Canvas canvas,
    double x,
    double y,
    double width,
    double height,
    bool isBack,
    Size size,
  ) {
    // バーの厚み（奥行き表現）
    final barDepth = height * 2.5;

    // 奥のバーは少し細く（パース）
    final actualHeight = isBack ? height * 0.9 : height;

    // 上面（円筒の上部）
    final topPath = Path();
    topPath.addOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, y - actualHeight / 2),
        width: width * 0.95,
        height: barDepth,
      ),
    );

    canvas.drawPath(
      topPath,
      Paint()
        ..color = isBack ? Colors.grey[600]! : Colors.grey[500]!
        ..style = PaintingStyle.fill,
    );

    // 本体（円筒）
    final bodyRect = Rect.fromLTWH(
      x + size.width * 0.025,
      y - actualHeight / 2,
      width * 0.95,
      actualHeight,
    );

    canvas.drawRect(
      bodyRect,
      Paint()
        ..shader = LinearGradient(
          colors: isBack
              ? [Colors.grey[700]!, Colors.grey[800]!, Colors.grey[700]!]
              : [Colors.grey[600]!, Colors.grey[700]!, Colors.grey[600]!],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bodyRect),
    );

    // ハイライト
    canvas.drawRect(
      Rect.fromLTWH(
        x + size.width * 0.1,
        y - actualHeight / 2,
        width * 0.3,
        actualHeight * 0.4,
      ),
      Paint()..color = Colors.white.withValues(alpha: isBack ? 0.15 : 0.25),
    );

    // 輪郭
    canvas.drawRect(
      bodyRect,
      Paint()
        ..color = Colors.grey[900]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  /// 景品を3D描画（一点透視図法）
  void _drawPrize3D(
    Canvas canvas,
    Size size, {
    required double prizeCenterX,
    required double prizeCenterY,
    required double prizeWidth,
    required double prizeHeight,
    required double prizeDepth,
    required double perspectiveFactor,
    required double pivotX,
    required double pivotY,
    required double backBarY,
    required double frontBarY,
    required double barHeight,
  }) {
    canvas.save();

    // 支点周りに回転
    canvas.translate(pivotX, pivotY);
    canvas.rotate(prizeAngle);
    canvas.translate(-pivotX, -pivotY);

    // 角度に応じたパース計算
    final angleRatio = (prizeAngle.abs() / (pi / 2)).clamp(0.0, 1.0);

    // 一点透視: 奥側の幅が縮む
    final frontWidth = prizeWidth;
    final backWidth =
        prizeWidth *
        (perspectiveFactor + (1 - perspectiveFactor) * (1 - angleRatio * 0.5));

    // 箱の8頂点を計算（一点透視図法）
    // 手前面の4頂点
    final frontTopLeft = Offset(
      prizeCenterX - frontWidth / 2,
      prizeCenterY + prizeDepth / 2 - prizeHeight / 2,
    );
    final frontTopRight = Offset(
      prizeCenterX + frontWidth / 2,
      prizeCenterY + prizeDepth / 2 - prizeHeight / 2,
    );
    final frontBottomLeft = Offset(
      prizeCenterX - frontWidth / 2,
      prizeCenterY + prizeDepth / 2 + prizeHeight / 2,
    );
    final frontBottomRight = Offset(
      prizeCenterX + frontWidth / 2,
      prizeCenterY + prizeDepth / 2 + prizeHeight / 2,
    );

    // 奥面の4頂点（パースで縮む + 上にずれる）
    final backOffsetX = (frontWidth - backWidth) / 2;
    final backTopLeft = Offset(
      prizeCenterX - backWidth / 2 + backOffsetX * 0.5,
      prizeCenterY - prizeDepth / 2 - prizeHeight / 2,
    );
    final backTopRight = Offset(
      prizeCenterX + backWidth / 2 - backOffsetX * 0.5,
      prizeCenterY - prizeDepth / 2 - prizeHeight / 2,
    );
    final backBottomLeft = Offset(
      prizeCenterX - backWidth / 2 + backOffsetX * 0.5,
      prizeCenterY - prizeDepth / 2 + prizeHeight / 2,
    );
    final backBottomRight = Offset(
      prizeCenterX + backWidth / 2 - backOffsetX * 0.5,
      prizeCenterY - prizeDepth / 2 + prizeHeight / 2,
    );

    // ========================================
    // 3面描画（明度差で立体感）
    // ========================================

    // 1. 右側面（最も暗い - 角度によって見える）
    if (prizeAngle > 0.02) {
      _drawBoxSide(
        canvas,
        topFront: frontTopRight,
        bottomFront: frontBottomRight,
        topBack: backTopRight,
        bottomBack: backBottomRight,
        baseColor: prizeColor,
        darkness: 0.5 + angleRatio * 0.2, // 角度が大きいほど暗く
        frontBarY: frontBarY,
        barHeight: barHeight,
      );
    }

    // 2. 左側面（最も暗い - 逆角度で見える）
    if (prizeAngle < -0.02) {
      _drawBoxSide(
        canvas,
        topFront: frontTopLeft,
        bottomFront: frontBottomLeft,
        topBack: backTopLeft,
        bottomBack: backBottomLeft,
        baseColor: prizeColor,
        darkness: 0.5 + angleRatio * 0.2,
        frontBarY: frontBarY,
        barHeight: barHeight,
      );
    }

    // 3. 上面（最も明るい）
    _drawBoxTop(
      canvas,
      frontLeft: frontTopLeft,
      frontRight: frontTopRight,
      backLeft: backTopLeft,
      backRight: backTopRight,
      baseColor: prizeColor,
    );

    // 4. 前面（中間の明るさ - クリッピングでバー間に沈む表現）
    _drawBoxFront(
      canvas,
      topLeft: frontTopLeft,
      topRight: frontTopRight,
      bottomLeft: frontBottomLeft,
      bottomRight: frontBottomRight,
      baseColor: prizeColor,
      frontBarY: frontBarY,
      barHeight: barHeight,
    );

    canvas.restore();
  }

  /// 箱の側面を描画
  void _drawBoxSide(
    Canvas canvas, {
    required Offset topFront,
    required Offset bottomFront,
    required Offset topBack,
    required Offset bottomBack,
    required Color baseColor,
    required double darkness,
    required double frontBarY,
    required double barHeight,
  }) {
    final path = Path();
    path.moveTo(topFront.dx, topFront.dy);
    path.lineTo(topBack.dx, topBack.dy);
    path.lineTo(bottomBack.dx, bottomBack.dy);
    path.lineTo(bottomFront.dx, bottomFront.dy);
    path.close();

    // 暗い側面色
    final sideColor = Color.lerp(baseColor, Colors.black, darkness)!;

    canvas.drawPath(
      path,
      Paint()
        ..color = sideColor
        ..style = PaintingStyle.fill,
    );

    // 輪郭
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  /// 箱の上面を描画（最も明るい）
  void _drawBoxTop(
    Canvas canvas, {
    required Offset frontLeft,
    required Offset frontRight,
    required Offset backLeft,
    required Offset backRight,
    required Color baseColor,
  }) {
    final path = Path();
    path.moveTo(frontLeft.dx, frontLeft.dy);
    path.lineTo(frontRight.dx, frontRight.dy);
    path.lineTo(backRight.dx, backRight.dy);
    path.lineTo(backLeft.dx, backLeft.dy);
    path.close();

    // グラデーションで立体感
    final bounds = path.getBounds();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          colors: [
            baseColor,
            Color.lerp(baseColor, Colors.white, 0.3)!,
            baseColor,
          ],
          stops: const [0.0, 0.3, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds),
    );

    // ハイライト
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill,
    );

    // 輪郭
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  /// 箱の前面を描画（バーの間にクリップ）
  void _drawBoxFront(
    Canvas canvas, {
    required Offset topLeft,
    required Offset topRight,
    required Offset bottomLeft,
    required Offset bottomRight,
    required Color baseColor,
    required double frontBarY,
    required double barHeight,
  }) {
    final path = Path();
    path.moveTo(topLeft.dx, topLeft.dy);
    path.lineTo(topRight.dx, topRight.dy);
    path.lineTo(bottomRight.dx, bottomRight.dy);
    path.lineTo(bottomLeft.dx, bottomLeft.dy);
    path.close();

    // 中間の明るさ
    final frontColor = Color.lerp(baseColor, Colors.black, 0.15)!;

    // バーより上の部分（クリップ）
    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(
        topLeft.dx - 100,
        0,
        topRight.dx + 100,
        frontBarY - barHeight / 2,
      ),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = frontColor
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    canvas.restore();

    // バーより下の部分（暗く描画 - 沈み込み表現）
    if (bottomLeft.dy > frontBarY) {
      final sinkPath = Path();
      final clipY = frontBarY - barHeight / 2;

      sinkPath.moveTo(topLeft.dx, max(topLeft.dy, clipY));
      sinkPath.lineTo(topRight.dx, max(topRight.dy, clipY));
      sinkPath.lineTo(bottomRight.dx, bottomRight.dy);
      sinkPath.lineTo(bottomLeft.dx, bottomLeft.dy);
      sinkPath.close();

      canvas.save();
      canvas.clipRect(
        Rect.fromLTRB(
          topLeft.dx - 100,
          frontBarY + barHeight / 2,
          topRight.dx + 100,
          bottomLeft.dy + 100,
        ),
      );

      // 暗い沈み込み部分
      canvas.drawPath(
        sinkPath,
        Paint()
          ..color = Color.lerp(frontColor, Colors.black, 0.5)!
          ..style = PaintingStyle.fill,
      );

      canvas.restore();
    }
  }

  /// メカニカルなアーム（太いガッチリした爪）
  void _drawMechanicalArm(
    Canvas canvas,
    Size size, {
    required double prizeCenterX,
    required double prizeCenterY,
    required double prizeWidth,
    required double prizeHeight,
    required double prizeDepth,
    required double armUnitWidth,
    required double armUnitHeight,
    required double clawLength,
    required double backBarY,
  }) {
    // 狙う位置のX座標
    final targetX = prizeCenterX + (prizeWidth * 0.4 * armHorizontalPosition);

    // アーム本体
    final unitTopY = size.height * 0.02;

    // 箱の上面より少し下（側面に触れる位置）
    final boxTopY = prizeCenterY - prizeHeight / 2 + prizeDepth / 2;
    final sideContactY = boxTopY + prizeHeight * 0.15; // 側面の上部15%

    // 下降距離の計算
    final normalDescend =
        (sideContactY - unitTopY - armUnitHeight) *
        armVerticalPosition.clamp(0.0, 1.0);

    // 深押し（背面ずり上げ用）- 箱の高さの60%まで
    final deepPush =
        (armVerticalPosition - 1.0).clamp(0.0, 0.8) * prizeHeight * 0.6;

    final armBottomY = unitTopY + armUnitHeight + normalDescend + deepPush;

    // アーム本体ユニット描画
    _drawArmUnit(canvas, targetX, unitTopY, armUnitWidth, armUnitHeight);

    // 支柱（太い金属棒）
    final shaftWidth = armUnitWidth * 0.15;
    final shaftRect = Rect.fromCenter(
      center: Offset(targetX, (unitTopY + armUnitHeight + armBottomY) / 2),
      width: shaftWidth,
      height: armBottomY - unitTopY - armUnitHeight,
    );

    canvas.drawRect(
      shaftRect,
      Paint()
        ..shader = LinearGradient(
          colors: [Colors.grey[500]!, Colors.grey[700]!, Colors.grey[500]!],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(shaftRect),
    );

    canvas.drawRect(
      shaftRect,
      Paint()
        ..color = Colors.grey[800]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // ガッチリした爪
    _drawHeavyClaws(
      canvas,
      centerX: targetX,
      centerY: armBottomY,
      clawLength: clawLength,
      clawWidth: armUnitWidth * 0.35,
      isGripping: armVerticalPosition >= 0.9,
      isDeepPush: armVerticalPosition > 1.0,
    );
  }

  /// アーム本体ユニット
  void _drawArmUnit(
    Canvas canvas,
    double centerX,
    double topY,
    double width,
    double height,
  ) {
    final unitRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, topY + height / 2),
        width: width,
        height: height,
      ),
      const Radius.circular(8),
    );

    // 本体（メタリックグラデーション）
    canvas.drawRRect(
      unitRect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.grey[500]!,
            Colors.grey[600]!,
            Colors.grey[700]!,
            Colors.grey[600]!,
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(unitRect.outerRect),
    );

    // ハイライト
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX - width / 2 + width * 0.1,
          topY + height * 0.1,
          width * 0.8,
          height * 0.25,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.35),
    );

    // 枠線
    canvas.drawRRect(
      unitRect,
      Paint()
        ..color = Colors.grey[800]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );

    // リベット（装飾）
    for (var i = 0; i < 3; i++) {
      final rivetX = centerX - width * 0.25 + (width * 0.25 * i);
      canvas.drawCircle(
        Offset(rivetX, topY + height * 0.7),
        3,
        Paint()..color = Colors.grey[800]!,
      );
    }
  }

  /// 太いガッチリした爪
  void _drawHeavyClaws(
    Canvas canvas, {
    required double centerX,
    required double centerY,
    required double clawLength,
    required double clawWidth,
    required bool isGripping,
    required bool isDeepPush,
  }) {
    final clawGap = isGripping ? clawWidth * 0.6 : clawWidth * 1.8;
    final bendPoint = clawLength * 0.65;
    final tipCurve = clawLength * 0.25;

    // 左爪
    _drawSingleClaw(
      canvas,
      startX: centerX - clawGap,
      startY: centerY,
      clawWidth: clawWidth,
      clawLength: clawLength,
      bendPoint: bendPoint,
      tipCurve: tipCurve,
      isLeft: true,
      isDeepPush: isDeepPush,
    );

    // 右爪
    _drawSingleClaw(
      canvas,
      startX: centerX + clawGap,
      startY: centerY,
      clawWidth: clawWidth,
      clawLength: clawLength,
      bendPoint: bendPoint,
      tipCurve: tipCurve,
      isLeft: false,
      isDeepPush: isDeepPush,
    );

    // ヒンジ（回転軸）- 太い金属感
    final hingePath = Path();
    hingePath.addOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: clawWidth * 0.8,
        height: clawWidth * 0.6,
      ),
    );

    canvas.drawPath(
      hingePath,
      Paint()
        ..shader =
            RadialGradient(
              colors: [Colors.grey[500]!, Colors.grey[700]!],
            ).createShader(
              Rect.fromCenter(
                center: Offset(centerX, centerY),
                width: clawWidth * 0.8,
                height: clawWidth * 0.6,
              ),
            ),
    );

    canvas.drawPath(
      hingePath,
      Paint()
        ..color = Colors.grey[800]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // ヒンジ中央のボルト
    canvas.drawCircle(
      Offset(centerX, centerY),
      clawWidth * 0.15,
      Paint()..color = Colors.grey[900]!,
    );
  }

  /// 個別の爪を描画
  void _drawSingleClaw(
    Canvas canvas, {
    required double startX,
    required double startY,
    required double clawWidth,
    required double clawLength,
    required double bendPoint,
    required double tipCurve,
    required bool isLeft,
    required bool isDeepPush,
  }) {
    final direction = isLeft ? -1.0 : 1.0;

    // 爪の外側輪郭
    final outerPath = Path();
    outerPath.moveTo(startX, startY);
    outerPath.lineTo(startX + direction * clawWidth, startY);
    outerPath.lineTo(startX + direction * clawWidth, startY + bendPoint);

    // J字のカーブ（先端が内側に曲がる）
    final tipEndX = startX + direction * clawWidth * 0.3;
    final tipEndY = startY + clawLength;

    outerPath.quadraticBezierTo(
      startX + direction * clawWidth,
      startY + bendPoint + tipCurve * 0.5,
      tipEndX,
      tipEndY,
    );

    // 内側に戻る
    final innerTipX = startX + direction * clawWidth * 0.1;
    outerPath.lineTo(innerTipX, tipEndY - tipCurve * 0.3);

    outerPath.quadraticBezierTo(
      startX,
      startY + bendPoint + tipCurve * 0.3,
      startX,
      startY + bendPoint * 0.8,
    );

    outerPath.close();

    // 影（厚み表現）
    final shadowPath = Path();
    final shadowOffset = 3.0;
    shadowPath.moveTo(startX + shadowOffset, startY + shadowOffset);
    shadowPath.lineTo(
      startX + direction * clawWidth + shadowOffset,
      startY + shadowOffset,
    );
    shadowPath.lineTo(
      startX + direction * clawWidth + shadowOffset,
      startY + bendPoint + shadowOffset,
    );
    shadowPath.quadraticBezierTo(
      startX + direction * clawWidth + shadowOffset,
      startY + bendPoint + tipCurve * 0.5 + shadowOffset,
      tipEndX + shadowOffset,
      tipEndY + shadowOffset,
    );
    shadowPath.lineTo(
      innerTipX + shadowOffset,
      tipEndY - tipCurve * 0.3 + shadowOffset,
    );
    shadowPath.close();

    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill,
    );

    // メタリックグラデーション
    final bounds = outerPath.getBounds();
    canvas.drawPath(
      outerPath,
      Paint()
        ..shader = LinearGradient(
          colors: isDeepPush
              ? [Colors.grey[600]!, Colors.grey[700]!, Colors.grey[800]!]
              : [Colors.grey[500]!, Colors.grey[600]!, Colors.grey[700]!],
          stops: const [0.0, 0.5, 1.0],
          begin: isLeft ? Alignment.centerRight : Alignment.centerLeft,
          end: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        ).createShader(bounds),
    );

    // ハイライト（金属の反射）
    final highlightPath = Path();
    highlightPath.moveTo(startX + direction * clawWidth * 0.2, startY + 5);
    highlightPath.lineTo(startX + direction * clawWidth * 0.8, startY + 5);
    highlightPath.lineTo(
      startX + direction * clawWidth * 0.8,
      startY + bendPoint * 0.5,
    );
    highlightPath.lineTo(
      startX + direction * clawWidth * 0.2,
      startY + bendPoint * 0.5,
    );
    highlightPath.close();

    canvas.drawPath(
      highlightPath,
      Paint()..color = Colors.white.withValues(alpha: 0.25),
    );

    // 輪郭
    canvas.drawPath(
      outerPath,
      Paint()
        ..color = Colors.grey[900]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  /// 狙い目矢印と重心マーカー
  void _drawTargetIndicators(
    Canvas canvas,
    Size size, {
    required double prizeCenterX,
    required double prizeCenterY,
    required double prizeWidth,
    required double prizeHeight,
    required double prizeDepth,
    required double perspectiveFactor,
    required double pivotX,
    required double pivotY,
  }) {
    // 重心位置の計算
    final gravityOffsetX = (centerOfGravity.dx - 0.5) * prizeWidth;
    final gravityOffsetY = (centerOfGravity.dy - 0.5) * prizeDepth;

    final dx = prizeCenterX - pivotX + gravityOffsetX;
    final dy = prizeCenterY - pivotY + gravityOffsetY;

    final rotatedDx = dx * cos(prizeAngle) - dy * sin(prizeAngle);
    final rotatedDy = dx * sin(prizeAngle) + dy * cos(prizeAngle);

    final gravityX = pivotX + rotatedDx;
    final gravityY = pivotY + rotatedDy;

    // 重心マーカー（大きめ、目立つ）
    canvas.drawCircle(
      Offset(gravityX, gravityY),
      10,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      Offset(gravityX, gravityY),
      10,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );

    // 内側のドット
    canvas.drawCircle(
      Offset(gravityX, gravityY),
      3,
      Paint()..color = Colors.white,
    );

    // 狙い目矢印
    final arrowStartY = size.height * 0.08;
    final arrowEndY = gravityY - 25;

    // 矢印の軸（太め）
    canvas.drawLine(
      Offset(gravityX, arrowStartY),
      Offset(gravityX, arrowEndY),
      Paint()
        ..color = Colors.orange
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round,
    );

    // 矢印の先端
    final arrowPath = Path();
    arrowPath.moveTo(gravityX, arrowEndY + 5);
    arrowPath.lineTo(gravityX - 12, arrowEndY - 15);
    arrowPath.lineTo(gravityX, arrowEndY - 8);
    arrowPath.lineTo(gravityX + 12, arrowEndY - 15);
    arrowPath.close();

    canvas.drawPath(
      arrowPath,
      Paint()
        ..color = Colors.orange
        ..style = PaintingStyle.fill,
    );

    // ラベル
    final targetText = TextPainter(
      text: const TextSpan(
        text: '狙い目',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.white, blurRadius: 2)],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    targetText.layout();
    targetText.paint(
      canvas,
      Offset(
        gravityX - targetText.width / 2,
        arrowStartY - targetText.height - 6,
      ),
    );

    final centerText = TextPainter(
      text: TextSpan(
        text: '重心',
        style: TextStyle(
          color: Colors.red[700],
          fontSize: 11,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.white.withValues(alpha: 0.8),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    centerText.layout();
    centerText.paint(
      canvas,
      Offset(gravityX - centerText.width / 2, gravityY + 14),
    );
  }

  @override
  bool shouldRepaint(covariant BridgePainter oldDelegate) {
    return oldDelegate.prizeAngle != prizeAngle ||
        oldDelegate.centerOfGravity != centerOfGravity ||
        oldDelegate.prizeColor != prizeColor ||
        oldDelegate.armVerticalPosition != armVerticalPosition ||
        oldDelegate.prizeVerticalOffset != prizeVerticalOffset ||
        oldDelegate.prizeHorizontalOffset != prizeHorizontalOffset ||
        oldDelegate.armHorizontalPosition != armHorizontalPosition ||
        oldDelegate.pivotPosition != pivotPosition ||
        oldDelegate.showArm != showArm ||
        oldDelegate.showTargetArrow != showTargetArrow;
  }
}
