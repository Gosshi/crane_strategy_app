# TECH_STACK.md

## Project Overview
クレーンゲームの攻略動画まとめ・共有アプリ。
現場（ゲーセン）で「今の状態」から攻略法を検索できる。

## Tech Stack
- **Framework**: Flutter (Latest Stable)
- **Language**: Dart
- **State Management**: flutter_riverpod (Riverpod Generator推奨)
- **Routing**: go_router
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Video**: youtube_player_flutter
- **Image**: cached_network_image

## Architecture Rules
- **Layered Architecture**:
  - `data/`: Repository Pattern (Firestore操作) & Models (Freezed)
  - `presentation/`: Screens & Widgets (Riverpod ConsumerWidget)
  - `application/`: Business logic / Service
- **Async**: `AsyncValue` でローディング・エラーをハンドリングする。
- **UI**: Material 3 Design。

## Data Model
### strategies (攻略法)
- **id**: string
- **title**: map<string, string> (Ex: `{'ja': '...', 'en': '...'}`)
- **description**: map<string, string> (Ex: `{'ja': '...', 'en': '...'}`)
- **setting_type**: string (橋渡し, 3本爪, etc)
- **thumbnail_url**: string
- **video_id**: string (YouTube ID)

### products (商品)
- **id**: string (JAN/Barcode)
- **name**: string
- **image_url**: string
- **strategy_ids**: list<string> (Reference to strategies)

### posts (ユーザー投稿: Planned)
- **id**: string
- **user_id**: string
- **image_url**: string
- **comment**: string
- **created_at**: timestamp