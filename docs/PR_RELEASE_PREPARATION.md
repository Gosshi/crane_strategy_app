# PR: リリース準備 - 画質改善と機能制限

## 概要

Google Play Storeリリースに向けて、画質改善とポリシー対応のための機能制限を実装しました。

---

## 変更内容

### 1. ヤフオク画像の高画質化

**問題:**
ヤフーショッピングAPIから取得する商品画像の画質が低い

**解決策:**
- 画像サイズパラメータを300px → 600pxに変更
- より鮮明な商品画像を提供

**変更ファイル:**
- [yahoo_shopping_repository.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/data/repositories/yahoo_shopping_repository.dart)

```dart
// Before
'image_size': '300',

// After
'image_size': '600', // 高画質化
```

---

### 2. 画像投稿機能の一時無効化

**理由:**
- 肖像権・著作権リスクへの対応
- ストア審査リスクの軽減

**実装:**
- ImagePickerのimportをコメントアウト
- 画像選択UIを非表示
- 画像アップロード処理を無効化

**変更ファイル:**
- [post_composer_screen.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/presentation/screens/post_composer_screen.dart)

**影響:**
- ユーザーは テキスト + YouTube動画URLのみで投稿可能
- 既存の画像投稿データは維持（表示のみ）

---

### 3. YouTube動画リンク制限

**理由:**
- 不適切なコンテンツへのリンク防止
- ストアポリシー遵守

**実装:**
厳密なドメイン検証を追加：
- `youtube.com`
- `www.youtube.com`
- `youtu.be`
- `www.youtu.be`
- `m.youtube.com`

**変更ファイル:**
- [post_composer_screen.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/presentation/screens/post_composer_screen.dart)

```dart
// Before: 簡易検証
!youtubeUrl.contains('youtube') && !youtubeUrl.contains('youtu.be')

// After: 厳密なドメイン検証
final host = uri.host.toLowerCase();
final isYoutube = host == 'youtube.com' || 
                 host == 'www.youtube.com' ||
                 host == 'youtu.be' ||
                 host == 'www.youtu.be' ||
                 host == 'm.youtube.com';
```

---

## テスト結果

```bash
✅ flutter analyze - No issues found
✅ flutter test - All 15 tests passed
```

---

## リリース準備状況

### 完了項目
- ✅ コア機能実装
- ✅ i18n対応（5言語）
- ✅ 広告統合
- ✅ エラーハンドリング
- ✅ 画質改善
- ✅ ポリシー対応（画像・動画制限）

### 残タスク
- [ ] アプリ署名設定
- [ ] プライバシーポリシー作成
- [ ] ストアリスティング素材
- [ ] 内部テスト（20人、14日間）

---

## 影響範囲

**ユーザー影響:**
- ✅ より鮮明な商品画像
- ⚠️ 投稿時に画像添付不可（YouTube動画のみ）

**開発者影響:**
- なし（将来的に画像投稿を再有効化可能）

---

## 備考

**画像投稿機能について:**
- コードはコメントアウトのみ
- 将来的に再有効化する場合、コメント解除で復活可能
- 肖像権問題が解決すれば再導入を検討

**次のステップ:**
このPRマージ後、リリース準備タスクに着手します。
