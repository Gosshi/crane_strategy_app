# UGC 機能拡張仕様: YouTube連携と免責

## データモデル拡張 (Post)
- `youtubeUrl` (String?): YouTube動画URL。

## UI/UX 実装要件
### 投稿画面
- **入力制限**: ドメインチェック (`youtube.com`, `youtu.be`) を必須とする。
- **免責表示**: 以下の文言を入力欄付近に明記する。
  > "投稿する動画リンクは、YouTubeの利用規約および著作権法を遵守したものに限ります。違法なコンテンツは予告なく削除されます。"

### 閲覧画面
- **再生方式**: `youtube_player_flutter` 等を使用。
