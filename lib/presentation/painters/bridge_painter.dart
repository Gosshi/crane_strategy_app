import 'dart:math';
import 'package:flutter/material.dart';

/// 橋渡し設定のクレーンゲーム攻略図解を描画するPainter
///
/// 2本の平行棒の上に景品が乗っている状態を表現し、
/// 橋渡し攻略の手順をアニメーションで示します。
///
/// カスタマイズ可能なパラメータ：
/// - [prizeAngle]: 景品の傾き角度（ラジアン）
/// - [centerOfGravity]: 重心のオフセット（0.0-1.0の相対座標）
/// - [prizeColor]: 景品の色
/// - [armVerticalPosition]: アームの垂直位置（0.0=上、1.0=下）
/// - [prizeVerticalOffset]: 景品の垂直位置オフセット（落下表現用）
class BridgePainter extends CustomPainter {
  /// 景品の傾き角度（ラジアン、デフォルト: 0.0 = 水平）
  final double prizeAngle;

  /// 重心のオフセット（0.0-1.0の相対座標、デフォルト: Offset(0.5, 0.5) = 中央）
  final Offset centerOfGravity;

  /// 景品の色（デフォルト: lightBlue[200]）
  final Color prizeColor;

  /// アームの垂直位置（0.0 = 上、1.0 = 景品に接触）
  final double armVerticalPosition;

  /// 景品の垂直位置オフセット（0.0 = バー上、1.0以上 = 落下）
  final double prizeVerticalOffset;

