import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/collection_item.dart';
import '../../data/providers/collection_repository_provider.dart';
// import 'package:intl/intl.dart'; // 日付フォーマット用 (別途追加が必要)

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  // TODO: Auth実装後にユーザーIDを取得
  final String userId = 'guest_user';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final collectionAsync = ref.watch(collectionListProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('獲得コレクション')),
      body: collectionAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_events_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text('まだ獲得した景品はありません', style: theme.textTheme.titleMedium),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(item.shopName ?? '店舗名なし'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '獲得日: ${item.acquiredAt.toString().split(' ')[0]}',
                      ), // 簡易フォーマット
                      if (item.note != null && item.note!.isNotEmpty)
                        Text('メモ: ${item.note!}'),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('エラー: $error')),
      ),
    );
  }
}

// Collection List Provider
final collectionListProvider =
    FutureProvider.family<List<CollectionItem>, String>((ref, userId) async {
      final repository = ref.watch(collectionRepositoryProvider);
      return repository.fetchCollectionItems(userId);
    });
