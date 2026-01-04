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

## Data Model (Draft)
### strategies (攻略法)
- id: string
- title: string
- setting_type: string (橋渡し, 3本爪, etc)
- state_tag: string (初期位置, 縦ハメ, 横ハメ, 詰み)
- video_url: string (YouTube ID)
- difficulty: number (1-5)

### posts (ユーザー投稿)
- id: string
- user_id: string
- image_url: string
- comment: string
- created_at: timestamp