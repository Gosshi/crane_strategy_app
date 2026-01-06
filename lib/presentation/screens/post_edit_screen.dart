import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/post.dart';
import '../../data/repositories/post_repository.dart';
import '../../data/repositories/user_service.dart';

/// 投稿編集画面
class PostEditScreen extends ConsumerStatefulWidget {
  final Post post;

  const PostEditScreen({super.key, required this.post});

  @override
  ConsumerState<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends ConsumerState<PostEditScreen> {
  late final TextEditingController _textController;
  late final TextEditingController _youtubeUrlController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.post.text);
    _youtubeUrlController = TextEditingController(
      text: widget.post.youtubeUrl ?? '',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _youtubeUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _textController.text.trim();
    final youtubeUrl = _youtubeUrlController.text.trim();

    if (text.isEmpty && youtubeUrl.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('コメントまたは動画URLを入力してください')));
      return;
    }

    // YouTube URLの簡易バリデーション
    if (youtubeUrl.isNotEmpty) {
      final uri = Uri.tryParse(youtubeUrl);
      if (uri == null ||
          !youtubeUrl.contains('youtube') && !youtubeUrl.contains('youtu.be')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('有効なYouTubeのURLを入力してください')),
        );
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final userService = ref.read(userServiceProvider);
      final user = userService.currentUser;

      if (user == null || user.uid != widget.post.userId) {
        throw Exception('この投稿を編集する権限がありません');
      }

      final updatedPost = widget.post.copyWith(
        text: text,
        youtubeUrl: youtubeUrl.isEmpty ? null : youtubeUrl,
        updatedAt: DateTime.now(),
      );

      final postRepository = ref.read(postRepositoryProvider);
      await postRepository.updatePost(updatedPost);

      if (mounted) {
        Navigator.pop(context, true); // true = 更新成功
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('投稿を更新しました')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラーが発生しました: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿を編集'),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('保存'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: '獲得のコツや重心情報をシェアしよう...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),

            // YouTube URL入力
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _youtubeUrlController,
                    decoration: const InputDecoration(
                      labelText: 'YouTube動画 (URL)',
                      hintText: 'https://...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.video_library, color: Colors.red),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: () async {
                    final data = await Clipboard.getData(Clipboard.kTextPlain);
                    if (data?.text != null) {
                      setState(() {
                        _youtubeUrlController.text = data!.text!;
                      });
                    }
                  },
                  icon: const Icon(Icons.content_paste),
                  tooltip: '貼り付け',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 既存の画像がある場合は表示 (編集不可)
            if (widget.post.imageUrl != null) ...[
              Text('添付画像 (変更不可)', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.post.imageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('更新する'),
            ),
          ],
        ),
      ),
    );
  }
}
