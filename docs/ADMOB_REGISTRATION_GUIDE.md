# AdMob登録ガイド - クレナビ

## アプリ情報

### 基本情報

| 項目 | 値 |
|------|-----|
| **アプリ名** | クレナビ |
| **サブタイトル** | UFOキャッチャー攻略＆コレクション |
| **英語名** | Crenavi |
| **iOS Bundle ID** | `io.github.gosshi.craneStrategyApp` |
| **Android Package Name** | `io.github.gosshi.crane_strategy_app` |

---

## AdMob登録手順

### 1. AdMobアカウント作成

1. https://admob.google.com/ にアクセス
2. Googleアカウントでログイン
3. AdMobアカウントを作成（初回のみ）

### 2. iOSアプリの登録

1. **「アプリ」→「アプリを追加」をクリック**

2. **プラットフォーム選択**
   - iOS を選択

3. **App Storeへの公開状況**
   - 「いいえ」を選択

4. **アプリ情報入力**
   ```
   アプリ名: クレナビ
   Bundle ID: io.github.gosshi.craneStrategyApp
   ```

5. **アプリを作成**
   - **App ID（アプリID）をメモしてください**
   - 形式: `ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY`

### 3. iOS用広告ユニット作成

以下の3つの広告ユニットを作成してください。

#### 3-1. バナー広告
1. 「広告ユニット」→「広告ユニットを作成」
2. 広告フォーマット: **バナー**
3. 広告ユニット名: `iOS_Banner_Home`
4. 作成後、**広告ユニットIDをメモ**
   - 形式: `ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY`

#### 3-2. インタースティシャル広告
1. 「広告ユニット」→「広告ユニットを作成」
2. 広告フォーマット: **インタースティシャル**
3. 広告ユニット名: `iOS_Interstitial_Scan`
4. 作成後、**広告ユニットIDをメモ**

#### 3-3. リワード広告
1. 「広告ユニット」→「広告ユニットを作成」
2. 広告フォーマット: **リワード**
3. 広告ユニット名: `iOS_Rewarded_Premium`
4. リワード設定:
   - リワードアイテム: `プレミアム機能`
   - リワード金額: `1`
5. 作成後、**広告ユニットIDをメモ**

### 4. Androidアプリの登録

1. **「アプリ」→「アプリを追加」をクリック**

2. **プラットフォーム選択**
   - Android を選択

3. **Google Playへの公開状況**
   - 「いいえ」を選択

4. **アプリ情報入力**
   ```
   アプリ名: クレナビ
   Package Name: io.github.gosshi.crane_strategy_app
   ```

5. **アプリを作成**
   - **App ID（アプリID）をメモしてください**

### 5. Android用広告ユニット作成

iOS と同様に3つの広告ユニットを作成してください。

- `Android_Banner_Home`
- `Android_Interstitial_Scan`
- `Android_Rewarded_Premium`

---

## 取得した情報の記録

以下の表に、取得した広告IDを記録してください。

### iOS

| 種類 | 広告ユニットID |
|------|---------------|
| App ID | ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY |
| バナー広告 | ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY |
| インタースティシャル広告 | ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY |
| リワード広告 | ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY |

### Android

| 種類 | 広告ユニットID |
|------|---------------|
| App ID | ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY |
| バナー広告 | ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY |
| インタースティシャル広告 | ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY |
| リワード広告 | ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY |

---

## コードへの適用

### 1. Info.plist の更新（iOS）

`ios/Runner/Info.plist` に以下を追加：

```xml
<key>GADApplicationIdentifier</key>
<string>【iOSのApp IDを記入】</string>
```

### 2. AndroidManifest.xml の更新（Android）

`android/app/src/main/AndroidManifest.xml` の `<application>` タグ内に追加：

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="【AndroidのApp IDを記入】"/>
```

### 3. ad_config.dart の更新

`lib/config/ad_config.dart` の本番広告IDを更新：

```dart
// iOS本番広告ユニットID
static const String iosBannerAdUnitId = isTestMode
    ? 'ca-app-pub-3940256099942544/2934735716'
    : '【iOSバナー広告IDを記入】';

static const String iosInterstitialAdUnitId = isTestMode
    ? 'ca-app-pub-3940256099942544/4411468910'
    : '【iOSインタースティシャル広告IDを記入】';

static const String iosRewardedAdUnitId = isTestMode
    ? 'ca-app-pub-3940256099942544/1712485313'
    : '【iOSリワード広告IDを記入】';

// Android本番広告ユニットID
static const String androidBannerAdUnitId = isTestMode
    ? 'ca-app-pub-3940256099942544/6300978111'
    : '【Androidバナー広告IDを記入】';

static const String androidInterstitialAdUnitId = isTestMode
    ? 'ca-app-pub-3940256099942544/1033173712'
    : '【Androidインタースティシャル広告IDを記入】';

static const String androidRewardedAdUnitId = isTestMode
    ? 'ca-app-pub-3940256099942544/5224354917'
    : '【Androidリワード広告IDを記入】';
```

---

## チェックリスト

- [ ] AdMobアカウント作成
- [ ] iOSアプリ登録
- [ ] iOS App ID取得
- [ ] iOSバナー広告ユニット作成
- [ ] iOSインタースティシャル広告ユニット作成
- [ ] iOSリワード広告ユニット作成
- [ ] Androidアプリ登録
- [ ] Android App ID取得
- [ ] Androidバナー広告ユニット作成
- [ ] Androidインタースティシャル広告ユニット作成
- [ ] Androidリワード広告ユニット作成
- [ ] Info.plist更新
- [ ] AndroidManifest.xml更新
- [ ] ad_config.dart更新
- [ ] テストビルド確認

---

## トラブルシューティング

### 広告が表示されない

1. **Debug modeで実行していますか？**
   - Debug modeではテスト広告が表示されます

2. **広告IDは正しいですか？**
   - `ad_config.dart`の設定を確認

3. **ネットワーク接続はありますか？**
   - 広告の読み込みにはインターネット接続が必要

### 「Invalid Ad Unit ID」エラー

- 広告ユニットIDが間違っています
- コピー&ペーストのミスがないか確認してください

---

## 次のステップ

AdMob登録が完了したら：

1. 本番広告IDを設定
2. Release modeでビルド
3. 実機で広告表示を確認
4. App Store Connect / Google Play Consoleに提出

**お疲れ様でした！** 🎉