  const BridgePainter({
    this.prizeAngle = 0.0,
    this.centerOfGravity = const Offset(0.5, 0.5),
    this.prizeColor = const Color(0xFFB3E5FC), // lightBlue[200]
    this.armVerticalPosition = 0.0,
    this.prizeVerticalOffset = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ========================================
    // 1. レイアウト計算
    // ========================================

    // 平行棒（バー）の配置
    final barY = size.height * 0.6; // バーのY座標（下寄り）
    final barLeftX = size.width * 0.2; // 左バーのX座標
    final barRightX = size.width * 0.8; // 右バーのX座標
    final barWidth = size.width * 0.05; // バーの幅
    final barHeight = size.height * 0.02; // バーの高さ

    // 景品（箱）の配置
    final barGap = barRightX - barLeftX; // バー間の距離
    final prizeWidth = barGap * 0.8; // 景品の幅（バー間より少し小さい横長）
    final prizeHeight = size.height * 0.12; // 景品の高さ（薄い箱）
    final prizeCenterX = size.width * 0.5; // 景品の中心X
    final prizeBaseY = barY - prizeHeight / 2; // 景品の基本Y座標（バーの上）
    final prizeCenterY =
        prizeBaseY + (prizeVerticalOffset * size.height); // 景品の中心Y（落下時は下に移動）

    // ========================================
    // 2. 平行棒の描画
    // ========================================

    final barPaint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.fill;

    // 左バー
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          barLeftX - barWidth / 2,
          barY - barHeight / 2,
          barWidth,
          barHeight,
        ),
        const Radius.circular(4),
      ),
      barPaint,
    );

    // 右バー
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          barRightX - barWidth / 2,
          barY - barHeight / 2,
          barWidth,
          barHeight,
        ),
        const Radius.circular(4),
      ),
      barPaint,
    );

    // ========================================
    // 3. アームの描画
    // ========================================

    if (armVerticalPosition > 0.0) {
      final armPaint = Paint()
        ..color = Colors.grey[600]!
        ..style = PaintingStyle.fill;

      final armStrokePaint = Paint()
        ..color = Colors.grey[800]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      // アームのX座標（景品の端を押す位置）
      final armX = prizeCenterX + prizeWidth * 0.4;

      // アームの垂直位置（0.0 = 上端、1.0 = 景品の上部に接触）
      final armTopY = size.height * 0.05;
      // 回転を考慮したアーム接触位置の計算
      final rotatedPrizeTopY = prizeBaseY - prizeHeight / 2 * cos(prizeAngle);
      final armContactY = rotatedPrizeTopY;
      final armBottomY =
          armTopY + (armContactY - armTopY) * armVerticalPosition;

      // アームの垂直部分（棒）
      canvas.drawLine(
        Offset(armX, armTopY),
        Offset(armX, armBottomY),
        Paint()
          ..color = Colors.grey[700]!
          ..strokeWidth = 8.0
          ..strokeCap = StrokeCap.round,
      );

      // アームの先端（爪部分）
      final clawWidth = size.width * 0.08;
      final clawHeight = size.height * 0.03;
      final clawRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(armX, armBottomY),
          width: clawWidth,
          height: clawHeight,
        ),
        const Radius.circular(4),
      );

      canvas.drawRRect(clawRect, armPaint);
      canvas.drawRRect(clawRect, armStrokePaint);
    }

    // ========================================
    // 4. 景品の描画
    // ========================================

    final prizePaint = Paint()
      ..color = prizeColor
      ..style = PaintingStyle.fill;

    final prizeStrokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 景品の矩形を定義（回転前）
    final prizeRect = Rect.fromCenter(
      center: Offset(prizeCenterX, prizeCenterY),
      width: prizeWidth,
      height: prizeHeight,
    );

    // 回転が必要な場合は、canvas を回転させて描画
    canvas.save();
    canvas.translate(prizeCenterX, prizeCenterY);
    canvas.rotate(prizeAngle);
    canvas.translate(-prizeCenterX, -prizeCenterY);

    // 景品本体（塗りつぶし）
    canvas.drawRRect(
      RRect.fromRectAndRadius(prizeRect, const Radius.circular(8)),
      prizePaint,
    );

    // 景品の枠線
    canvas.drawRRect(
      RRect.fromRectAndRadius(prizeRect, const Radius.circular(8)),
      prizeStrokePaint,
    );

    // ========================================
    // 5. 重心マーカーの描画
    // ========================================

    // 重心の実際の位置を計算（景品矩形内の相対位置）
    final gravityX = prizeRect.left + prizeRect.width * centerOfGravity.dx;
    final gravityY = prizeRect.top + prizeRect.height * centerOfGravity.dy;

    final centerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // 重心マーカー（赤い円）
    canvas.drawCircle(Offset(gravityX, gravityY), 8, centerPaint);

    // 重心マーカーの白い枠線
    final centerStrokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(Offset(gravityX, gravityY), 8, centerStrokePaint);

    // 回転を元に戻す
    canvas.restore();

    // ========================================
    // 6. 狙い目矢印の描画
    // ========================================

    // 回転後の重心位置を計算（回転変換を適用）
    final gravityOffset = Offset(
      gravityX - prizeCenterX,
      gravityY - prizeCenterY,
    );
    final rotatedGravityX =
        prizeCenterX +
        gravityOffset.dx * cos(prizeAngle) -
        gravityOffset.dy * sin(prizeAngle);
    final rotatedGravityY =
        prizeCenterY +
        gravityOffset.dx * sin(prizeAngle) +
        gravityOffset.dy * cos(prizeAngle);

    final arrowPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    // 矢印の開始位置（重心の真上）
    final arrowStartY = size.height * 0.15;
    final arrowEndY = rotatedGravityY - 20; // 重心マーカーの少し上まで

    // 矢印の軸（線）
    final arrowLinePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawLine(
      Offset(rotatedGravityX, arrowStartY),
      Offset(rotatedGravityX, arrowEndY),
      arrowLinePaint,
    );

    // 矢印の先端（三角形）
    final arrowPath = Path();
    arrowPath.moveTo(rotatedGravityX, arrowEndY); // 先端
    arrowPath.lineTo(rotatedGravityX - 8, arrowEndY - 12); // 左
    arrowPath.lineTo(rotatedGravityX + 8, arrowEndY - 12); // 右
    arrowPath.close();

    canvas.drawPath(arrowPath, arrowPaint);

    // ========================================
    // 7. ラベルの描画
    // ========================================

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
        rotatedGravityX - targetTextPainter.width / 2,
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
      Offset(
        rotatedGravityX - centerTextPainter.width / 2,
        rotatedGravityY + 12,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant BridgePainter oldDelegate) {
    return oldDelegate.prizeAngle != prizeAngle ||
        oldDelegate.centerOfGravity != centerOfGravity ||
        oldDelegate.prizeColor != prizeColor ||
        oldDelegate.armVerticalPosition != armVerticalPosition ||
        oldDelegate.prizeVerticalOffset != prizeVerticalOffset;
  }
}
