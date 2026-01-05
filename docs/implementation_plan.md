# 実装計画: YouTube動画リンクによる攻略コンテンツ拡充

## 目的
ユーザーがYouTubeの攻略動画URLを投稿し、アプリ内で共有できる機能を実装します。
これにより、自社で動画コンテンツを持たなくても、ユーザー間の集合知（UGC）によって攻略情報が充実するエコシステムを構築します。著作権リスクを回避しつつ、コンテンツ不足を解消することを目的とします。

## 注意事項 (User Review Required)
> [!NOTE]
> **YouTubeリンク限定**
> 安全性と埋め込みの容易さ（`url_launcher` や将来的なプレイヤー埋め込み）のため、当面はYouTubeのURLのみをサポート対象とします。

## 変更内容 (Proposed Changes)

### データモデル
#### [MODIFY] [post.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/data/models/post.dart)
- `final String? youtubeUrl;` フィールドを追加。
- `fromMap` および `toMap` メソッドを更新し、Firestoreとの読み書きに対応。

### UIコンポーネント
#### [MODIFY] [post_composer_screen.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/presentation/screens/post_composer_screen.dart)
- YouTube URLを入力するための `TextField` を追加。
- クリップボードからの貼り付けボタンを配置し、スマホでの入力負荷を軽減。
- 簡易的なバリデーション（URL形式チェック）を追加。

#### [MODIFY] [scan_result_screen.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/presentation/screens/scan_result_screen.dart)
- 投稿リストのアイテム表示を更新。
- `youtubeUrl` が存在する場合、「動画を見る (YouTube)」ボタンを表示。
- ボタンタップ時に `url_launcher` を使用して外部アプリ（またはブラウザ）で動画を開く処理を実装。

## 検証計画
### 手動検証
- **投稿作成**: 有効なYouTube URLを含む投稿を作成し、エラーなく保存されるか確認。
- **表示確認**: 投稿リストに「動画を見る」ボタンが表示されるか確認。
- **動作確認**: ボタンをタップし、YouTubeアプリ（またはブラウザ）が正常に起動するか確認。
