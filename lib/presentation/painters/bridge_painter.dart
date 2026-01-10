import 'dart:math';
import 'package:flutter/material.dart';

/// 橋渡し設定のクレーンゲーム攻略図解を描画するPainter
///
/// ## 物理構造
/// - 2本のバー（手前と奥）が画面を横切る
/// - 景品は2本のバーの上にまたがって乗っている
/// - クレーンの爪が景品の角を引っ掛けて動かす
///
/// ## 縦ハメ（Vertical Fitting）
/// 景品をバーに対して垂直（奥行き方向）に回転させて落とす。
/// - アームが角を押す → 反対側のバーを支点に奥行き回転
/// - Y軸回転として疑似3D表現、側面陰影で「ハの字」を強調
///
/// ## 横ハメ（Horizontal Fitting）
/// 景品をバーに平行に保ち、片側を脱輪させて横にスライド。
/// - 片側を沈める → 水平方向にスライド → 脱輪
class BridgePainter extends CustomPainter {
  /// 景品の回転角度（ラジアン）
  /// - 縦ハメ: Y軸回転（奥行き方向、-π/2 〜 π/2）
  /// - 横ハメ: Z軸回転（画面内回転、-π/6 〜 π/6 程度）
  final double prizeAngle;

  /// 重心のオフセット（0.0-1.0の相対座標）
  final Offset centerOfGravity;

  /// 景品の色
  final Color prizeColor;

  /// アームの垂直位置（0.0 = 上、1.0 = 景品に接触、1.15 = 深押し）
  final double armVerticalPosition;

  /// 景品の垂直位置オフセット（0.0 = バー上、1.0以上 = 落下）
  final double prizeVerticalOffset;

  /// 景品の水平位置オフセット（-1.0 = 左端、0.0 = 中央、1.0 = 右端）
  final double prizeHorizontalOffset;

  /// アームの水平位置（-0.5 = 左角、0.0 = 中央、0.5 = 右角）
  final double armHorizontalPosition;

  /// 回転の支点（-1.0 = 手前バー、1.0 = 奥バー）
  final double pivotPosition;

  /// アームを表示するかどうか
  final bool showArm;

  /// 狙い目矢印を表示するかどうか
  final bool showTargetArrow;

