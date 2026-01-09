# iOS証明書とプロビジョニング設定手順

## 問題
Xcodeの自動署名が「デバイスが登録されていない」エラーで失敗しています。

## 解決方法：手動署名設定

### ステップ1: Apple Developer Portalで設定

**URL:** https://developer.apple.com/account/resources/certificates/list

#### 1.1 App ID確認
1. Identifiers → App IDs
2. 既に `io.github.gosshi.craneStrategyApp` が存在するか確認
3. なければ作成：
   - Description: Crane Strategy App
   - Bundle ID: io.github.gosshi.craneStrategyApp
   - Capabilities: Push Notifications等、必要なものにチェック

#### 1.2 配布用証明書作成
1. Certificates → + ボタン
2. **Apple Distribution** を選択
3. Continue
4. CSR（証明書署名要求）をMacで作成：
   - キーチェーンアクセス.app を開く
   - メニュー → 証明書アシスタント → 認証局に証明書を要求
   - メールアドレス入力
   - 「ディスクに保存」選択
   - CertificateSigningRequest.certSigningRequest 保存
5. ブラウザに戻り、CSRをアップロード
6. ダウンロード → ダブルクリックでインストール

#### 1.3 Provisioning Profile作成
1. Profiles → + ボタン
2. **App Store** を選択
3. App ID: io.github.gosshi.craneStrategyApp 選択
4. Certificate: 先ほど作成した証明書を選択
5. Profile名: Crane Strategy App Distribution
6. Generate → ダウンロード

---

### ステップ2: Xcodeで手動署名に切り替え

1. Xcode → Runner → Signing & Capabilities
2. **Automatically manage signing のチェックを外す**
3. Release タブ選択
4. Provisioning Profile: ダウンロードしたプロファイルを選択
5. Signing Certificate: Apple Distribution を選択

---

### ステップ3: ビルド実行

```bash
flutter build ipa --release
```

または

```
Xcode: Product → Archive
```

---

## より簡単な代替方法：シミュレーター用ダミーデバイス登録

Apple Developer Portal → Devices → + ボタン

1. Device Name: Dummy Device
2. UDID: 任意の40桁の英数字（例: 00000000000000000000000000000000000000000）

これで自動署名が通る可能性があります（実機テスト用ではないため）。

---

## 参考リンク
- Apple Developer Portal: https://developer.apple.com/account
- 証明書とプロファイル: https://developer.apple.com/account/resources/certificates/list
