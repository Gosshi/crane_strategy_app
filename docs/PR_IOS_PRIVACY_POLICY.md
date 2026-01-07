# PR: iOSリリース準備 - プライバシーポリシー追加

## 概要

iOS App Store申請に必要なプライバシーポリシーを作成しました。

---

## 変更内容

### プライバシーポリシー作成

**ファイル:** [docs/privacy-policy.html](file:///Users/gota/Documents/src/crane_strategy_app/docs/privacy-policy.html)

**記載内容:**
- Firebase Analytics、Authentication、Firestore、Storageの使用開示
- Google AdMobの広告配信開示
- Yahoo! JAPAN ショッピングAPIの使用開示
- データ収集項目と使用目的
- ユーザー権利（データ削除、開示請求等）
- データ保持期間
- セキュリティ対策
- 子供のプライバシー保護
- お問い合わせ先

---

## 公開予定URL

GitHub Pagesで公開:
```
https://gosshi.github.io/crane_strategy_app/privacy-policy.html
```

**GitHub Pages設定（マージ後）:**
1. リポジトリ Settings → Pages
2. Source: Deploy from a branch
3. Branch: main, Folder: /docs
4. Save

---

## App Store Connect設定

このURLを以下で使用:
- App情報 → プライバシーポリシーURL
- App Store Connect → アプリ詳細

---

## 対応完了事項

### iOS App Store準備
- ✅ Bundle ID確認: `io.github.gosshi.craneStrategyApp`
- ✅ プライバシーポリシー作成
- [ ] GitHub Pages公開（PRマージ後）
- [ ] スクリーンショット作成
- [ ] App Store Connect設定
- [ ] TestFlightビルド

---

## 次のステップ

1. このPRをマージ
2. GitHub Pages設定
3. スクリーンショット撮影開始