  const BridgePainter({
    this.prizeAngle = 0.0,
    this.centerOfGravity = const Offset(0.5, 0.5),
    this.prizeColor = const Color(0xFFB3E5FC), // lightBlue[200]
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
    // 1. 座標設計: 手前と奥の2本バー
    // ========================================

    // 手前のバー（画面下側、Y座標が小さい）
    final frontBarY = size.height * 0.45;
    // 奥のバー（画面上側、Y座標が大きい）
    final backBarY = size.height * 0.55;
    final barGap = backBarY - frontBarY;

    // バーの幅と高さ
    final barWidth = size.width * 0.8; // 画面を横切る
    final barHeight = size.height * 0.02;
    final barLeftX = size.width * 0.1;

    // 景品の基本サイズ
    final prizeWidth = size.width * 0.3;
    final prizeHeight = size.height * 0.12; // 箱の高さ
    final prizeDepth = barGap * 0.8; // 2本のバー間の距離に基づく

    // 景品の中心位置（水平・垂直オフセット適用）
    final basePrizeCenterX = size.width * 0.5;
    final basePrizeCenterY = (frontBarY + backBarY) / 2;

    final prizeCenterX =
        basePrizeCenterX + (prizeHorizontalOffset * size.width * 0.2);
    final prizeCenterY = basePrizeCenterY + (prizeVerticalOffset * size.height);

    // 回転の支点を計算
    final pivotX = prizeCenterX;
    final pivotY = pivotPosition < 0
        ? frontBarY
        : (pivotPosition > 0 ? backBarY : basePrizeCenterY);

    // ========================================
    // 2. 動的Zオーダー: 奥から順に描画
    // ========================================

    // 落下判定：景品がバーより下にあるか
    final isFalling = prizeVerticalOffset > 0.2;

    // 2-1. 奥のバー
    _drawBar(
      canvas,
      x: barLeftX,
      y: backBarY,
      width: barWidth,
      height: barHeight,
      isDarker: true,
    );

    // 2-2. 景品（バーより上）
    if (!isFalling) {
      _drawPrizeWith3D(
        canvas,
        size,
        prizeCenterX: prizeCenterX,
        prizeCenterY: prizeCenterY,
        prizeWidth: prizeWidth,
        prizeHeight: prizeHeight,
        prizeDepth: prizeDepth,
        pivotX: pivotX,
        pivotY: pivotY,
        frontBarY: frontBarY,
        backBarY: backBarY,
      );
    }

    // 2-3. 手前のバー
    _drawBar(
      canvas,
      x: barLeftX,
      y: frontBarY,
      width: barWidth,
      height: barHeight,
      isDarker: false,
    );

    // 2-4. 景品（バーより下、落下中）
    if (isFalling) {
      _drawPrizeWith3D(
        canvas,
        size,
        prizeCenterX: prizeCenterX,
        prizeCenterY: prizeCenterY,
        prizeWidth: prizeWidth,
        prizeHeight: prizeHeight,
        prizeDepth: prizeDepth,
        pivotX: pivotX,
        pivotY: pivotY,
        frontBarY: frontBarY,
        backBarY: backBarY,
      );
    }

    // 2-5. アーム（最前面）
    if (showArm && armVerticalPosition > 0.0) {
      _drawCraneArm(
        canvas,
        size,
        prizeCenterX: prizeCenterX,
        prizeCenterY: basePrizeCenterY,
        prizeWidth: prizeWidth,
        prizeHeight: prizeHeight,
        prizeDepth: prizeDepth,
        frontBarY: frontBarY,
        backBarY: backBarY,
      );
    }

    // 2-6. 狙い目矢印と重心マーカー
    if (showTargetArrow) {
      _drawTargetIndicators(
        canvas,
        size,
        prizeCenterX: prizeCenterX,
        prizeCenterY: prizeCenterY,
        prizeWidth: prizeWidth,
        prizeDepth: prizeDepth,
        pivotX: pivotX,
        pivotY: pivotY,
      );
    }
  }

  /// バー（橋）を描画
  void _drawBar(
    Canvas canvas, {
    required double x,
    required double y,
    required double width,
    required double height,
    required bool isDarker,
  }) {
    final barPaint = Paint()
      ..color = isDarker ? Colors.grey[800]! : Colors.grey[700]!
      ..style = PaintingStyle.fill;

    final barStrokePaint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final barRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, y - height / 2, width, height),
      const Radius.circular(4),
    );

    canvas.drawRRect(barRect, barPaint);
    canvas.drawRRect(barRect, barStrokePaint);

