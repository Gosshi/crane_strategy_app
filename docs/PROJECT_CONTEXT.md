# Project Context: クレーンゲーム攻略・共有アプリ

## 1. プロジェクト概要
- **目的**: 日本人・外国人向けに、クレーンゲームの攻略法を共有するアプリ。
- **コア体験**:
  - ゲーセン現場で「今の置き方」や「バーコード」から攻略法を即検索できる。
  - 商品単位ではなく「置き方（橋渡し、末広がり等）」単位で攻略法を体系化。
  - 重心や個別の取り方はユーザー投稿（UGC）で補完する。

## 2. 実装機能要件
1. **攻略法検索**: 置き方カテゴリー（橋渡し、3本爪など）からの検索。
2. **商品スキャン**: バーコード（JANコード）読み取り → 該当商品の攻略・UGCページへ遷移。
3. **多言語対応**: UIおよび攻略タグの多言語化（日・英・中など）。
4. **UGC機能**: ユーザーによる「取れた時の動画/画像」「重心位置」「アーム設定」の投稿。

## 3. Tech Stack
- **Frontend**: Flutter (Latest Stable), Dart
- **State**: flutter_riverpod (Riverpod Generator)
- **Router**: go_router
- **UI**: Material 3 Design
- **Backend**: Firebase (Auth, Firestore, Storage, Functions)
- **Media**: youtube_player_flutter (動画再生), cached_network_image
- **Camera**: mobile_scanner (バーコード読み取り想定)

## 4. Architecture Rules
- **Layered Architecture**: `data` (Repository/Model), `application` (Service), `presentation` (UI)
- **Async Handling**: `AsyncValue` によるローディング・エラー処理の統一。
- **Data Model**: Firestore NoSQL設計（以下参照）。

## 5. 現在のデータモデル設計（Draft）
- **strategies**: 置き方ごとの汎用攻略法（動画付き）。
- **posts**: ユーザー投稿（成功体験、重心情報）。