# デバッグprint文のロガー置き換え

## 概要

本番リリース前の技術的負債解消として、デバッグ用の`print`文を適切なロガーに置き換えました。

**変更内容:**
- `logger`パッケージの導入
- カスタムロガーユーティリティの作成
- 16箇所のprint文をロガーに置き換え
- Release modeでのログ無効化

---

## 変更ファイル

### [NEW] [logger.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/utils/logger.dart)

グローバルロガーインスタンスを提供するユーティリティを作成しました。

**主な機能:**
- ビルドモード（Debug/Release）の自動検出
- ログレベルの自動設定
  - Debug mode: 全てのログレベル（Debug, Info, Warning, Error）を出力
  - Release mode: Error レベルのみ出力
- 色付きログ出力（ターミナル）
- スタックトレースの自動フォーマット

**使用方法:**
```dart
logger.d('デバッグ情報');  // Debug
logger.i('通常の情報');    // Info
logger.w('警告');         // Warning
logger.e('エラー', error: e, stackTrace: st);  // Error
```

---

### [MODIFY] [firestore_strategy_repository.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/data/repositories/firestore_strategy_repository.dart)

15箇所のprint文をロガーに置き換えました。

**変更内容:**
- L16-22: Firestore接続情報のログ → `logger.d()` / `logger.i()`
- L28-30: ドキュメント取得ログ → `logger.i()`
- L35: ドキュメント処理ログ → `logger.d()`
- L39-42: パースエラーログ → `logger.e()`
- L46-48: 成功ログ → `logger.i()`
- L51-57: FirebaseExceptionログ → `logger.e()`
- L61-64: エラーログとスタックトレース → `logger.e()` (スタックトレース自動フォーマット)

**ログレベルの振り分け:**
- デバッグ用の詳細情報 → `logger.d()`
- 通常の処理結果 → `logger.i()`
- エラー情報 → `logger.e()`

---

### [MODIFY] [term_repository.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/data/repositories/term_repository.dart)

1箇所のprint文をロガーに置き換えました。

**変更内容:**
- L18: 用語取得ログ → `logger.i()`

---

### [MODIFY] [pubspec.yaml](file:///Users/gota/Documents/src/crane_strategy_app/pubspec.yaml)

`logger`パッケージを追加しました。

**追加内容:**
```yaml
dependencies:
  logger: ^2.5.0
```

---

## テスト結果

### Flutter Analyze
```bash
$ flutter analyze
Analyzing crane_strategy_app...
No issues found! (ran in 4.5s)
```

**結果:** ✅ `avoid_print`警告が0件になることを確認

### ユニットテスト
```bash
$ flutter test
00:02 +15: All tests passed!
```

**結果:** ✅ 全てのテストがパス

---

## 技術的な詳細

### なぜprintではなくloggerを使うのか？

| 項目 | print | logger |
|------|-------|--------|
| **本番での動作** | 常に出力される | Release modeで無効化可能 |
| **ログレベル** | なし | Debug/Info/Warning/Error |
| **色付け** | なし | あり（見やすい） |
| **スタックトレース** | 手動で追加 | 自動フォーマット |
| **パフォーマンス** | 影響あり | Release modeで影響なし |

### Release modeでの動作

```dart
final logger = Logger(
  level: kReleaseMode ? Level.error : Level.debug,
);
```

この設定により、本番環境では`logger.e()`のみが出力され、`logger.d()`や`logger.i()`は完全にスキップされます。

---

## 今後の改善案

- [ ] 必要に応じて他のファイルのprint文も置き換え
- [ ] ログの出力先をファイルに変更（クラッシュレポート用）
- [ ] Firebase Crashlyticsとの連携

---

## 備考

- `logger`パッケージはFlutter公式ドキュメントで推奨されています
- `kReleaseMode`を使ってビルドモードを自動検出
- 既存のテストには影響なし
