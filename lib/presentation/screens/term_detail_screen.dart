import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/term.dart';
import '../../data/providers/term_repository_provider.dart';
import '../../l10n/app_localizations.dart';

/// 特定の用語を取得するプロバイダー
final termProvider = FutureProvider.family<Term?, String>((ref, termId) async {
  final repository = ref.watch(termRepositoryProvider);
  return repository.fetchTermById(termId);
});

/// 用語詳細画面
class TermDetailScreen extends ConsumerWidget {
  final String termId;

  const TermDetailScreen({super.key, required this.termId});

  /// Get localized text from multilingual map
  String _getLocalizedText(Map<String, String> textMap, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return textMap[locale] ??
        textMap['ja'] ??
        textMap['en'] ??
        textMap.values.first;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final termAsync = ref.watch(termProvider(termId));

    return Scaffold(
      appBar: AppBar(title: const Text('用語詳細')),
      body: termAsync.when(
        data: (term) {
          if (term == null) {
            return const Center(child: Text('用語が見つかりません'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用語名と読み
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _getLocalizedText(term.name, context),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (term.reading != null) ...[
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '（${term.reading}）',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                // カテゴリ
                Chip(
                  label: Text(() {
                    final loc = AppLocalizations.of(context)!;
                    switch (term.category) {
                      case TermCategory.basic:
                        return loc.categoryBasic;
                      case TermCategory.technique:
                        return loc.categoryTechnique;
                      case TermCategory.prize:
                        return loc.categoryPrize;
                      case TermCategory.machine:
                        return loc.categoryMachine;
                      default:
                        return term.category;
                    }
                  }()),
                  backgroundColor: theme.colorScheme.primaryContainer,
                ),

                const SizedBox(height: 24),

                // 画像（もしあれば）
                if (term.imageUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      term.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // 説明
                Text(
                  '説明',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getLocalizedText(term.description, context),
                  style: theme.textTheme.bodyLarge,
                ),

                // 関連用語
                if (term.relatedTermIds.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Text(
                    '関連用語',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: term.relatedTermIds.map((relatedId) {
                      return ActionChip(
                        label: Text(relatedId),
                        onPressed: () {
                          context.push('/term/$relatedId');
                        },
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('エラー: $error')),
      ),
    );
  }
}
