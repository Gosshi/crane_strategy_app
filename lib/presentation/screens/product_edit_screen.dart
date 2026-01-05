import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product.dart';
import '../../data/providers/strategy_repository_provider.dart';
import 'package:go_router/go_router.dart';

class ProductEditScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductEditScreen({super.key, required this.product});

  @override
  ConsumerState<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends ConsumerState<ProductEditScreen> {
  late final TextEditingController _nameController;
  final _tagController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _categoryOptions = ['フィギュア', 'ぬいぐるみ', '雑貨', 'お菓子', 'その他'];
  final List<String> _cogOptions = ['上', '中', '下', '表', '裏', '個体差あり', '不明'];

  late List<String> _selectedCategories;
  late List<String> _selectedCoGs;
  late List<String> _tags;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _selectedCategories = List.from(widget.product.categories);
    _selectedCoGs = List.from(widget.product.centerOfGravity);
    _tags = List.from(widget.product.tags);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('商品名を入力してください')));
      return;
    }

    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('カテゴリを少なくとも1つ選択してください')));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final repository = ref.read(strategyRepositoryProvider);

      // 既存のProductをコピーして更新
      // creatorIdなどは既存のものを維持（Productモデルの変更が必要ない場合は特に意識しなくても良いが、
      // ProductクラスのcopyWith的なものがないのでコンストラクタで再生成）
      final updatedProduct = Product(
        id: widget.product.id,
        name: name,
        imageUrl: widget.product.imageUrl, // 画像変更は今回未対応
        imagePath: widget.product.imagePath,
        categories: _selectedCategories,
        centerOfGravity: _selectedCoGs,
        tags: _tags,
        strategyIds: widget.product.strategyIds,
        creatorId: widget.product.creatorId,
      );

      await repository.updateProduct(updatedProduct);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('商品情報を更新しました！')));
        context.pop(); // 戻る
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラー: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('商品情報の編集')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 商品名
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '商品名 *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // カテゴリ
            const Text(
              'カテゴリ (複数選択可) *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: _categoryOptions.map((category) {
                final isSelected = _selectedCategories.contains(category);
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(category);
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // 重心
            const Text(
              '重心 (複数選択可)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: _cogOptions.map((cog) {
                final isSelected = _selectedCoGs.contains(cog);
                return FilterChip(
                  label: Text(cog),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCoGs.add(cog);
                      } else {
                        _selectedCoGs.remove(cog);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // タグ
            const Text(
              'タグ (シリーズ名やキャラ名)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: const InputDecoration(hintText: 'タグを入力'),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                IconButton(onPressed: _addTag, icon: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _tags.map((tag) {
                return Chip(label: Text(tag), onDeleted: () => _removeTag(tag));
              }).toList(),
            ),
            const SizedBox(height: 32),

            // 更新ボタン
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(
                      semanticsLabel: '商品を更新しています',
                    )
                  : const Text('更新する'),
            ),
          ],
        ),
      ),
    );
  }
}
