# Wiki機能と攻略法フィードの改善

## 概要

本PRでは、以下の機能追加と問題修正を実施しました：

1. **用語集（Wiki）へのナビゲーション追加**
2. **Firestore Rulesに用語集のアクセスルールを追加**
3. **攻略法フィードに更新日時を表示**
4. **攻略法データの表示問題を解決**

---

## 変更内容

### 1. 用語集へのナビゲーション追加

ホーム画面のAppBarに辞書アイコンのボタンを追加し、用語集画面への遷移を実装しました。

**変更ファイル:**
- `lib/presentation/screens/home_screen.dart`

**変更内容:**
- AppBarに`Icons.book_outlined`の用語集ボタンを追加
- `/glossary`ルートへの遷移を実装

---

### 2. Firestore Rulesの更新

`terms`コレクションへのアクセスルールを追加しました。

**変更ファイル:**
- `firestore.rules`

**ルール内容:**
```rules
match /terms/{termId} {
  allow read: if true;
  allow write: if false;
}
```

---

### 3. 攻略法カードに更新日時を表示

各攻略法カードに最終更新日時を表示する機能を追加しました。

**変更ファイル:**
- `lib/data/models/strategy.dart` - `updatedAt`フィールドを追加
- `lib/presentation/widgets/strategy_card.dart` - 更新日時の表示を追加
- `lib/data/seeds/initial_data.dart` - 初期データに更新日時を追加
- `lib/utils/seed_firestore.dart` - データ投入時に現在時刻を設定
- `pubspec.yaml` - `intl`パッケージを追加

**表示形式:**
- `2026年1月6日 23:29 更新`

---

### 4. 攻略法データ表示問題の解決

**問題:** 本番Firebaseにデータが存在するのにアプリで0件取得される

**原因:** 既存データに不整合があった

**解決策:**
- Firebaseコンソールで既存ドキュメントを削除し、再投入
- サーバーから直接取得する設定を追加（キャッシュ問題の回避）

---

## テスト

### 実施した確認

- [x] ホーム画面に用語集ボタンが表示される
- [x] 用語集画面に22件の用語が表示される
- [x] 用語詳細画面に正しく遷移する
- [x] 攻略法カードに更新日時が表示される
- [x] データ再投入で現在時刻が設定される

---

## スクリーンショット

（必要に応じて追加）

---

## 備考

- `intl`パッケージを新規追加しました
- `initial_data.dart`の`const`リストを`final`に変更（DateTime()使用のため）
- Firestore Rulesをデプロイ済み
