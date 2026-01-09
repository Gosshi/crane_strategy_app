import 'package:flutter/foundation.dart'; // kDebugMode
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../data/models/strategy.dart';
import '../../data/models/product.dart'; // Product class
import '../../data/providers/strategy_repository_provider.dart';
import '../../data/providers/premium_provider.dart';
import '../../utils/seed_firestore.dart';
import '../../services/ad_manager.dart';
import '../widgets/strategy_card.dart';
import '../../l10n/app_localizations.dart';

/// 攻略法一覧画面
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = AdManager().createBannerAd();
    _bannerAd!.load().then((_) {
      setState(() {
        _isBannerAdLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerAd?.dispose();
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
        title: Text(AppLocalizations.of(context)!.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.book_outlined),
            tooltip: AppLocalizations.of(context)!.glossaryTitle,
            onPressed: () => context.push('/glossary'),
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            tooltip: AppLocalizations.of(context)!.collectionTitle,
            onPressed: () => context.push('/collection'),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: AppLocalizations.of(context)!.accountTitle,
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
                    title: Text(AppLocalizations.of(context)!.dataSeeding),
                    content: const Text(
                      'Firestoreに初期データを投入しますか？\n既存のデータは上書きされます。',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(AppLocalizations.of(context)!.seed),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && context.mounted) {
                  try {
                    await seedFirestoreData();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.seedSuccess,
                          ),
                        ),
                      );
                      ref.invalidate(strategiesProvider);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.error(e.toString()),
                          ),
                        ),
                      );
                    }
                  }
                }
              },
            ),
          // 拡張攻略データ投入ボタン（デバッグモードのみ）
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.add_circle),
              tooltip: '拡張攻略データ追加',
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('拡張攻略データ追加'),
                    content: const Text(
                      '10件の攻略戦略データをFirestoreに追加しますか？\n（英語版・動画URL付き）',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('追加'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && context.mounted) {
                  try {
                    await addExtendedStrategies();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('拡張攻略データを追加しました！')),
                      );
                      ref.invalidate(strategiesProvider);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.error(e.toString()),
                          ),
                        ),
                      );
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
                hintText: AppLocalizations.of(context)!.searchPlaceholder,
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

          // バナー広告（プレミアムユーザーは非表示）
          Consumer(
            builder: (context, ref, child) {
              final isPremiumAsync = ref.watch(isPremiumProvider);
              return isPremiumAsync.when(
                data: (isPremium) {
                  if (_isBannerAdLoaded && _bannerAd != null && !isPremium) {
                    return Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: AdWidget(ad: _bannerAd!),
                    );
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) {
                  // Error時は広告を表示（フォールバック）
                  if (_isBannerAdLoaded && _bannerAd != null) {
                    return Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: AdWidget(ad: _bannerAd!),
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/scan'),
        icon: const Icon(Icons.camera_alt),
        label: Text(AppLocalizations.of(context)!.scanButton),
      ),
    );
  }

  Widget _buildSearchResults(AsyncValue<List<Product>> searchResultsAsync) {
    return searchResultsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.notFound));
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
      error: (err, stack) => Center(
        child: Text(AppLocalizations.of(context)!.error(err.toString())),
      ),
    );
  }

  Widget _buildStrategyList(AsyncValue<List<Strategy>> strategiesAsync) {
    return strategiesAsync.when(
      data: (strategies) {
        if (strategies.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noStrategiesYet),
          );
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
      error: (error, stack) => Center(
        child: Text(AppLocalizations.of(context)!.error(error.toString())),
      ),
    );
  }
}
