# 投稿編集・削除機能

## 概要

ユーザーが自分の投稿を編集・削除できる機能を追加しました。

## 変更内容

### 追加ファイル
- `lib/presentation/screens/post_edit_screen.dart` - 投稿編集画面

### 変更ファイル
- `lib/data/models/post.dart` - `updatedAt`フィールドと`copyWith`メソッドを追加
- `lib/data/repositories/post_repository.dart` - `updatePost`, `deletePost`, `getPostById`メソッドを追加
- `lib/router.dart` - 投稿編集画面へのルートを追加
- `lib/presentation/screens/scan_result_screen.dart` - 投稿リストに編集・削除ボタンを追加
- `firestore.rules` - 投稿者のみ編集・削除可能なルールを追加

## 機能詳細

### 投稿編集
- 自分の投稿にのみ編集ボタンが表示される
- テキストとYouTube URLを編集可能
- 画像は編集不可（既存の画像は表示のみ）

### 投稿削除
- 自分の投稿にのみ削除ボタンが表示される
- 確認ダイアログ表示後に削除を実行

### セキュリティ
- Firestoreセキュリティルールで投稿者のみ編集・削除可能に設定
- クライアント側でも権限チェックを実施

## テスト結果

```
flutter test
00:02 +15: All tests passed!
```
