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

- [x] デザイン・UXのブラッシュアップ <!-- id: 80 -->
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

- [x] (Future) 商品情報の自動補完 (Yahoo!ショッピングAPI) <!-- id: 102 -->
    - [x] APIクライアント実装 (`http` package + `env.dart`) <!-- id: 103 -->
    - [x] 商品名・画像URLの取得とフォームへのセット <!-- id: 104 -->
    - [x] JANコード手動入力機能 <!-- id: 108 -->
- [ ] (Future) コレクション展覧会UI (Gallery View) <!-- id: 105 -->
    - [ ] グリッド/カバーフロー表示の実装 <!-- id: 106 -->
    - [ ] 画像詳細ビューとシェア機能 <!-- id: 107 -->
- [ ] (Future) 商品情報の編集・削除機能 <!-- id: 100 -->
    - [ ] JANコード変更（マイグレーション）対応 <!-- id: 101 -->

- [x] 獲得履歴 (コレクション) 機能の実装 <!-- id: 110 -->
    - [x] データモデル作成 (Acquisition/Collection) <!-- id: 111 -->
    - [x] 店舗名 (shopName) の保存 (null許容) <!-- id: 112 -->
    - [x] 獲得履歴一覧画面の実装 <!-- id: 113 -->
    - [x] 商品詳細 (ScanResult) からの獲得記録 <!-- id: 114 -->
    - [x] (Change) 動画詳細からの獲得記録を削除 (汎用攻略のため) <!-- id: 115 -->
    - [x] 獲得日 (acquiredAt) の選択機能追加 <!-- id: 116 -->

- [x] データ修正依頼 (通報) 機能の実装 <!-- id: 120 -->
    - [x] 通報/修正依頼 UI (JANコード間違い指摘など) <!-- id: 121 -->
    - [x] 管理者向け通知 または 自動フラグ処理 (Firestore保存のみ) <!-- id: 122 -->

- [x] ユーザー認証 (Firebase Auth) の実装 <!-- id: 130 -->
    - [x] `firebase_auth` パッケージの導入 <!-- id: 131 -->
    - [x] 匿名認証 (Anonymous Auth) の実装 <!-- id: 132 -->
    - [x] 認証状態の管理 (Riverpod provider) <!-- id: 133 -->
    - [x] `guest_user` から実ユーザーIDへの置き換え <!-- id: 134 -->
    - [x] (Option) Google/Emailログインへのアップグレード導線 <!-- id: 135 -->
        - [x] `google_sign_in` パッケージの導入 <!-- id: 136 -->
        - [x] AuthRepository に `linkWithGoogle` 実装 <!-- id: 137 -->
        - [x] マイページ (AccountScreen) の作成と連携UI実装 <!-- id: 138 -->
        - [x] iOS/Android ネイティブ設定 (URL Scheme, SHA-1) <!-- id: 139 -->
    - [x] Apple Sign-In の追加 <!-- id: 140 -->
        - [x] `sign_in_with_apple` パッケージ導入 <!-- id: 141 -->
        - [x] AuthRepository に `linkWithApple` 実装 <!-- id: 142 -->
        - [x] AccountScreen に Apple連携ボタン追加 <!-- id: 143 -->
        - [x] iOS Capability (Sign in with Apple) 追加指示 <!-- id: 144 -->
    - [x] 依存関係解消 (GoogleSignIn v7対応) <!-- id: 145 -->
    - [x] 画面遷移バグ修正 (GoRouter階層フラット化) <!-- id: 146 -->

- [x] Firestore セキュリティルールの設定 <!-- id: 150 -->
    - [x] `users` コレクション (本人のみ書き込み可) <!-- id: 151 -->
    - [x] `collections` コレクション (本人のみ読み書き可) <!-- id: 152 -->
    - [x] `reports` コレクション (作成のみ可) <!-- id: 153 -->
    - [x] `products` / `strategies` (読み取り専用 / 一部作成可?) <!-- id: 154 -->
