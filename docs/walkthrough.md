# 変更内容の確認 (Walkthrough)

## 概要
ユーザーから要望のあった「獲得履歴 (コレクション) 機能」と「データ修正依頼 (通報) 機能」を実装しました。

## 実装内容

### 1. 獲得履歴 (Collection)
ユーザーが獲得した景品を記録・閲覧できる機能です。
- **データモデル**: `CollectionItem` (`users/{uid}/collections` サブコレクション)
- **UI**:
    - **記録**: 詳細画面 (`DetailScreen`) のFABからダイアログを表示。店舗名(任意)とメモを入力可能。
    - **一覧**: ホーム画面のAppBarアクション(🏆アイコン)から `CollectionScreen` へ遷移し、リスト表示。

### 2. データ修正依頼 (Report)
JANコードの間違いなどをユーザーが報告できる機能です。
- **データモデル**: `Report` (`reports` コレクション)
- **UI**:
    - 詳細画面 (`DetailScreen`) のAppBarメニューから「情報の誤りを報告」を選択。
    - 報告理由（JAN間違い/不適切/その他）と詳細を入力して送信。

## 技術的詳細
- **State Management**: `flutter_riverpod` を使用し、`StrategyDetail` を `ConsumerStatefulWidget` に変換してRepositoryにアクセス。
- **Database**: Firestoreへの保存ロジックを実装 (現在は `guest_user` IDで動作)。

## 次のステップ
- 実際の認証 (Auth) との連携。
- 獲得履歴のグラフ化やシェア機能など。