    // ハイライトで立体感
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: isDarker ? 0.1 : 0.2)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y - height / 2, width, height * 0.3),
        const Radius.circular(4),
      ),
      highlightPaint,
    );
  }

  /// 景品を3D表現で描画（側面陰影で「ハの字」を強調）
  void _drawPrizeWith3D(
    Canvas canvas,
    Size size, {
    required double prizeCenterX,
    required double prizeCenterY,
    required double prizeWidth,
    required double prizeHeight,
    required double prizeDepth,
    required double pivotX,
    required double pivotY,
    required double frontBarY,
    required double backBarY,
  }) {
    canvas.save();

    // 回転の支点を中心に変換
    canvas.translate(pivotX, pivotY);
    canvas.rotate(prizeAngle);
    canvas.translate(-pivotX, -pivotY);

    // Y軸回転を表現: 角度に応じて見かけの幅が変わる
    final rotationFactor = cos(prizeAngle); // -1.0 〜 1.0
    final visibleWidth = prizeWidth * rotationFactor.abs();
    final skewX = prizeWidth * sin(prizeAngle) * 0.4;

    // 箱の中心（回転後）
    final centerX = prizeCenterX;
    final centerY = prizeCenterY - prizeHeight / 2;

    // ========================================
    // 3面を描画: 上面、正面、側面
    // ========================================

    // 3-1. 側面（暗い面、奥行き感を出す）
    if (sin(prizeAngle) > 0) {
      // 右側面が見える場合
      _drawSideFace(
        canvas,
        centerX: centerX,
        centerY: centerY,
        visibleWidth: visibleWidth,
        prizeHeight: prizeHeight,
        prizeDepth: prizeDepth,
        skewX: skewX,
        isRight: true,
      );
    } else if (sin(prizeAngle) < 0) {
      // 左側面が見える場合
      _drawSideFace(
        canvas,
        centerX: centerX,
        centerY: centerY,
        visibleWidth: visibleWidth,
        prizeHeight: prizeHeight,
        prizeDepth: prizeDepth,
        skewX: skewX,
        isRight: false,
      );
    }

    // 3-2. 上面（明るい面）
    _drawTopFace(
      canvas,
      centerX: centerX,
      centerY: centerY,
      visibleWidth: visibleWidth,
      prizeDepth: prizeDepth,
      skewX: skewX,
    );

    // 3-3. 正面（メイン面）
    _drawFrontFace(
      canvas,
      centerX: centerX,
      centerY: centerY,
      visibleWidth: visibleWidth,
      prizeHeight: prizeHeight,
      prizeDepth: prizeDepth,
      skewX: skewX,
    );

    canvas.restore();
  }

  /// 側面を描画（暗い面で奥行きを強調）
  void _drawSideFace(
    Canvas canvas, {
    required double centerX,
    required double centerY,
    required double visibleWidth,
    required double prizeHeight,
    required double prizeDepth,
    required double skewX,
    required bool isRight,
  }) {
    final sidePath = Path();

    if (isRight) {
      // 右側面
      final x = centerX + visibleWidth / 2;
      sidePath.moveTo(x - skewX, centerY - prizeDepth / 2);
      sidePath.lineTo(x - skewX, centerY - prizeDepth / 2 + prizeHeight);
      sidePath.lineTo(x + skewX, centerY + prizeDepth / 2 + prizeHeight);
      sidePath.lineTo(x + skewX, centerY + prizeDepth / 2);
      sidePath.close();
    } else {
      // 左側面
      final x = centerX - visibleWidth / 2;
      sidePath.moveTo(x - skewX, centerY - prizeDepth / 2);
      sidePath.lineTo(x - skewX, centerY - prizeDepth / 2 + prizeHeight);
      sidePath.lineTo(x + skewX, centerY + prizeDepth / 2 + prizeHeight);
      sidePath.lineTo(x + skewX, centerY + prizeDepth / 2);
      sidePath.close();
    }

    // 側面は暗い色（陰影）
    final sidePaint = Paint()
      ..color = prizeColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    canvas.drawPath(sidePath, sidePaint);

    final sideStrokePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(sidePath, sideStrokePaint);
  }

  /// 上面を描画（明るい面）
  void _drawTopFace(
    Canvas canvas, {
    required double centerX,
    required double centerY,
    required double visibleWidth,
    required double prizeDepth,
    required double skewX,
  }) {
    final topPath = Path();

    // 上面の4頂点
    final topLeft = Offset(
      centerX - visibleWidth / 2 - skewX,
      centerY - prizeDepth / 2,
    );
    final topRight = Offset(
      centerX + visibleWidth / 2 - skewX,
      centerY - prizeDepth / 2,
    );
    final bottomRight = Offset(
      centerX + visibleWidth / 2 + skewX,
      centerY + prizeDepth / 2,
    );
    final bottomLeft = Offset(
      centerX - visibleWidth / 2 + skewX,
      centerY + prizeDepth / 2,
    );

    topPath.moveTo(topLeft.dx, topLeft.dy);
    topPath.lineTo(topRight.dx, topRight.dy);
    topPath.lineTo(bottomRight.dx, bottomRight.dy);
    topPath.lineTo(bottomLeft.dx, bottomLeft.dy);
    topPath.close();

    // 上面は明るい色
    final topPaint = Paint()
      ..color = prizeColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(topPath, topPaint);

    final topStrokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(topPath, topStrokePaint);
  }

  /// 正面を描画（メイン面）
  void _drawFrontFace(
    Canvas canvas, {
    required double centerX,
    required double centerY,
    required double visibleWidth,
    required double prizeHeight,
    required double prizeDepth,
    required double skewX,
  }) {
    final frontPath = Path();

    // 正面の4頂点
    final topLeft = Offset(
      centerX - visibleWidth / 2 - skewX,
      centerY - prizeDepth / 2,
    );
    final topRight = Offset(
      centerX + visibleWidth / 2 - skewX,
      centerY - prizeDepth / 2,
    );
    final bottomRight = Offset(
      centerX + visibleWidth / 2 - skewX,
      centerY - prizeDepth / 2 + prizeHeight,
    );
    final bottomLeft = Offset(
      centerX - visibleWidth / 2 - skewX,
      centerY - prizeDepth / 2 + prizeHeight,
    );

    frontPath.moveTo(topLeft.dx, topLeft.dy);
    frontPath.lineTo(topRight.dx, topRight.dy);
    frontPath.lineTo(bottomRight.dx, bottomRight.dy);
    frontPath.lineTo(bottomLeft.dx, bottomLeft.dy);
    frontPath.close();

    // 正面は中間の明るさ
    final frontPaint = Paint()
      ..color = prizeColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    canvas.drawPath(frontPath, frontPaint);

    final frontStrokePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(frontPath, frontStrokePaint);
  }

  /// クレーンのアーム（爪）を描画
  /// 回転した箱の角を正確に狙う
  void _drawCraneArm(
    Canvas canvas,
    Size size, {
    required double prizeCenterX,
    required double prizeCenterY,
    required double prizeWidth,
    required double prizeHeight,
    required double prizeDepth,
    required double frontBarY,
    required double backBarY,
  }) {
    // 回転後の箱の角の位置を計算
    final rotationFactor = cos(prizeAngle);
    final skewX = prizeWidth * sin(prizeAngle) * 0.4;
    final visibleWidth = prizeWidth * rotationFactor.abs();

    // armHorizontalPositionに基づいて狙う角を決定
    // -0.5 = 左奥角、0.0 = 中央、0.5 = 右奥角
    final targetCornerX =
        prizeCenterX +
        (visibleWidth / 2 * armHorizontalPosition * 2) +
        (skewX * (armHorizontalPosition < 0 ? -1 : 1));

    // アームの垂直位置
    final armTopY = size.height * 0.05;
    final armContactY = prizeCenterY - prizeHeight / 2 - prizeDepth / 2;
    final armBottomY =
        armTopY + (armContactY - armTopY) * armVerticalPosition.clamp(0.0, 1.0);

    // 深押しの場合、さらに下に
    final deepPushOffset =
        (armVerticalPosition - 1.0).clamp(0.0, 0.15) * size.height * 0.3;
    final finalArmBottomY = armBottomY + deepPushOffset;

    // アームの本体（垂直の支柱）
    final armBodyPaint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(targetCornerX, armTopY),
      Offset(targetCornerX, finalArmBottomY),
      armBodyPaint,
    );

    // アームの爪（開閉する2本の爪）
    _drawClaw(
      canvas,
      centerX: targetCornerX,
      centerY: finalArmBottomY,
      openAmount: armVerticalPosition < 0.9 ? 0.5 : 0.2, // 接触時に閉じる
    );
  }

  /// クレーンの爪を描画
  void _drawClaw(
    Canvas canvas, {
    required double centerX,
    required double centerY,
    required double openAmount,
  }) {
    final clawPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.fill;

    final clawStrokePaint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final clawWidth = 15.0;
    final clawHeight = 20.0;
    final clawGap = 20.0 * openAmount;

    // 左の爪
    final leftClawPath = Path();
    leftClawPath.moveTo(centerX - clawGap, centerY);
    leftClawPath.lineTo(centerX - clawGap - clawWidth, centerY);
    leftClawPath.lineTo(
      centerX - clawGap - clawWidth * 0.5,
      centerY + clawHeight,
    );
    leftClawPath.lineTo(centerX - clawGap, centerY + clawHeight * 0.8);
    leftClawPath.close();

    canvas.drawPath(leftClawPath, clawPaint);
    canvas.drawPath(leftClawPath, clawStrokePaint);

    // 右の爪
    final rightClawPath = Path();
    rightClawPath.moveTo(centerX + clawGap, centerY);
    rightClawPath.lineTo(centerX + clawGap + clawWidth, centerY);
    rightClawPath.lineTo(
      centerX + clawGap + clawWidth * 0.5,
      centerY + clawHeight,
    );
    rightClawPath.lineTo(centerX + clawGap, centerY + clawHeight * 0.8);
    rightClawPath.close();

    canvas.drawPath(rightClawPath, clawPaint);
    canvas.drawPath(rightClawPath, clawStrokePaint);

    // 爪の接続部（ヒンジ）
    final hingePaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), 8, hingePaint);
    canvas.drawCircle(
      Offset(centerX, centerY),
      8,
      Paint()
        ..color = Colors.grey[900]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  /// 狙い目矢印と重心マーカーを描画
  void _drawTargetIndicators(
    Canvas canvas,
    Size size, {
    required double prizeCenterX,
    required double prizeCenterY,
    required double prizeWidth,
    required double prizeDepth,
    required double pivotX,
    required double pivotY,
  }) {
    // 回転を考慮した重心位置
    final rotationFactor = cos(prizeAngle);
    final skewX = prizeWidth * sin(prizeAngle) * 0.4;
    final visibleWidth = prizeWidth * rotationFactor.abs();

    final gravityOffsetX = (centerOfGravity.dx - 0.5) * visibleWidth;
    final gravityOffsetY = (centerOfGravity.dy - 0.5) * prizeDepth;

    // 回転を適用した重心位置
    final dx =
        prizeCenterX -
        pivotX +
        gravityOffsetX +
        skewX * (centerOfGravity.dy - 0.5) * 2;
    final dy = prizeCenterY - pivotY + gravityOffsetY;

    final rotatedDx = dx * cos(prizeAngle) - dy * sin(prizeAngle);
    final rotatedDy = dx * sin(prizeAngle) + dy * cos(prizeAngle);

    final gravityX = pivotX + rotatedDx;
    final gravityY = pivotY + rotatedDy;

    // 重心マーカー
    final centerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(gravityX, gravityY), 8, centerPaint);

    final centerStrokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(Offset(gravityX, gravityY), 8, centerStrokePaint);

    // 狙い目矢印
    final arrowStartY = size.height * 0.15;
    final arrowEndY = gravityY - 20;

    final arrowLinePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawLine(
      Offset(gravityX, arrowStartY),
      Offset(gravityX, arrowEndY),
      arrowLinePaint,
    );

    // 矢印の先端
    final arrowPath = Path();
    arrowPath.moveTo(gravityX, arrowEndY);
    arrowPath.lineTo(gravityX - 8, arrowEndY - 12);
    arrowPath.lineTo(gravityX + 8, arrowEndY - 12);
    arrowPath.close();

    final arrowPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    canvas.drawPath(arrowPath, arrowPaint);

    // 「狙い目」ラベル
    final targetTextPainter = TextPainter(
      text: const TextSpan(
        text: '狙い目',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    targetTextPainter.layout();
    targetTextPainter.paint(
      canvas,
      Offset(
        gravityX - targetTextPainter.width / 2,
        arrowStartY - targetTextPainter.height - 4,
      ),
    );

    // 「重心」ラベル
    final centerTextPainter = TextPainter(
      text: const TextSpan(
        text: '重心',
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    centerTextPainter.layout();
    centerTextPainter.paint(
      canvas,
      Offset(gravityX - centerTextPainter.width / 2, gravityY + 12),
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
