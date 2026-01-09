# 実装タスクリスト (Legal & Tech)

## Phase 0: コンプライアンス基盤整備
- [ ] ドキュメント作成: `docs/CONTENT_STRATEGY_AND_COPYRIGHT.md` 等の整備。
- [ ] 既存運用ガイドの廃止 (`_DEPRECATED_` 付与)。

## Phase 1: UGC投稿機能 (Legal Safe)
- [ ] `Post` モデル確認・修正。
- [ ] 投稿画面: URLバリデーション実装。
- [ ] 投稿画面: **免責注意事項UIの実装** (必須)。
- [ ] リスト画面: 正規プレイヤーによる再生実装。

## Phase 2: 図解コンテンツ (Visual Strategy)
- [ ] `StrategyDiagram` Widgetの基盤作成。
- [ ] `BridgePainter` の描画ロジック実装。
- [ ] 詳細画面での表示分岐ロジック実装。

## Phase 3: データクリーンアップ
- [ ] 既存 `Strategy` データから、**「自社・公式・公認」以外**のURLを除外する。
