import 'package:flutter/foundation.dart'; // kDebugMode
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/strategy.dart';
import '../../data/models/product.dart'; // Product class
import '../../data/providers/strategy_repository_provider.dart';
import '../../utils/seed_firestore.dart';
import '../widgets/strategy_card.dart';

/// 攻略法一覧画面
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strategiesAsync = ref.watch(strategiesProvider);
    final theme = Theme.of(context);

    // 検索クエリがある場合は検索結果を表示
    final isSearching = _searchQuery.isNotEmpty;
    final searchResultsAsync = isSearching
        ? ref.watch(productSearchListProvider(_searchQuery))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('クレーンゲーム攻略'),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            tooltip: '獲得履歴',
            onPressed: () => context.push('/collection'),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'アカウント',
            onPressed: () => context.push('/account'),
          ),
          // デバッグモード時のみデータ投入ボタンを表示
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.cloud_upload),
              tooltip: '初期データ投入',
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('データ投入'),
                    content: const Text(
                      'Firestoreに初期データを投入しますか？\n既存のデータは上書きされます。',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('投入する'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && context.mounted) {
                  try {
                    await seedFirestoreData();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('データ投入が完了しました')),
                      );
                      ref.invalidate(strategiesProvider);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('エラー: $e')));
                    }
                  }
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // 検索バー
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '商品名やタグで検索 (例: フィギュア)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: isSearching
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
          ),

          // コンテンツ
          Expanded(
            child: isSearching
                ? _buildSearchResults(searchResultsAsync!)
                : _buildStrategyList(strategiesAsync),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/scan'),
        icon: const Icon(Icons.camera_alt),
        label: const Text('スキャン'),
      ),
    );
  }

  Widget _buildSearchResults(AsyncValue<List<Product>> searchResultsAsync) {
    return searchResultsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text('見つかりませんでした'));
        }
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              leading: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image),
                    )
                  : const Icon(Icons.image),
              title: Text(product.name),
              subtitle: Text(product.tags.join(', ')),
              onTap: () {
                // スキャン結果画面へ遷移 (詳細表示)
                // ScanResultScreenはスキャン結果として商品を表示する役割も兼ねている
                context.push('/scan_result', extra: product.id);
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('エラー: $err')),
    );
  }

  Widget _buildStrategyList(AsyncValue<List<Strategy>> strategiesAsync) {
    return strategiesAsync.when(
      data: (strategies) {
        if (strategies.isEmpty) {
          return const Center(child: Text('攻略法がまだありません'));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: strategies.length,
          itemBuilder: (context, index) {
            final strategy = strategies[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: StrategyCard(
                strategy: strategy,
                onTap: () {
                  context.push('/detail', extra: strategy);
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('エラーが発生しました: $error')),
    );
  }
}
