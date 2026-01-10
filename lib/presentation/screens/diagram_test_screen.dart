import 'dart:math';
import 'package:flutter/material.dart';
import 'package:crane_strategy_app/presentation/widgets/strategy_diagram.dart';

/// StrategyDiagramウィジェットの動作確認用テスト画面
///
/// 様々なパラメータパターンでStrategyDiagramを表示し、
/// 描画が正しく動作することを確認するための開発用画面です。
///
/// ## テストパターン
/// - 縦ハメアニメーション（Vertical Fitting）
/// - 横ハメアニメーション（Horizontal Fitting）
/// - 静的表示（各種角度・重心パターン）
class DiagramTestScreen extends StatelessWidget {
  const DiagramTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('図解テスト')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ========================================
          // アニメーションテスト
          // ========================================
          const Text(
            'アニメーションテスト',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),

          _buildTestSection(
            title: '縦ハメ（Vertical Fitting）',
            diagram: const StrategyDiagram(
              strategyType: 'bridge',
              animate: true,
              bridgeAnimationType: BridgeAnimationType.vertical,
            ),
            params: '角を左右交互に狙い、シーソーのように振りながら縦向きにして落とす',
          ),
          const Divider(height: 32),

          _buildTestSection(
            title: '横ハメ（Horizontal Fitting）',
            diagram: const StrategyDiagram(
              strategyType: 'bridge',
              animate: true,
              bridgeAnimationType: BridgeAnimationType.horizontal,
            ),
            params: '片側を沈めてから横にスライドさせてバーから外す',
          ),

          const Divider(height: 48),

          // ========================================
          // 静的表示テスト
          // ========================================
          const Text(
            '静的表示テスト',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),

          _buildTestSection(
            title: '基本: 水平な景品、中央重心',
            diagram: const StrategyDiagram(
              strategyType: 'bridge',
              animate: false,
            ),
            params: 'angle: 0.0°, center: (0.5, 0.5)',
          ),
          const Divider(height: 32),

          _buildTestSection(
            title: '右傾斜: 15度傾いた景品',
            diagram: StrategyDiagram(
              strategyType: 'bridge',
              prizeAngle: 15 * pi / 180,
              animate: false,
            ),
            params: 'angle: 15.0°, center: (0.5, 0.5)',
          ),
          const Divider(height: 32),

          _buildTestSection(
            title: '左傾斜: -10度傾いた景品',
            diagram: StrategyDiagram(
              strategyType: 'bridge',
              prizeAngle: -10 * pi / 180,
              animate: false,
            ),
            params: 'angle: -10.0°, center: (0.5, 0.5)',
          ),
          const Divider(height: 32),

          _buildTestSection(
            title: '右寄り重心: 水平だが重心が右寄り',
            diagram: const StrategyDiagram(
              strategyType: 'bridge',
              centerOfGravity: Offset(0.65, 0.5),
              animate: false,
            ),
            params: 'angle: 0.0°, center: (0.65, 0.5)',
          ),
          const Divider(height: 32),

          _buildTestSection(
            title: '左寄り重心: 水平だが重心が左寄り',
            diagram: const StrategyDiagram(
              strategyType: 'bridge',
              centerOfGravity: Offset(0.35, 0.5),
              animate: false,
            ),
            params: 'angle: 0.0°, center: (0.35, 0.5)',
          ),
          const Divider(height: 32),

          _buildTestSection(
            title: '複合: 傾斜+右寄り重心',
            diagram: StrategyDiagram(
              strategyType: 'bridge',
              prizeAngle: 20 * pi / 180,
              centerOfGravity: const Offset(0.6, 0.5),
              animate: false,
            ),
            params: 'angle: 20.0°, center: (0.6, 0.5)',
          ),
          const Divider(height: 32),

          _buildTestSection(
            title: '未実装: 剣山設定（プレースホルダー表示）',
            diagram: const StrategyDiagram(
              strategyType: 'kenzan',
              animate: false,
            ),
            params: 'type: kenzan (未実装タイプ)',
          ),
        ],
      ),
    );
  }

  /// テストセクションを構築
  Widget _buildTestSection({
    required String title,
    required Widget diagram,
    required String params,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        diagram,
        const SizedBox(height: 8),
        Text(
          params,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
