# 用語集/Wiki機能

## 概要

クレーンゲーム初心者向けに、専門用語を検索・学習できる用語集/Wiki機能を実装しました。

## 変更内容

### 追加ファイル
- `lib/data/models/term.dart` - 用語データモデル
- `lib/data/repositories/term_repository.dart` - 用語データのCRUD操作
- `lib/data/providers/term_repository_provider.dart` - Riverpodプロバイダー
- `lib/presentation/screens/glossary_screen.dart` - 用語集画面
- `lib/presentation/screens/term_detail_screen.dart` - 用語詳細画面
- `lib/scripts/seed_terms.dart` - 初期データ投入スクリプト（12語）

### 変更ファイル
- `lib/router.dart` - 用語集と用語詳細のルート追加
- `lib/presentation/screens/home_screen.dart` - 用語集へのナビゲーション追加

## 新機能

### Termモデル
用語データの構造を定義：
- 用語名、読み、説明、カテゴリ、画像URL、関連用語ID

### カテゴリ
- 基本用語 - クッション、アーム、爪など
- 技術・攻略 - 箱押し、橋渡し、直取りなど
- 機械・設定 - アームパワー、開閉幅など
- 景品関連 - プライズ、重心など

### 用語集画面
- 検索バー（部分一致検索）
- カテゴリフィルター（Chip）
- 用語リスト表示
- 各用語カードをタップで詳細画面へ

### 用語詳細画面
- 用語名と読み
- カテゴリ表示
- 詳細な説明
- 関連用語リンク

## 初期データ

以下12語を初期データとして用意：
1. クッション
2. アーム
3. 爪
4. ユーフォーキャッチャー
5. 箱押し
6. 橋渡し
7. 直取り
8. ハマリ
9. アームパワー
10. 開閉幅
11. プライズ
12. 重心

## データ投入方法

### Firebase Consoleから手動投入
1. Firebase Consoleを開く
2. Firestoreに移動
3. `lib/scripts/seed_terms.dart`のデータを参考に手動でドキュメントを作成

### または、スクリプト実行（要Firebase CLI設定）
```bash
# Firebase Emulatorを起動
firebase emulators:start

# 別ターミナルでスクリプト実行
dart run lib/scripts/seed_terms.dart
```

## テスト手順

### 1. データ投入後の確認
1. アプリを起動
2. ホーム画面の本アイコンをタップ
3. 用語集画面が表示されることを確認

### 2. 検索機能のテスト
1. 検索バーに「アーム」と入力
2. 「アーム」「アームパワー」が表示されることを確認
3. 検索バーをクリアして全件表示に戻ることを確認

### 3. カテゴリフィルター
1. 「基本用語」チップをタップ
2. 基本用語のみが表示されることを確認
3. 「すべて」をタップして全件表示に戻ることを確認

### 4. 詳細画面
1. 「クッション」をタップ
2. 詳細が表示されることを確認
3. 関連用語「箱押し」をタップして遷移することを確認

## 技術詳細

**検索実装:**
- Firestoreから全件取得（用語数が少ないため問題なし）
- クライアント側でフィルタリング
- 名前、読み、説明すべてを検索対象

**Firestoreコレクション:**
- コレクション名: `terms`
- インデックス: `category` + `name` （カテゴリ別ソート用）

**セキュリティルール:**
```
match /terms/{termId} {
  allow read: if true;   // 全ユーザー読み取り可能
  allow write: if false; // 管理者のみ（今回は手動投入）
}
```

## 将来の拡張案
- ユーザーによる用語追加リクエスト機能
- 用語への「いいね」機能
- 画像付き用語
- 用語数が増えた場合のページネーション
