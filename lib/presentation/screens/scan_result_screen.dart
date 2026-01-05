import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/providers/strategy_repository_provider.dart';
import '../../data/models/product.dart';
import '../../data/models/strategy.dart';
import '../../data/repositories/post_repository.dart';
import 'package:url_launcher/url_launcher.dart'; // Attribution link
import '../../data/repositories/yahoo_shopping_repository.dart';
import '../widgets/strategy_card.dart';
import 'post_composer_screen.dart'; // 新規作成

final productSearchProvider = FutureProvider.family<Product?, String>((
  ref,
  barcode,
) async {
  debugPrint('Scanning product: $barcode');
  try {
    final repository = ref.watch(strategyRepositoryProvider);
    final result = await repository
        .fetchProductByBarcode(barcode)
        .timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            throw Exception('Connection timeout');
          },
        );
    debugPrint('Scan result: $result');
    return result;
  } catch (e) {
    debugPrint('Scan error: $e');
    rethrow;
  }
});

/// 商品に関連する攻略法を取得するプロバイダー
final relatedStrategiesProvider =
    FutureProvider.family<List<Strategy>, List<String>>((ref, ids) async {
      if (ids.isEmpty) return [];
      final repository = ref.watch(strategyRepositoryProvider);
      return repository.fetchStrategiesByIds(ids);
    });

/// スキャン結果画面
class ScanResultScreen extends ConsumerWidget {
  final String barcode;

  const ScanResultScreen({super.key, required this.barcode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // リポジトリを取得
    // final repository = ref.watch(strategyRepositoryProvider);
    final productAsync = ref.watch(productSearchProvider(barcode));
    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('スキャン結果'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // スキャン画面に戻らずホームに戻る場合は修正が必要だが、
            // ここではシンプルにpop（スキャン画面に戻ると再スキャンになるため、実際はホームまで戻るのがUX良いかも）
            // GoRouterなら context.go('/') でホームに戻れる
            context.go('/');
          },
        ),
      ),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return _buildNotFound(context, ref);
          }
          return _buildProductDetail(context, ref, product);
        },
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('商品を検索中...'),
            ],
          ),
        ),
        error: (err, stack) => Center(child: Text('エラーが発生しました: $err')),
      ),
      floatingActionButton: productAsync.when(
        data: (product) {
          if (product == null) return null;
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      PostComposerScreen(productId: product.id),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('攻略を投稿'),
          );
        },
        loading: () => null,
        error: (error, stackTrace) => null,
      ),
    );
  }

  Widget _buildNotFound(BuildContext context, WidgetRef ref) {
    // Yahoo API検索の状態管理用 (本来は専用のProviderを作るべきだが簡易的にFutureBuilder等で対応、
    // あるいはこのWidget自体をConsumerStatefulWidgetにするのが適切)
    // ここではリファクタリングを避けるため、簡易的に即時実行するProviderを定義してwatchする形を取るか、
    // あるいはConsumerStatefulWidgetに変換するのがベスト。
    // 今回は ConsumerStatefulWidget に変換するコストを避けるため、
    // 別途作成した `_YahooApiSearchSection` ウィジェットを呼び出す形にする。

    return _YahooApiSearchSection(barcode: barcode);
  }

  Widget _buildProductDetail(
    BuildContext context,
    WidgetRef ref,
    Product product,
  ) {
    final theme = Theme.of(context);
    final relatedStrategiesAsync = ref.watch(
      relatedStrategiesProvider(product.strategyIds),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 商品情報カード
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'JAN: ${product.id}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 関連攻略法セクション
          Text(
            'この商品の攻略法',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          relatedStrategiesAsync.when(
            data: (strategies) {
              if (strategies.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('関連する攻略法はまだありません'),
                  ),
                );
              }
              return Column(
                children: strategies.map((strategy) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: StrategyCard(
                      strategy: strategy,
                      onTap: () {
                        context.push('/detail', extra: strategy);
                      },
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, s) => Text('攻略法の読み込みエラー: $e'),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'みんなの攻略情報',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // 投稿リスト
          Consumer(
            builder: (context, ref, child) {
              final postsAsync = ref.watch(postsStreamProvider(product.id));
              return postsAsync.when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('まだ投稿はありません。\n最初の攻略情報を投稿しよう！'),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (post.imageUrl != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      post.imageUrl!,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              if (post.text.isNotEmpty)
                                Text(
                                  post.text,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                post.createdAt.toString().split('.')[0],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('エラーが発生しました: $err')),
              );
            },
          ),
          const SizedBox(height: 80), // FAB用のスペース
        ],
      ),
    );
  }
}

class _YahooApiSearchSection extends ConsumerStatefulWidget {
  final String barcode;
  const _YahooApiSearchSection({required this.barcode});

  @override
  ConsumerState<_YahooApiSearchSection> createState() =>
      __YahooApiSearchSectionState();
}

class __YahooApiSearchSectionState
    extends ConsumerState<_YahooApiSearchSection> {
  // 状態: 0:未検索/検索中, 1:発見, 2:見つからず
  // ただし初期表示で自動検索したい

  // FutureProvider.family を使う手もあるが、
  // ここで直接 Repository を呼んで state 管理する方がシンプル

  bool _isLoading = true;
  YahooProductItem? _yahooItem;

  @override
  void initState() {
    super.initState();
    _searchYahoo();
  }

  Future<void> _searchYahoo() async {
    try {
      // ユーザー体験のため、あえて少し待つ（パッと切り替わると見落とすため）
      // かつ Firestore 検索が Not Found だった直後なので。
      await Future.delayed(const Duration(milliseconds: 500));

      final repo = ref.read(yahooShoppingRepositoryProvider);
      final item = await repo.searchByJanCode(widget.barcode);
      _yahooItem = item;
    } catch (e) {
      debugPrint('Yahoo Search Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Yahoo!ショッピングから情報を検索中...'),
          ],
        ),
      );
    }

    if (_yahooItem != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              const Text(
                '商品情報が見つかりました！',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (_yahooItem!.imageUrl != null)
                        Image.network(_yahooItem!.imageUrl!, height: 120),
                      const SizedBox(height: 8),
                      Text(
                        _yahooItem!.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  context.push(
                    '/product_register',
                    extra: {
                      'barcode': widget.barcode,
                      'initialName': _yahooItem!.name,
                      'initialImageUrl': _yahooItem!.imageUrl,
                    },
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('この情報を使って登録'),
              ),
              const SizedBox(height: 16),
              // Yahoo! Shopping Attribution
              TextButton(
                onPressed: () async {
                  final Uri url = Uri.parse('https://shopping.yahoo.co.jp/');
                  if (!await launchUrl(url)) {
                    debugPrint('Could not launch $url');
                  }
                },
                child: const Text(
                  'Web Services by Yahoo! JAPAN',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Yahooでも見つからなかった場合 (従来の Not Found 画面)
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              '商品が見つかりませんでした',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'スキャンしたコード: ${widget.barcode}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('ホームに戻る'),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                context.push('/product_register', extra: widget.barcode);
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('手動で登録する'),
            ),
          ],
        ),
      ),
    );
  }
}
