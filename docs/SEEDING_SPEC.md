# 初期データ投入 (Data Seeding) 実装仕様書

## 概要
Firestore環境へ初期データ（Mockデータ）を投入する機能を実装する。
開発者がデバッグモードでアプリを起動し、簡単にデータをリセット・投入できるようにする。

## 実装ファイルの構成
1.  **`lib/data/seeds/initial_data.dart`**
    -   Mockデータ (`initialStrategies`, `initialProducts`) を定数として定義。
    -   `MockStrategyRepository` と `seedFirestoreData` の両方で参照する。

2.  **`lib/utils/seed_firestore.dart`**
    -   `seedFirestoreData()` 関数を実装。
    -   `FirebaseFirestore` インスタンスを取得し、`batch.set()` を用いてデータを一括書き込みする。
    -   実行は `kDebugMode` 時のみに制限。

3.  **`lib/presentation/screens/home_screen.dart`**
    -   AppBarに「データ投入アイコン」を追加（デバッグモードのみ）。
    -   実行時に確認ダイアログを表示し、完了後にスナックバーを表示。
    -   完了後、`ref.invalidate(strategiesProvider)` でリストを更新。

## 使用方法
1.  `flutter run` (Debug Mode) でアプリを起動。
2.  ホーム画面右上の雲アイコン（アップロード）をタップ。
3.  ダイアログで「投入する」を選択。
4.  「データ投入が完了しました」と表示され、Firestoreにデータが反映される。
