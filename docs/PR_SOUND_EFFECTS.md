# 効果音(SE)追加機能

## 概要

ゲーミング体験を向上させるため、スキャン成功時と獲得登録時に効果音を追加しました。

## 変更内容

### 追加パッケージ
- `audioplayers: ^6.1.0` - 効果音再生用

### 追加ファイル
- `lib/data/services/audio_service.dart` - 効果音管理サービス
- `lib/data/providers/audio_service_provider.dart` - Riverpodプロバイダー
- `assets/sounds/scan_success.mp3` - スキャン成功音
- `assets/sounds/acquisition_success.mp3` - 獲得登録成功音

### 変更ファイル
- `pubspec.yaml` - audioplayersパッケージとassetsを追加
- `lib/presentation/screens/scan_result_screen.dart` - 効果音再生機能を統合
- `lib/presentation/screens/account_screen.dart` - 効果音ON/OFF設定を追加
- `ios/Podfile.lock` - iOS依存関係の更新（connectivity_plus用）

## 新機能

### AudioService
- `preloadSounds()` - アプリ起動時に効果音をプリロード（低レイテンシー再生のため）
- `playScanSuccess()` - スキャン成功時の効果音を再生
- `playAcquisitionSuccess()` - 獲得登録時の効果音を再生（紙吹雪演出と同時）
- `setSoundEnabled()` / `isSoundEnabled` - 効果音のON/OFF設定

### アカウント画面の設定
- 効果音ON/OFFを切り替えられるスイッチを追加
- リアルタイムで設定が反映される

## 効果音が再生されるタイミング

1. **スキャン成功時**: 商品がデータベースで見つかった時
2. **獲得登録時**: 「この商品をGETした！」ボタンをタップして登録が完了した時

## 使用方法

### 効果音のON/OFF切替
1. アカウント画面を開く
2. 「設定」セクションの「効果音」スイッチを切り替える

## テスト手順

### 1. 効果音ファイルの配置
以下のファイルを配置してください：
- `/Users/gota/Documents/src/crane_strategy_app/assets/sounds/scan_success.mp3`
- `/Users/gota/Documents/src/crane_strategy_app/assets/sounds/acquisition_success.mp3`

### 2. アプリの実行
```bash
flutter run
```

### 3. スキャン成功音のテスト
1. スキャン画面でバーコードをスキャン
2. 商品が見つかった際に効果音が再生されることを確認

### 4. 獲得登録音のテスト
1. 商品詳細画面で「この商品をGETした！」をタップ
2. 紙吹雪と同時に効果音が再生されることを確認

### 5. 設定のテスト
1. アカウント画面の効果音スイッチをOFFにする
2. 上記のテストを再実行し、効果音が再生されないことを確認
3. スイッチをONに戻し、効果音が再生されることを確認

## 技術詳細

- **音声フォーマット**: mp3（iOSとAndroid両対応）
- **プリロード**: アプリ起動時に`AssetSource`でプリロード
- **レイテンシー**: プリロードにより低レイテンシー再生を実現
- **状態管理**: RiverpodのProviderで管理
