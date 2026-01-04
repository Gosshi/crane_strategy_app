# タスク

- [x] データモデルの正規化とバーコードスキャン準備
- [x] バーコードスキャン機能の実装
- [x] 開発環境の自動化と整備
- [x] バックエンド統合 (Firebase Integration)
- [x] 初期データ投入 (Seeding)
- [x] UGC (ユーザー投稿) 機能の実装
- [x] Firestore接続問題の修正 (ATS設定追加)
- [x] 商品登録 (CGM) 機能の実装
- [x] キーワード検索機能の実装

- [ ] デザイン・UXのブラッシュアップ <!-- id: 80 -->
    - [x] `google_fonts` パッケージの追加 <!-- id: 81 -->
    - [x] `AppTheme` クラスの実装 (Dark/Neon) <!-- id: 82 -->
    - [x] `main.dart` へのテーマ適用 <!-- id: 83 -->
    - [x] ドキュメント (`task.md` 等) の `docs/` 同期 <!-- id: 84 -->
        - [x] `docs/task.md` 作成
        - [x] `docs/walkthrough.md` 作成
    - [x] UI調整 (HomeScreen, ScanResultScreen) <!-- id: 85 -->

- [x] テスト実装 & CIセットアップ <!-- id: 90 -->
    - [x] Unit/Widget Tests の実装 <!-- id: 91 -->
    - [x] Pre-commit Hook (Format/Analyze/Test) の導入 <!-- id: 92 -->

- [x] デザイン・UXのブラッシュアップ (残り) <!-- id: 95 -->
    - [x] アプリアイコン・スプラッシュ画面 <!-- id: 96 -->
    - [x] 詳細画面のUI改善 <!-- id: 97 -->

- [ ] (Future) 商品情報の編集・削除機能 <!-- id: 100 -->
    - [ ] JANコード変更（マイグレーション）対応 <!-- id: 101 -->

- [x] 獲得履歴 (コレクション) 機能の実装 <!-- id: 110 -->
    - [x] データモデル作成 (Acquisition/Collection) <!-- id: 111 -->
    - [x] 店舗名 (shopName) の保存 (null許容) <!-- id: 112 -->
    - [x] 獲得履歴一覧画面の実装 <!-- id: 113 -->

- [x] データ修正依頼 (通報) 機能の実装 <!-- id: 120 -->
    - [x] 通報/修正依頼 UI (JANコード間違い指摘など) <!-- id: 121 -->
    - [x] 管理者向け通知 または 自動フラグ処理 (Firestore保存のみ) <!-- id: 122 -->
