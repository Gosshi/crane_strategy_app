# Phase 1: AdMob広告統合

## 概要

Google AdMobを使用した広告収益化機能を実装しました。無料ユーザーに対して、バナー広告、インタースティシャル広告、リワード広告の3種類の広告を表示します。

**実装内容:**
- バナー広告（ホーム画面下部）
- インタースティシャル広告（スキャン3回に1回）
- リワード広告ボタン（24時間プレミアム機能解放）
- テスト広告/本番広告の切り替え機能

---

## 変更ファイル

### 依存関係

#### [MODIFY] [pubspec.yaml](file:///Users/gota/Documents/src/crane_strategy_app/pubspec.yaml)

`google_mobile_ads`パッケージ（v5.3.1）を追加しました。

```yaml
dependencies:
  google_mobile_ads: ^5.0.0
```

---

### 設定ファイル

#### [NEW] [ad_config.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/config/ad_config.dart)

広告ユニットIDを一元管理する設定ファイルを作成しました。

**主な機能:**
- テスト広告IDと本番広告IDの自動切り替え
- プラットフォーム別（iOS/Android）の広告ユニットID管理
- Debug modeでは自動的にテスト広告を使用

**広告ユニットID:**
- バナー広告
- インタースティシャル広告
- リワード広告

> [!NOTE]
> 現在はテスト広告IDを使用しています。本番リリース前に、`TODO`コメントの箇所を実際のAdMob広告ユニットIDに置き換える必要があります。

---

### サービス層

#### [NEW] [ad_manager.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/services/ad_manager.dart)

広告の読み込み、表示、管理を行うサービスクラスを作成しました。

**主な機能:**
- AdMob SDKの初期化
- バナー広告の作成と管理
- インタースティシャル広告の読み込みと表示（頻度管理付き）
  - スキャン: 3回に1回表示
  - 動画視聴: 2回に1回表示（将来実装予定）
- リワード広告の読み込みと表示
- 広告表示カウンターの管理

**実装されたメソッド:**
```dart
// 初期化
Future<void> initialize()

// バナー広告作成
BannerAd createBannerAd()

// インタースティシャル広告
Future<void> loadInterstitialAd()
Future<void> showInterstitialAdIfReady({required String type})

// リワード広告
Future<void> loadRewardedAd()
Future<RewardItem?> showRewardedAd()
```

---

### アプリケーション層

#### [MODIFY] [main.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/main.dart)

アプリ起動時にAdMob SDKを初期化するように修正しました。

**変更内容:**
```dart
void main() async {
  // ... Firebase初期化
  
  // AdMob初期化を追加
  try {
    await AdManager().initialize();
  } catch (e) {
    debugPrint('AdManager initialize error (ignored): $e');
  }
  
  runApp(...);
}
```

---

### プレゼンテーション層

#### [MODIFY] [home_screen.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/presentation/screens/home_screen.dart)

ホーム画面の下部にバナー広告を追加しました。

**変更内容:**
- バナー広告のState管理追加
- `initState`でバナー広告を読み込み
- 画面下部にAdWidgetを配置
- `dispose`で広告リソースを解放

**表示位置:**
```
+------------------+
|   App Bar        |
+------------------+
|   検索バー        |
+------------------+
|                  |
|   攻略法リスト    |
|   (Expanded)     |
|                  |
+------------------+
|  バナー広告(50px) | ← NEW
+------------------+
```

> [!NOTE]
> TODO: プレミアムユーザーの場合は広告を非表示にする処理を追加（Phase 2で実装予定）

#### [MODIFY] [scan_result_screen.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/presentation/screens/scan_result_screen.dart)

スキャン結果画面で商品情報読み込み完了後にインタースティシャル広告を表示するように修正しました。

**変更内容:**
```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  ref.read(audioServiceProvider).playScanSuccess();
  // インタースティシャル広告を表示（3回に1回）
  AdManager().showInterstitialAdIfReady(type: 'scan');
});
```

