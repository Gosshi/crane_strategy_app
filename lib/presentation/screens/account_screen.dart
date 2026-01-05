import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../data/providers/auth_provider.dart';
import '../../data/services/user_level_service.dart';
import 'collection_screen.dart'; // collectionWithProductListProvider

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isAnonymous = user.isAnonymous;

    return Scaffold(
      appBar: AppBar(title: const Text('アカウント設定')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ユーザー情報カード
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isAnonymous ? 'ゲストユーザー' : (user.displayName ?? 'ユーザー'),
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),

                  // ランク表示
                  _buildRankSection(ref, user.uid, theme),

                  const SizedBox(height: 8),
                  Text(
                    'UID: ${user.uid}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  if (!isAnonymous) ...[
                    const SizedBox(height: 4),
                    Text(user.email ?? '', style: theme.textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // アカウント連携セクション
          if (isAnonymous) ...[
            Text(
              'アカウント連携',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('データを永続化するために、\nGoogleアカウントと連携しましょう。'),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () async {
                        try {
                          await ref
                              .read(authRepositoryProvider)
                              .linkWithGoogle();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('連携に成功しました！')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('連携エラー: $e')),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.link),
                      label: const Text('Googleアカウントと連携'),
                    ),
                    if (Platform.isIOS) ...[
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () async {
                          try {
                            await ref
                                .read(authRepositoryProvider)
                                .linkWithApple();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('連携に成功しました！')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('連携エラー: $e')),
                              );
                            }
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.apple),
                        label: const Text('Appleでサインイン'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ] else ...[
            const Card(
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('アカウント連携済み'),
                subtitle: Text('データは安全に保存されています。'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRankSection(WidgetRef ref, String userId, ThemeData theme) {
    var collectionAsync = ref.watch(collectionWithProductListProvider(userId));

    return collectionAsync.when(
      data: (items) {
        final count = items.length;
        final progress = UserLevelService.getProgress(count);
        final currentRank = progress.currentRank;
        final nextRank = progress.nextRank;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(currentRank.color).withValues(alpha: 0.3),
                    Color(currentRank.color).withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(currentRank.color), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Color(currentRank.color).withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                currentRank.name,
                style: TextStyle(
                  color: Color(currentRank.color),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  shadows: [
                    Shadow(color: Color(currentRank.color), blurRadius: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (nextRank != null) ...[
              LinearProgressIndicator(
                value: progress.progress,
                backgroundColor: Colors.grey[200],
                color: Color(currentRank.color),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 4),
              Text(
                '次のランクまであと ${progress.requiredCountForNext! - count} 個',
                style: theme.textTheme.bodySmall,
              ),
            ] else
              Text(
                '最高ランク到達！',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => const SizedBox.shrink(),
    );
  }
}
