import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/term.dart';
import '../../data/providers/term_repository_provider.dart';
import '../../utils/responsive_utils.dart';
import '../../l10n/app_localizations.dart';

/// 全用語を取得するプロバイダー
final allTermsProvider = FutureProvider<List<Term>>((ref) async {
  final repository = ref.watch(termRepositoryProvider);
  return repository.fetchAllTerms();
});

/// 用語集画面
class GlossaryScreen extends ConsumerStatefulWidget {
  const GlossaryScreen({super.key});

  @override
  ConsumerState<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends ConsumerState<GlossaryScreen> {
  String _searchQuery = '';
  String? _selectedCategory;

  /// Get localized text from multilingual map
  String _getLocalizedText(Map<String, String> textMap) {
    final locale = Localizations.localeOf(context).languageCode;
    return textMap[locale] ??
        textMap['ja'] ??
        textMap['en'] ??
        textMap.values.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final termsAsync = ref.watch(allTermsProvider);
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.glossaryTitle)),
      body: Column(
        children: [
          // 検索バー
          Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchTerms,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // カテゴリフィルター
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip(
                  label: AppLocalizations.of(context)!.allCategory,
                  value: null,
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _buildCategoryChip(
                  label: AppLocalizations.of(context)!.categoryBasic,
                  value: TermCategory.basic,
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _buildCategoryChip(
                  label: AppLocalizations.of(context)!.categoryTechnique,
                  value: TermCategory.technique,
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _buildCategoryChip(
                  label: AppLocalizations.of(context)!.categoryPrize,
                  value: TermCategory.prize,
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _buildCategoryChip(
                  label: AppLocalizations.of(context)!.categoryMachine,
                  value: TermCategory.machine,
                  theme: theme,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 用語リスト
          Expanded(
            child: termsAsync.when(
              data: (terms) {
                // フィルタリング
                var filteredTerms = terms;

                if (_selectedCategory != null) {
                  filteredTerms = filteredTerms
                      .where((t) => t.category == _selectedCategory)
                      .toList();
                }

                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  filteredTerms = filteredTerms.where((term) {
                    final name = _getLocalizedText(term.name).toLowerCase();
                    final description = _getLocalizedText(
                      term.description,
                    ).toLowerCase();
                    return name.contains(query) ||
                        (term.reading?.contains(query) ?? false) ||
                        description.contains(query);
                  }).toList();
                }

                if (filteredTerms.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.noTermsFound),
                  );
                }

                final maxWidth = ResponsiveUtils.getContentMaxWidth(context);

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: ListView.builder(
                      padding: EdgeInsets.all(horizontalPadding),
                      itemCount: filteredTerms.length,
                      itemBuilder: (context, index) {
                        final term = filteredTerms[index];
                        return _buildTermCard(term, theme);
                      },
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  AppLocalizations.of(context)!.error(error.toString()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required String? value,
    required ThemeData theme,
  }) {
    final isSelected = _selectedCategory == value;

    return Flexible(
      child: FilterChip(
        label: Text(label, overflow: TextOverflow.ellipsis),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? value : null;
          });
        },
        selectedColor: theme.colorScheme.primaryContainer,
        checkmarkColor: theme.colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget _buildTermCard(Term term, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Row(
          children: [
            Flexible(
              child: Text(
                _getLocalizedText(term.name),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (term.reading != null) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '（${term.reading}）',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            _getLocalizedText(term.description),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Chip(
          label: Text(
            _getCategoryName(term.category),
            style: const TextStyle(fontSize: 12),
          ),
          visualDensity: VisualDensity.compact,
        ),
        onTap: () {
          context.push('/term/${term.id}');
        },
      ),
    );
  }

  String _getCategoryName(String category) {
    final loc = AppLocalizations.of(context)!;
    switch (category) {
      case TermCategory.basic:
        return loc.categoryBasic;
      case TermCategory.technique:
        return loc.categoryTechnique;
      case TermCategory.prize:
        return loc.categoryPrize;
      case TermCategory.machine:
        return loc.categoryMachine;
      default:
        return category;
    }
  }
}