**表示タイミング:**
- スキャン3回に1回、自動的にフルスクリーン広告を表示
- 広告が準備できていない場合はスキップ
- 広告終了後、自動的に次の広告を事前読み込み

#### [NEW] [reward_ad_button.dart](file:///Users/gota/Documents/src/crane_strategy_app/lib/presentation/widgets/reward_ad_button.dart)

リワード広告視聴ボタンのウィジェットを作成しました。

**主な機能:**
- リワード広告の表示
- 広告視聴完了後のコールバック
- 24時間プレミアム機能解放のメッセージ表示
- エラーハンドリング

**使用方法:**
```dart
RewardAdButton(
  title: '広告を見て限定攻略法を解放',
  onRewarded: () {
    // 24時間プレミアム機能を有効化する処理
  },
)
```

---

## テスト結果

### Flutter Analyze
```bash
$ flutter analyze
Analyzing crane_strategy_app...
No issues found! (ran in 4.7s)
```

**結果:** ✅ lint警告なし

### ユニットテスト
```bash
$ flutter test
00:02 +15: All tests passed!
```

**結果:** ✅ 全15テストがパス

**広告ログの出力:**
```
🐛 [AdManager] Creating banner ad
🐛 [AdManager] Scan count: 1
🐛 [AdManager] Scan frequency not met, skipping ad
🐛 [AdManager] Scan count: 2
🐛 [AdManager] Scan frequency not met, skipping ad
```

広告頻度管理が正しく動作していることを確認しました。

---

## 技術的な詳細

### 広告の種類と配置

| 広告タイプ | 配置場所 | 表示頻度 | eCPM予想 |
|-----------|---------|---------|----------|
| バナー広告 | ホーム画面下部 | 常時表示 | ¥100-300 |
| インタースティシャル | スキャン結果表示後 | 3回に1回 | ¥1,000-3,000 |
| リワード広告 | ユーザーが任意で視聴 | - | ¥2,000-5,000 |

### テスト広告と本番広告の切り替え

```dart
// AdConfig.dart
static const bool isTestMode = kDebugMode;
```

- **Debug mode**: 自動的にテスト広告IDを使用
- **Release mode**: 本番広告IDを使用

この仕組みにより、開発中は常にテスト広告が表示され、AdMobアカウントのペナルティを防ぎます。

### 広告表示頻度の管理

```dart
// AdManager.dart
static const int _scanAdFrequency = 3; // スキャン3回に1回
static const int _videoAdFrequency = 2; // 動画視聴2回に1回
```

カウンターで表示頻度を管理し、ユーザー体験を損なわないように調整しています。

---

## 次のステップ

### AdMobアカウントの設定（本番リリース前）

1. **AdMobアカウント作成**
   - https://admob.google.com/ でアカウント作成

2. **アプリ登録**
   - iOSアプリを登録
   - Androidアプリを登録

3. **広告ユニット作成**
   - バナー広告ユニットIDを取得
   - インタースティシャル広告ユニットIDを取得
   - リワード広告ユニットIDを取得

4. **Info.plistとAndroidManifest.xmlの更新**
   
   iOS (`ios/Runner/Info.plist`):
   ```xml
   <key>GADApplicationIdentifier</key>
   <string>ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY</string>
   ```

   Android (`android/app/src/main/AndroidManifest.xml`):
   ```xml
   <meta-data
       android:name="com.google.android.gms.ads.APPLICATION_ID"
       android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
   ```

5. **ad_config.dartの更新**
   - TODOコメントの箇所を実際の広告ユニットIDに置き換え

### Phase 2の準備

- [ ] RevenueCatアカウント作成
- [ ] App Store Connect / Google Play Consoleでのサブスクリプション商品登録
- [ ] プレミアムユーザー判定機能の実装
- [ ] プレミアムユーザーの広告非表示機能

---

## 備考

- テスト広告IDは Google公式のものを使用しています
- 広告の読み込みエラーはログに出力して、アプリの動作には影響しないようにしています
- 広告リソースは`dispose`で適切に解放しています
- logger パッケージを使用してデバッグログを出力しています
