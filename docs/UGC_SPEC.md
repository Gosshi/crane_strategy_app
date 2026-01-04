# UGC (ユーザー投稿) 機能 実装仕様書

## 概要
ユーザーがクレーンゲームの商品に対して、個人の攻略情報（獲得手順、重心、コツなど）を投稿・閲覧できる機能。
ログインの手間を省くため、裏側でFirebase Authenticationの匿名認証を使用する。
画像投稿にはFirebase Storageを使用し、投稿データはFirestoreの`posts`コレクションに保存する。

## データモデル
### Post (Firestore: `posts/{docId}`)
- `productId` (String): 対象商品のJANコード (index付与推奨)
- `userId` (String): 投稿者のUID
- `text` (String): コメント本文
- `imageUrl` (String?): 画像のダウンロードURL (任意)
- `createdAt` (Timestamp): 投稿日時 (作成順ソート用)

## 画面・機能構成

### 1. 投稿リスト表示 (`ScanResultScreen`)
- 「みんなの攻略情報」セクションを追加。
- 商品IDに紐づく投稿を `createdAt` 降順でリアルタイム表示 (`StreamProvider`)。
- 画像がある場合はサムネイル表示。

### 2. 投稿作成 (`PostComposerScreen`)
- テキスト入力フォームと画像添付ボタン。
- **匿名認証**:
  - `UserService` が現在の認証状態をチェック。
  - 未ログインの場合、投稿直前に `signInAnonymously()` を実行してUIDを取得。
- **画像アップロード**:
  - `ImagePicker` でギャラリーから選択。
  - `FirebaseStorage` の `/posts/{userId}/{timestamp}.jpg` にアップロード。
- **データ保存**:
  - Firestoreへの書き込み完了後、画面を閉じてスナックバーを表示。

## 必要な権限 (iOS)
- `NSPhotoLibraryUsageDescription`: 画像選択のため。

## 今後の拡張性
- 「いいね」機能
- ユーザープロフィール画面
- 投稿の通報・削除機能
