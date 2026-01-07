# エラーハンドリングの統一

## 概要

ネットワーク接続チェックと共通エラーハンドラーを追加しました。

## 変更内容

### 追加パッケージ
- `connectivity_plus: ^6.1.4` - ネットワーク接続監視

### 追加ファイル
- `lib/data/services/connectivity_service.dart` - ネットワーク接続サービス
- `lib/utils/error_handler.dart` - 共通エラーハンドラー

## 新機能

### ConnectivityService
- `isConnected()` - 現在の接続状態を取得
- `onConnectivityChanged` - 接続状態の変更をStreamで監視
- RiverpodのProvider対応

### ErrorHandler
- `withRetry()` - リトライ付きでFuture処理を実行（指数バックオフ対応）
- `withTimeout()` - タイムアウト付きでFuture処理を実行
- `toAppError()` - 一般的なエラーをAppErrorに変換
- `showError()` - SnackBarでエラーメッセージを表示

### AppError
- エラー種類: network, timeout, permission, notFound, unknown
- ユーザー向けメッセージとアイコンを自動判定

## 使用例

```dart
// リトライ付き処理
final result = await ErrorHandler.withRetry(
  action: () => repository.fetchData(),
  maxAttempts: 3,
);

// エラー表示
try {
  await someAction();
} catch (e) {
  ErrorHandler.showError(context, e);
}
```
