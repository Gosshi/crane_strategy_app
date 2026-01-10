import 'dart:math';
import 'package:flutter/material.dart';

/// 橋渡し設定のクレーンゲーム攻略図解を描画するPainter
///
/// 2本の平行棒の上に景品が乗っている状態を表現し、
/// 橋渡し攻略の手順をアニメーションで示します。
///
/// ## 縦ハメ（Vertical Fitting）
/// 景品をバーに対して垂直になるよう制御し、左右に振りながら落とす。
/// - 角を狙って初期回転を作る
/// - 対角線上の角を交互に狙う
/// - 最終的に縦向きで落下
///
/// ## 横ハメ（Horizontal Fitting）
/// 景品をバーに対して平行に保ち、片側を脱輪させて落とす。
/// - 片側を深く沈める
/// - スライドさせてバーから外す
/// - 水平のまま落下
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

  /// 景品の水平位置オフセット（-1.0 = 左端、0.0 = 中央、1.0 = 右端）
  final double prizeHorizontalOffset;

  /// アームの水平位置（-1.0 = 左端狙い、0.0 = 中央、1.0 = 右端狙い）
  final double armHorizontalPosition;

  /// 回転の支点（-1.0 = 左バー、0.0 = 中央、1.0 = 右バー）
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
    this.armHorizontalPosition = 0.4,
    this.pivotPosition = 0.0,
    this.showArm = true,
    this.showTargetArrow = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ========================================
    // 1. レイアウト計算
    // ========================================

    // 平行棒（バー）の配置
    final barY = size.height * 0.6;
    final barLeftX = size.width * 0.2;
    final barRightX = size.width * 0.8;
    final barWidth = size.width * 0.05;
    final barHeight = size.height * 0.02;

    // 景品（箱）の配置
    final barGap = barRightX - barLeftX;
    final prizeWidth = barGap * 0.8;
    final prizeHeight = size.height * 0.12;

    // 景品の中心位置（水平オフセット適用）
    final prizeCenterX =
        size.width * 0.5 + (prizeHorizontalOffset * barGap * 0.3);
    final prizeBaseY = barY - prizeHeight / 2;
    final prizeCenterY = prizeBaseY + (prizeVerticalOffset * size.height);

    // 回転の支点を計算（縦ハメ時はバーを支点に）
    final pivotX = _calculatePivotX(
      prizeCenterX,
      prizeWidth,
      barLeftX,
      barRightX,
    );
    final pivotY = barY;

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

    if (showArm && armVerticalPosition > 0.0) {
      _drawArm(canvas, size, prizeCenterX, prizeWidth, prizeBaseY, prizeHeight);
    }

    // ========================================
    // 4. 景品の描画（支点を中心に回転）
    // ========================================

    final prizePaint = Paint()
      ..color = prizeColor
      ..style = PaintingStyle.fill;

    final prizeStrokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 回転を適用（支点を中心に）
    canvas.save();
    canvas.translate(pivotX, pivotY);
    canvas.rotate(prizeAngle);
    canvas.translate(-pivotX, -pivotY);

    // 景品の矩形を定義（回転後の位置）
    final prizeRect = Rect.fromCenter(
      center: Offset(prizeCenterX, prizeCenterY),
      width: prizeWidth,
      height: prizeHeight,
    );

    // 景品本体
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

    final gravityX = prizeRect.left + prizeRect.width * centerOfGravity.dx;
    final gravityY = prizeRect.top + prizeRect.height * centerOfGravity.dy;

    final centerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(gravityX, gravityY), 8, centerPaint);

    final centerStrokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(Offset(gravityX, gravityY), 8, centerStrokePaint);

    canvas.restore();

    // ========================================
    // 6. 狙い目矢印の描画
    // ========================================

    if (showTargetArrow) {
      _drawTargetArrow(
        canvas,
        size,
        prizeCenterX,
        prizeCenterY,
        gravityX,
        gravityY,
        pivotX,
        pivotY,
      );
    }
  }

  /// 回転の支点X座標を計算
  double _calculatePivotX(
    double prizeCenterX,
    double prizeWidth,
    double barLeftX,
    double barRightX,
  ) {
    if (pivotPosition < 0) {
      // 左バーを支点
      return barLeftX;
    } else if (pivotPosition > 0) {
      // 右バーを支点
      return barRightX;
    } else {
      // 中央（デフォルト）
      return prizeCenterX;
    }
  }

  /// アームを描画
  void _drawArm(
    Canvas canvas,
    Size size,
    double prizeCenterX,
    double prizeWidth,
    double prizeBaseY,
    double prizeHeight,
  ) {
    final armPaint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.fill;

    final armStrokePaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // アームのX座標（armHorizontalPositionに基づく）
    final armX = prizeCenterX + prizeWidth * armHorizontalPosition;

    // アームの垂直位置
    final armTopY = size.height * 0.05;
    final rotatedPrizeTopY = prizeBaseY - prizeHeight / 2 * cos(prizeAngle);
    final armContactY = rotatedPrizeTopY;
    final armBottomY = armTopY + (armContactY - armTopY) * armVerticalPosition;

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

  /// 狙い目矢印を描画
  void _drawTargetArrow(
    Canvas canvas,
    Size size,
    double prizeCenterX,
    double prizeCenterY,
    double gravityX,
    double gravityY,
    double pivotX,
    double pivotY,
  ) {
    // 回転後の重心位置を計算
    final gravityOffset = Offset(gravityX - pivotX, gravityY - pivotY);
    final rotatedGravityX =
        pivotX +
        gravityOffset.dx * cos(prizeAngle) -
        gravityOffset.dy * sin(prizeAngle);
    final rotatedGravityY =
        pivotY +
        gravityOffset.dx * sin(prizeAngle) +
        gravityOffset.dy * cos(prizeAngle);

    final arrowPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final arrowStartY = size.height * 0.15;
    final arrowEndY = rotatedGravityY - 20;

    final arrowLinePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawLine(
      Offset(rotatedGravityX, arrowStartY),
      Offset(rotatedGravityX, arrowEndY),
      arrowLinePaint,
    );

    // 矢印の先端
    final arrowPath = Path();
    arrowPath.moveTo(rotatedGravityX, arrowEndY);
    arrowPath.lineTo(rotatedGravityX - 8, arrowEndY - 12);
    arrowPath.lineTo(rotatedGravityX + 8, arrowEndY - 12);
    arrowPath.close();

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
        oldDelegate.prizeVerticalOffset != prizeVerticalOffset ||
        oldDelegate.prizeHorizontalOffset != prizeHorizontalOffset ||
        oldDelegate.armHorizontalPosition != armHorizontalPosition ||
        oldDelegate.pivotPosition != pivotPosition ||
        oldDelegate.showArm != showArm ||
        oldDelegate.showTargetArrow != showTargetArrow;
  }
}
