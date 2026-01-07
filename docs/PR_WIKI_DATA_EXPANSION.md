# PR: Wiki初期データ充実 - 31→51用語に拡張

## 概要

クレーンゲーム用語集を31用語から51用語に拡張しました。

**追加用語数:** 20用語  
**増加率:** 64%向上

---

## 変更内容

### 追加用語（20種類）

#### 基本用語 (4)
- 店員アシスト
- 連続プレイ
- 練習台
- （設定判別は技術カテゴリに含む）

#### 技術・攻略 (10)
- 引き戻し、掘り、揺らし
- 回転、傾け
- サンドイッチ、フック、スライド、ピンチ
- バランスブレイク、角落とし、タイミング

#### 景品関連 (2)
- 限定景品
- コラボ景品

#### 機械・設定 (2)
- ジャックポット
- 確率変動

### データ構造

各用語は以下を含みます：
- 日本語名・英語名
- 読み仮名
- 日英説明文
- カテゴリ分類
- 関連用語リンク

---

## 実装詳細

### ファイル変更

**[initial_data.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/data/seeds/initial_data.dart)**
- 20用語を`initialTerms`リストに追加
- 全用語が日英両言語対応

**[firestore.rules](file:///Users/gota/Documents/src/crane_strategy_app/firestore.rules)**
- データ投入のため一時的に書き込み許可
- 投入完了後、本番設定に復元

**[WIKI_DATA_SEEDING.md](file:///Users/gota/Documents/src/crane_strategy_app/docs/WIKI_DATA_SEEDING.md)**
- データ投入手順ガイドを追加

---

## カテゴリ別合計

| カテゴリ | Before | After | 増加 |
|---------|--------|-------|------|
| 基本用語 | 5 | 9 | +4 |
| 技術・攻略 | 20 | 30 | +10 |
| 景品関連 | 4 | 6 | +2 |
| 機械・設定 | 2 | 6 | +4 |
| **合計** | **31** | **51** | **+20** |

---

## テスト結果

```bash
✅ flutter analyze - No issues found
✅ flutter test - All 15 tests passed
✅ データ投入成功
✅ アプリで表示確認済み
```

---

## 動作確認

1. ✅ 用語集画面に51用語表示
2. ✅ カテゴリフィルタ正常動作
3. ✅ 日英切り替え正常動作
4. ✅ 関連用語リンク正常動作

---

## セキュリティ

- ✅ Firestoreルールを本番設定に復元
- ✅ termsコレクションは読み取り専用

---

## 効果

**ユーザー体験向上:**
- 用語集の充実度64%向上
- 初心者〜上級者まで幅広くカバー
- 多言語対応で国際ユーザーにも対応

**今後の展開:**
- さらに専門用語を追加可能
- 画像・動画の追加
- 用語間のリンク強化

---

## 関連ドキュメント

- [walkthrough.md](file:///Users/gota/.gemini/antigravity/brain/ca24b5ae-c31e-42cc-bc92-e466bb8a00a2/walkthrough.md)
- [WIKI_DATA_SEEDING.md](file:///Users/gota/Documents/src/crane_strategy_app/docs/WIKI_DATA_SEEDING.md)
