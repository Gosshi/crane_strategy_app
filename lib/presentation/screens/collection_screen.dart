import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/collection_item.dart';
import '../../data/models/product.dart';
import '../../data/providers/collection_repository_provider.dart';
import '../../data/providers/strategy_repository_provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../utils/share_utils.dart';
import '../widgets/collection_grid_item.dart';
import '../../l10n/app_localizations.dart';

/// コレクションアイテムと商品情報をまとめたクラス
class CollectionWithProduct {
  final CollectionItem collectionItem;
  final Product? product;

  CollectionWithProduct(this.collectionItem, this.product);
}

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  // 表示モード (true: Grid, false: List)
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final collectionAsync = ref.watch(
      collectionWithProductListProvider(user.uid),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.collectionScreenTitle),
        actions: [
          // 表示切り替えボタン
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: _isGridView
                ? AppLocalizations.of(context)!.listView
                : AppLocalizations.of(context)!.gridView,
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // プロバイダーを再取得してリフレッシュさせる
          return ref.refresh(
            collectionWithProductListProvider(user.uid).future,
          );
        },
        child: collectionAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return Stack(
                // ScrollableにするためにStackとListViewを組み合わせるか、LayoutBuilderを使う
                children: [
                  ListView(), // 空でもPull-to-refreshできるようにスクロール領域を確保
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.emoji_events_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.noPrizes,
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            if (_isGridView) {
              return _buildGridView(items);
            } else {
              return _buildListView(items);
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(AppLocalizations.of(context)!.error(error.toString())),
          ),
        ),
      ),
    );
  }

  Widget _buildListView(List<CollectionWithProduct> items) {
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.only(bottom: 24),
      itemBuilder: (context, index) {
        final item = items[index];
        final product = item.product;
        final collection = item.collectionItem;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: product?.imageUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(product!.imageUrl),
                    backgroundColor: Colors.transparent,
                  )
                : const Icon(Icons.check_circle, color: Colors.green),
            title: Text(product?.name ?? collection.shopName ?? '名称不明'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('獲得日: ${collection.acquiredAt.toString().split(' ')[0]}'),
                if (collection.note != null && collection.note!.isNotEmpty)
                  Text('メモ: ${collection.note!}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareItem(item),
            ),
            onTap: () => _showDetailDialog(item),
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<CollectionWithProduct> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return CollectionGridItem(
          item: item.collectionItem,
          product: item.product,
          onTap: () => _showDetailDialog(item),
        );
      },
    );
  }

  void _showDetailDialog(CollectionWithProduct item) {
    final product = item.product;
    final collection = item.collectionItem;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (product?.imageUrl != null)
                  Hero(
                    tag:
                        'collection_image_detail_${collection.id}', // GridItemとは別のタグにするか、遷移元によって変える必要があるが、Dialogなので別で良い
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                      child: Image.network(
                        product!.imageUrl,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product?.name ?? '名称不明',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        AppLocalizations.of(context)!.acquiredDate,
                        collection.acquiredAt.toString().split(' ')[0],
                      ),
                      if (collection.shopName != null)
                        _buildDetailRow(
                          AppLocalizations.of(context)!.shopName,
                          collection.shopName!,
                        ),
                      if (collection.note != null &&
                          collection.note!.isNotEmpty)
                        _buildDetailRow(
                          AppLocalizations.of(context)!.note,
                          collection.note!,
                        ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _shareItem(item);
                          },
                          icon: const Icon(Icons.share),
                          label: Text(
                            AppLocalizations.of(context)!.shareAction,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _shareItem(CollectionWithProduct item) {
    ShareUtils.shareCollectionItem(
      productName: item.product?.name ?? 'プライズ',
      shopName: item.collectionItem.shopName,
      acquiredAt: item.collectionItem.acquiredAt,
      note: item.collectionItem.note,
    );
  }
}

// Collection List Provider (with Product Data)
final collectionWithProductListProvider =
    FutureProvider.family<List<CollectionWithProduct>, String>((
      ref,
      userId,
    ) async {
      // 1. コレクション一覧を取得
      final collectionRepo = ref.watch(collectionRepositoryProvider);
      final collections = await collectionRepo.fetchCollectionItems(userId);

      if (collections.isEmpty) return [];

      // 2. 関連する商品IDのリスト作成
      final productIds = collections.map((c) => c.productId).toSet().toList();

      // 3. 商品情報を一括取得
      final strategyRepo = ref.watch(strategyRepositoryProvider);
      final products = await strategyRepo.fetchProductsByIds(productIds);

      // 4. Mapに変換 (高速検索用)
      final productMap = {for (var p in products) p.id: p};

      // 5. 結合して返す
      return collections.map((c) {
        return CollectionWithProduct(c, productMap[c.productId]);
      }).toList();
    });
