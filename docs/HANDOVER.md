# プロジェクト引き継ぎ資料 (Handover Documentation)

## 1. プロジェクト概要
**名称**: Crane Game Strategy App (クレーンゲーム攻略アプリ)
**目的**: クレーンゲームの攻略情報をバーコードスキャンで検索・共有・記録するアプリ。
**フェーズ**: MVP完成・リリース直前 (機能実装完了、UI調整済み)

## 2. 技術スタック
- **Framework**: Flutter (Material 3)
- **State Management**: Riverpod (riverpod_generator)
- **Router**: GoRouter
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Infrastructure**:
    - **API**: Yahoo! Shopping API (商品補完)
    - **CI**: GitHub Actions (Format/Analyze/Test)

## 3. ディレクトリ構造
- `lib/data`: Repositoryパターンによるデータ層
- `lib/presentation`: UI層 (Screen, Widget)
- `docs/`: プロジェクト文書 (`task.md`, `walkthrough.md`, `REVIEW_REPORT.md` など)

## 4. 現在の状況 (Current Status)

### 実装済み機能
- **商品スキャン**: JANコード読み取りによる検索
- **UGC**: 攻略情報の投稿 (テキスト + YouTubeリンク)
- **コレクション**: 獲得履歴の保存、"GET!" 演出 (Confetti)
- **認証**: 匿名ログイン -> Google/Apple連携
- **ゲーミフィケーション**: 獲得数ランクシステム

### 未解決・進行中の課題
- **PR #28**: `task.md` の重複削除 (Open/Merged確認中)
- **タスク**: `docs/task.md` の Phase 1 (投稿編集・削除など) が未着手

## 5. 今後のロードマップ (Next Steps)
`docs/task.md` および `docs/REVIEW_REPORT.md` に詳細があります。

1.  **Phase 1: 基盤強化 (最優先)**
    - 投稿の編集・削除機能の実装 (Firestore Rules/Repo/UI)
    - テストカバレッジの向上
2.  **Phase 2: エンゲージメント**
    - 店舗マップ連携
    - プッシュ通知
3.  **Phase 3: コミュニティ**
    - いいね・コメント機能

## 6. 開発環境の注意点
- **環境変数**: `lib/env.dart` (Git対象外) に `yahooClientId` 等が必要。
- **Firebase**: `firebase_options.dart` (Git対象外) が必要。
- **Code Generation**: データモデル変更時は `dart run build_runner build` を実行。

## 7. 既知の問題 (Known Issues)
- 商品編集画面にはUI側の権限チェックがない (Firestoreルールでは保護されている)。
- 検索結果が多い場合のメモリ負荷 (将来的にAlgolia導入推奨)。

---
*作成日: 2026-01-06*
