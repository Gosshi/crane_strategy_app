import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/audio_service_provider.dart';
import '../../data/providers/premium_provider.dart';
import '../../data/services/user_level_service.dart';
import '../widgets/reward_ad_button.dart';
import 'collection_screen.dart'; // collectionWithProductListProvider
import '../../l10n/app_localizations.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isAnonymous = user.isAnonymous;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accountSettings),
      ),
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
                    isAnonymous
                        ? AppLocalizations.of(context)!.guestUser
                        : (user.displayName ?? 'ユーザー'),
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
                    Text(AppLocalizations.of(context)!.linkGoogleAccount),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () async {
                        try {
                          await ref
                              .read(authRepositoryProvider)
                              .linkWithGoogle();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!.linkSuccess,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.linkError(e.toString()),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.link),
                      label: Text(AppLocalizations.of(context)!.linkWithGoogle),
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
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!.linkSuccess,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.linkError(e.toString()),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.apple),
                        label: Text(
                          AppLocalizations.of(context)!.signInWithApple,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ] else ...[
            Card(
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text(AppLocalizations.of(context)!.accountLinked),
                subtitle: Text(AppLocalizations.of(context)!.dataIsSafe),
              ),
            ),
          ],
          const SizedBox(height: 24),

          // プレミアムステータスセクション
          _buildPremiumSection(theme),

          const SizedBox(height: 24),

          // 効果音設定
          _buildSoundSettingsSection(theme),
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

  Widget _buildSoundSettingsSection(ThemeData theme) {
    final audioService = ref.watch(audioServiceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '設定',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: SwitchListTile(
            title: Text(AppLocalizations.of(context)!.soundEffects),
            subtitle: Text(AppLocalizations.of(context)!.playSoundOnScan),
            value: audioService.isSoundEnabled,
            onChanged: (value) {
              audioService.setSoundEnabled(value);
              setState(() {}); // UIを更新
            },
            secondary: Icon(
              audioService.isSoundEnabled ? Icons.volume_up : Icons.volume_off,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumSection(ThemeData theme) {
    final isPremiumAsync = ref.watch(isPremiumProvider);
    final remainingTimeAsync = ref.watch(remainingPremiumTimeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.premiumFeatures,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        isPremiumAsync.when(
          data: (isPremium) {
            if (isPremium) {
              return Column(
                children: [
                  Card(
                    color: Colors.amber.withValues(alpha: 0.2),
                    child: ListTile(
                      leading: const Icon(
                        Icons.stars,
                        color: Colors.amber,
                        size: 32,
                      ),
                      title: const Text(
                        'プレミアム会員',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: remainingTimeAsync.when(
                        data: (remaining) {
                          if (remaining != null) {
                            final hours = remaining.inHours;
                            final minutes = remaining.inMinutes.remainder(60);
                            return Text(
                              AppLocalizations.of(
                                context,
                              )!.remainingTime(hours, minutes),
                            );
                          }
                          return Text(
                            AppLocalizations.of(context)!.subscriptionActive,
                          );
                        },
                        loading: () =>
                            Text(AppLocalizations.of(context)!.loading),
                        error: (_, _) =>
                            Text(AppLocalizations.of(context)!.limited24Hours),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(AppLocalizations.of(context)!.noAds),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.exclusiveBadge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          '広告を見て24時間プレミアム機能を体験！',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.premiumBenefits,
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.check, size: 16, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              AppLocalizations.of(context)!.allAdsHidden,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.check, size: 16, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              '限定バッジ（Phase 2）',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                RewardAdButton(
                  title: '広告を見て24時間プレミアム体験',
                  onRewarded: () async {
                    await ref
                        .read(premiumServiceProvider)
                        .unlockPremiumFor24Hours();
                    ref.invalidate(isPremiumProvider);
                    ref.invalidate(remainingPremiumTimeProvider);
                  },
                ),
              ],
            );
          },
          loading: () => Card(
            child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text(AppLocalizations.of(context)!.loading),
            ),
          ),
          error: (_, _) => Card(
            child: ListTile(
              leading: Icon(Icons.error, color: Colors.red),
              title: Text(AppLocalizations.of(context)!.errorOccurred),
            ),
          ),
        ),
      ],
    );
  }
}
