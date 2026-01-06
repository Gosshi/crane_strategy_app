import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/term.dart';
import '../../data/providers/term_repository_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final termsAsync = ref.watch(allTermsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('用語集')),
      body: Column(
        children: [
          // 検索バー
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: '用語を検索...',
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
                _buildCategoryChip(label: 'すべて', value: null, theme: theme),
                const SizedBox(width: 8),
                ...TermCategory.labels.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildCategoryChip(
                      label: entry.value,
                      value: entry.key,
                      theme: theme,
                    ),
                  );
                }),
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
                    return term.name.toLowerCase().contains(query) ||
                        (term.reading?.contains(query) ?? false) ||
                        term.description.toLowerCase().contains(query);
                  }).toList();
                }

                if (filteredTerms.isEmpty) {
                  return const Center(child: Text('該当する用語が見つかりません'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredTerms.length,
                  itemBuilder: (context, index) {
                    final term = filteredTerms[index];
                    return _buildTermCard(term, theme);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('エラー: $error')),
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

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? value : null;
        });
      },
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.primaryContainer,
    );
  }

  Widget _buildTermCard(Term term, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Row(
          children: [
            Text(
              term.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (term.reading != null) ...[
              const SizedBox(width: 8),
              Text(
                '（${term.reading}）',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            term.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Chip(
          label: Text(
            TermCategory.labels[term.category] ?? term.category,
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
}
