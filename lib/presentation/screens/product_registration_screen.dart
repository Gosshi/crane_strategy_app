import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/product.dart';
import '../../data/models/collection_item.dart';
import '../../data/providers/strategy_repository_provider.dart';
import '../../data/providers/collection_repository_provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../presentation/screens/scan_result_screen.dart'; // productSearchProvider
import 'package:go_router/go_router.dart';

class ProductRegistrationScreen extends ConsumerStatefulWidget {
  final String barcode;
  final String? initialName;
  final String? initialImageUrl;

  const ProductRegistrationScreen({
    super.key,
    required this.barcode,
    this.initialName,
    this.initialImageUrl,
  });

  @override
  ConsumerState<ProductRegistrationScreen> createState() =>
      _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState
    extends ConsumerState<ProductRegistrationScreen> {
  late final TextEditingController _nameController;
  final _tagController = TextEditingController(); // タグ入力用
  bool _isSubmitting = false;

  // コレクションにも追加するかどうか
  bool _addToCollection = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
  }

  // カテゴリ選択肢
  final List<String> _categoryOptions = ['フィギュア', 'ぬいぐるみ', '雑貨', 'お菓子', 'その他'];

  // 重心選択肢
  final List<String> _cogOptions = ['上', '中', '下', '表', '裏', '個体差あり', '不明'];

  // 選択状態
  final List<String> _selectedCategories = [];
  final List<String> _selectedCoGs = [];
  final List<String> _tags = [];

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
      // ユーザー確保 (未ログインなら匿名ログイン)
      User? user = ref.read(currentUserProvider);
      if (user == null) {
        try {
          final authRepo = ref.read(authRepositoryProvider);
          await authRepo.signInAnonymously();
          user = authRepo.currentUser;
        } catch (e) {
          debugPrint('Auto-login failed: $e');
        }
      }

      final repository = ref.read(strategyRepositoryProvider);

      final product = Product(
        id: widget.barcode,
        name: name,
        imageUrl: widget.initialImageUrl ?? '', // 画像アップロードは未実装のため順次対応
        categories: _selectedCategories,
        centerOfGravity: _selectedCoGs,
        tags: _tags,
        strategyIds: [],
        creatorId: user?.uid, // 作成者を記録
      );

      await repository.addProduct(product);

      // コレクションへの追加
      if (_addToCollection) {
        if (user != null) {
          final collectionRepo = ref.read(collectionRepositoryProvider);
          final newItem = CollectionItem(
            id: '', // 自動生成
            productId: widget.barcode,
            acquiredAt: DateTime.now(),
            shopName: null,
            note: null,
          );
          await collectionRepo.addCollectionItem(user.uid, newItem);
        } else {
          debugPrint('Collection add skipped: User is null');
        }
      }

      if (mounted) {
        final msg = _addToCollection ? '商品を登録し、コレクションに追加しました！' : '商品を登録しました！';

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));

        // スキャン結果画面へ遷移 (GoRouterのrefreshを期待してpopではなくreplaceも検討だが、
        // 構成上 push されているので pop して refresh させるのが自然)
        // ただし ScanResultScreen は Stream ではなく Future なので、
        // プロバイダーを invalidate する必要がある。
        ref.invalidate(productSearchProvider(widget.barcode));
        context.pop(); // 戻ると再取得が走るはず
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('登録エラー: $e')));
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('商品登録')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('バーコード: ${widget.barcode}', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '商品名 *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // コレクション追加オプション
            Card(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
              elevation: 0,
              child: CheckboxListTile(
                value: _addToCollection,
                onChanged: (value) {
                  setState(() {
                    _addToCollection = value ?? true;
                  });
                },
                title: const Text(
                  'これも獲得済みとして記録する',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('登録と同時に「獲得コレクション」にも追加されます'),
                secondary: const Icon(Icons.emoji_events, color: Colors.orange),
              ),
            ),
            const SizedBox(height: 24),

            // カテゴリ選択 (Multi-select Chips)
            const Text(
              'カテゴリ (複数選択可) *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _categoryOptions.map((cat) {
                return FilterChip(
                  label: Text(cat),
                  selected: _selectedCategories.contains(cat),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(cat);
                      } else {
                        _selectedCategories.remove(cat);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // 重心選択 (Multi-select Chips)
            const Text(
              '重心 (複数選択可)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _cogOptions.map((cog) {
                return FilterChip(
                  label: Text(cog),
                  selected: _selectedCoGs.contains(cog),
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

            // タグ入力
            const Text(
              'タグ (シリーズ名など)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: const InputDecoration(
                      hintText: 'タグを入力 (例: Grandista)',
                      isDense: true,
                    ),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                IconButton(onPressed: _addTag, icon: const Icon(Icons.add)),
              ],
            ),
            Wrap(
              spacing: 8,
              children: _tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  onDeleted: () {
                    setState(() {
                      _tags.remove(tag);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : Text(_addToCollection ? '登録してGET！' : '登録する'),
            ),
          ],
        ),
      ),
    );
  }
}
