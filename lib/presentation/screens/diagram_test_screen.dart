import 'dart:math';
import 'package:flutter/material.dart';
import 'package:crane_strategy_app/presentation/widgets/strategy_diagram.dart';

/// StrategyDiagramウィジェットの動作確認用テスト画面
///
/// 様々なパラメータパターンでStrategyDiagramを表示し、
/// 描画が正しく動作することを確認するための開発用画面です。
///
/// ## テストパターン
/// - 基本（水平、中央重心）
/// - 右傾斜（15度）
/// - 左傾斜（-10度）
/// - 右寄り重心
/// - 左寄り重心
/// - 複合（傾斜+偏重心）
/// - 未実装タイプ（プレースホルダー確認）
class DiagramTestScreen extends StatelessWidget {
  const DiagramTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('図解テスト')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTestSection(
            title: '基本: 水平な景品、中央重心',
            diagram: const StrategyDiagram(strategyType: 'bridge'),
            params: 'angle: 0.0°, center: (0.5, 0.5)',
          ),
          const Divider(height: 32),
          _buildTestSection(
            title: '右傾斜: 15度傾いた景品',
            diagram: StrategyDiagram(
              strategyType: 'bridge',
              prizeAngle: 15 * pi / 180,
            ),
            params: 'angle: 15.0°, center: (0.5, 0.5)',
          ),
          const Divider(height: 32),
          _buildTestSection(
            title: '左傾斜: -10度傾いた景品',
            diagram: StrategyDiagram(
              strategyType: 'bridge',
              prizeAngle: -10 * pi / 180,
            ),
            params: 'angle: -10.0°, center: (0.5, 0.5)',
          ),
          const Divider(height: 32),
          _buildTestSection(
            title: '右寄り重心: 水平だが重心が右寄り',
            diagram: const StrategyDiagram(
              strategyType: 'bridge',
              centerOfGravity: Offset(0.65, 0.5),
            ),
            params: 'angle: 0.0°, center: (0.65, 0.5)',
          ),
          const Divider(height: 32),
          _buildTestSection(
            title: '左寄り重心: 水平だが重心が左寄り',
            diagram: const StrategyDiagram(
              strategyType: 'bridge',
              centerOfGravity: Offset(0.35, 0.5),
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
            ),
            params: 'angle: 20.0°, center: (0.6, 0.5)',
          ),
          const Divider(height: 32),
          _buildTestSection(
            title: '未実装: 剣山設定（プレースホルダー表示）',
            diagram: const StrategyDiagram(strategyType: 'kenzan'),
            params: 'type: kenzan (未実装タイプ)',
          ),
        ],
      ),
    );
  }

  /// テストセクションを構築
  ///
  /// [title] セクションのタイトル
  /// [diagram] 表示するStrategyDiagramウィジェット
  /// [params] パラメータ情報の説明文
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
