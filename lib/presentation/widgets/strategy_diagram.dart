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
/// )
/// ```
class StrategyDiagram extends StatelessWidget {
  /// 攻略タイプ（例: 'bridge', 'kenzan', '3-claw'）
  final String strategyType;

  /// 景品の傾き角度（ラジアン、オプション）
  final double? prizeAngle;

  /// 重心の位置（0.0-1.0の相対座標、オプション）
  final Offset? centerOfGravity;

  const StrategyDiagram({
    super.key,
    required this.strategyType,
    this.prizeAngle,
    this.centerOfGravity,
  });

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
    final painter = _getPainter();

    if (painter != null) {
      return CustomPaint(painter: painter, size: Size.infinite);
    } else {
      // 未実装のタイプの場合はプレースホルダーを表示
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '「$strategyType」の図解は未実装です',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }
  }

  /// strategyTypeに応じた適切なCustomPainterを返す
  ///
  /// 未実装のタイプの場合はnullを返します。
  CustomPainter? _getPainter() {
    // 空文字列チェック
    if (strategyType.isEmpty) {
      return null;
    }

    switch (strategyType.toLowerCase()) {
      case 'bridge':
      case '橋渡し':
        return BridgePainter(
          prizeAngle: prizeAngle ?? 0.0,
          centerOfGravity: centerOfGravity ?? const Offset(0.5, 0.5),
        );
      // 将来の拡張用
      // case 'kenzan':
      // case '剣山':
      //   return KenzanPainter(
      //     prizeAngle: prizeAngle ?? 0.0,
      //     centerOfGravity: centerOfGravity ?? const Offset(0.5, 0.5),
      //   );
      // case '3-claw':
      // case '3本爪':
      //   return ThreeClawPainter(
      //     prizeAngle: prizeAngle ?? 0.0,
      //     centerOfGravity: centerOfGravity ?? const Offset(0.5, 0.5),
      //   );
      default:
        return null;
    }
  }
}
