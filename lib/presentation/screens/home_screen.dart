import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/mock_strategy_repository.dart';
import '../widgets/strategy_card.dart';

/// 攻略法一覧画面
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strategiesAsync = ref.watch(strategiesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('クレーンゲーム攻略'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      body: strategiesAsync.when(
        data: (strategies) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(strategiesProvider);
          },
          child: strategies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '攻略法がありません',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: strategies.length,
                  itemBuilder: (context, index) {
                    final strategy = strategies[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: StrategyCard(
                        strategy: strategy,
                        onTap: () {
                          // 詳細画面へ遷移
                          context.push('/detail', extra: strategy);
                        },
                      ),
                    );
                  },
                ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'データの読み込みに失敗しました',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () {
                  ref.invalidate(strategiesProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('再読み込み'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // バーコードスキャナー画面へ遷移
          context.push('/scan');
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('スキャン'),
      ),
    );
  }
}
