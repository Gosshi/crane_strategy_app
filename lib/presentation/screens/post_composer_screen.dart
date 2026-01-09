// import 'dart:io'; // 画像投稿機能無効化のため未使用
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart'; // 画像投稿機能無効化のため未使用
import '../../data/models/post.dart';
import '../../data/repositories/post_repository.dart';
import '../../data/repositories/user_service.dart';

class PostComposerScreen extends ConsumerStatefulWidget {
  final String productId;

  const PostComposerScreen({super.key, required this.productId});

  @override
  ConsumerState<PostComposerScreen> createState() => _PostComposerScreenState();
}

class _PostComposerScreenState extends ConsumerState<PostComposerScreen> {
  final _textController = TextEditingController();
  final _youtubeUrlController = TextEditingController(); // YouTube用
  // 画像投稿機能は一旦無効化（肖像権対策）
  // File? _imageFile;
  bool _isUploading = false;
  // final _picker = ImagePicker();

  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //     });
  //   }
  // }

  Future<void> _submit() async {
    final text = _textController.text.trim();
    final youtubeUrl = _youtubeUrlController.text.trim();

    if (text.isEmpty && youtubeUrl.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('コメントまたは動画URLを入力してください')));
      return;
    }

    // YouTube URLの厳密なバリデーション (YouTube限定)
    if (youtubeUrl.isNotEmpty) {
      final uri = Uri.tryParse(youtubeUrl);
      if (uri == null || uri.host.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('有効なURLを入力してくださ い')));
        return;
      }

      // YouTubeドメインのみ許可
      final host = uri.host.toLowerCase();
      final isYoutube =
          host == 'youtube.com' ||
          host == 'www.youtube.com' ||
          host == 'youtu.be' ||
          host == 'www.youtu.be' ||
          host == 'm.youtube.com';

      if (!isYoutube) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('YouTube動画のURLのみ対応しています')));
        return;
      }
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // 1. 匿名ログイン確認 (未ログインならログイン)
      final userService = ref.read(userServiceProvider);
      var user = userService.currentUser;
      if (user == null) {
        final credential = await userService.signInAnonymously();
        user = credential.user;
      }

      if (user == null) throw Exception('ログインに失敗しました');

      // 2. 画像アップロード（無効化中）
      String? imageUrl;
      final postRepository = ref.read(postRepositoryProvider);

      // if (_imageFile != null) {
      //   imageUrl = await postRepository.uploadImage(user.uid, _imageFile!);
      // }

      // 3. 投稿作成
      final post = Post(
        id: '', // Firestore側でAuto ID割り当て
        productId: widget.productId,
        userId: user.uid,
        text: text,
        imageUrl: imageUrl,
        youtubeUrl: youtubeUrl.isEmpty ? null : youtubeUrl,
        createdAt: DateTime.now(),
      );

      await postRepository.addPost(post);

      if (mounted) {
        Navigator.pop(context); // 完了したら閉じる
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('投稿しました！')));
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
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('攻略情報を投稿')),
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
            const SizedBox(height: 12),

            // 法的免責注意事項
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '投稿する動画リンクは、YouTubeの利用規約および著作権法を遵守したものに限ります。違法なコンテンツは予告なく削除されます。',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 画像投稿機能は一旦無効化（肖像権対策）
            // if (_imageFile != null)
            //   Stack(
            //     alignment: Alignment.topRight,
            //     children: [
            //       Image.file(
            //         _imageFile!,
            //         height: 200,
            //         width: double.infinity,
            //         fit: BoxFit.cover,
            //       ),
            //       IconButton(
            //         icon: const Icon(Icons.close, color: Colors.white),
            //         onPressed: () {
            //           setState(() {
            //             _imageFile = null;
            //           });
            //         },
            //         style: IconButton.styleFrom(
            //           backgroundColor: Colors.black54,
            //         ),
            //       ),
            //     ],
            //   ),
            // ElevatedButton.icon(
            //   onPressed: _pickImage,
            //   icon: const Icon(Icons.camera_alt),
            //   label: const Text('画像を追加'),
            // ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isUploading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : const Text('投稿する'),
            ),
          ],
        ),
      ),
    );
  }
}
