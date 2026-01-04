# コレクション・修正依頼機能の実装 (PR用ドキュメント)

## 概要
本プルリクエストでは、ユーザーが獲得した商品を記録する「コレクション機能」と、データの誤りを報告する「修正依頼機能」を実装しました。
また、ユーザーフィードバックに基づき、スキャン結果画面からのスムーズな登録フローの整備を行いました。

## 主な変更点

### 1. 獲得履歴 (コレクション) 機能
- **獲得記録**: `ScanResultScreen` (商品詳細) に「この商品をGETした！」ボタンを追加。
- **日時選択**: 獲得日をカレンダーから選択可能 (デフォルトは当日)。
- **履歴閲覧**: ホーム画面右上に追加したトロフィーアイコンから、獲得履歴一覧 (`CollectionScreen`) へ遷移可能。
- **データ**: `CollectionItem` モデルと Firestore への保存処理 (`collectionRepositoryProvider`) を実装。

### 2. データ修正依頼 (通報) 機能
- **報告UI**: 商品/動画詳細画面のメニューに「情報の誤りを報告」を追加。
- **報告フォーム**: JANコード間違い、不適切コンテンツなどの種別と、詳細コメントを送信可能。
- **データ**: `Report` モデルと Firestore 保存処理 (`reportRepositoryProvider`) を実装。

### 3. UX改善
- **スキャン→登録**: 未登録商品をスキャンした際、JANコードを引き継いでスムーズに登録画面へ遷移できるように修正。
- **仕様変更**: 動画詳細 (`DetailScreen`) からの獲得記録機能は、攻略法が汎用的であるため削除予定でしたが、ユーザー要望により復元・維持されています。

### 4. ユーザー認証 (Anonymous Auth)
- **匿名認証導入**: `firebase_auth` パッケージにより、アプリ起動時に自動的に匿名ユーザーとしてログインします。
- **実UID利用**: 獲得記録、コレクション、通報機能において、仮の `guest_user` ではなく、Firebase Auth で発行された一意な User ID を使用するように変更しました。
- **セキュリティ向上**: ユーザーごとのデータ分離が可能になりました。

## 確認方法
1. **獲得記録**:
    - 既存の商品JANコードをスキャンまたは検索。
    - 「この商品をGETした！」ボタンをタップし、店舗名・メモ・獲得日を入力して記録。
    - **アプリを完全に終了（タスクキル）して再起動しても、同じユーザーIDが自動的に復元され、獲得履歴が残っていることを確認**。
2. **通報**:
    - 詳細画面右上のメニューから「情報の誤りを報告」を選択し、送信できることを確認。
    - Firestore の `reports` コレクションに、正しい `reporterId` (UID) が保存されていることを確認。
3. **テスト**:
    - `flutter test test/auth_repository_test.dart` を実行し、認証ロジックのテストがパスすることを確認。


### 5. Apple Sign-In (iOS)
- **パッケージ**: `sign_in_with_apple` を導入。
- **実装**: `AuthRepository` に `linkWithApple` / `signInWithApple` を実装し、iOS端末のみ `AccountScreen` に「Appleでサインイン」ボタンを表示。

## ⚠️ 必要な設定 (iOS)
Apple Sign-In を機能させるには、Xcodeでの設定が必要です。

1. `ios/Runner.xcworkspace` を Xcode で開く。
2. 左側のナビゲーターで `Runner` (Project) を選択し、TARGETS の `Runner` を選択。
3. `Signing & Capabilities` タブを開く。
4. `+ Capability` ボタンを押し、`Sign in with Apple` を追加する。

## ⚠️ 必要な設定 (Android)
Android版でGoogleログインを使用するには、**SHA-1証明書フィンガープリント**をFirebaseコンソールに登録する必要があります。
現状、開発環境でこの値が設定されていません。

**手順**:
1. Java (JDK 17以上) がインストールされた環境で以下を実行:
   ```bash
   cd android && ./gradlew signingReport
   ```
   
   **エラー「SDK location not found」が出る場合**:
   `android/local.properties` というファイルを新規作成し、以下の行を追加してください（パスはご自身の環境に合わせてください）:
   ```properties
   sdk.dir=/Users/USERNAME/Library/Android/sdk
   ```
2. 出力された `SHA1` を [Firebase Console](https://console.firebase.google.com/) の「Androidアプリ」設定に追加。
3. `google-services.json` を再ダウンロードして `android/app/` に配置 (必要な場合)。

## 補足
- ユーザーIDは現状仮の `'guest_user'` を使用しています (認証実装後に置き換え予定)。
- 獲得履歴詳細画面はまだ実装していませんが、一覧表示は可能です。
