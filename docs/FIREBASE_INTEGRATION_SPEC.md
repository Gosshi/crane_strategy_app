# Firebase連携 (Backend) 実装計画

## 目標
`MockStrategyRepository` (ダミーデータ) から `FirestoreStrategyRepository` (クラウドデータベース) へ移行し、データの動的管理を実現する。

## 実装内容

### 1. Firebase プロジェクト設定 (ユーザー作業)
- **`flutterfire configure` の実行**
  - これにより、Firebaseプロジェクトの作成（または選択）と、Android/iOS/macOS アプリの登録が自動で行われます。
  - 成果物: `lib/firebase_options.dart`, `google-services.json` (Android), `GoogleService-Info.plist` (iOS/macOS)

### 2. パッケージ導入
- `pubspec.yaml` に以下を追加:
  - `firebase_core`: Firebase初期化用
  - `cloud_firestore`: データベース操作用

### 3. アプリ初期化 (`main.dart`)
- `WidgetsFlutterBinding.ensureInitialized()`
- `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` を `runApp` 前に呼び出し。

### 4. FirestoreRepository の実装
- **ファイル**: `lib/data/repositories/firestore_strategy_repository.dart`
- **機能**:
  - `strategies` コレクションからの取得（全件、ID指定）
  - `products` コレクションからの取得（バーコード指定）
- **変換**:
  - Firestoreの `Map<String, dynamic>` から `Strategy`/`Product` モデルへの変換ロジックを実装。
  - `withConverter` を使うと型安全に扱える。

### 5. Repository の切り替え
- `strategy_repository_provider.dart` (新規作成推奨) で、ReleaseモードかDebugモードか、あるいはフラグによって Mock と Firestore を切り替える構成にする。
- 最初は Firestore が空なので、Mock データ引き継ぎ用のスクリプトを用意するか、管理画面を作る必要がある。
  - **とりあえずの移行策**: アプリ起動時に「Firestoreが空ならMockデータを書き込む」暫定処理を入れる（開発用）。

## 検証プラン
1. アプリを起動し、エラー（`No Firebase App '[DEFAULT]' has been created` 等）が出ないこと。
2. Firestore コンソールでデータが見れること（初期データ投入後）。
3. アプリでスキャンして、Firestore上のデータが返ってくること。

## ユーザーへのお願い
この計画承認後、ターミナルで `flutterfire configure` を実行していただく必要があります。
