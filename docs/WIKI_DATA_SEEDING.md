# Wiki用語データ投入ガイド

## 概要

`initial_data.dart`に追加した51用語をFirestoreに投入する手順です。

---

## 方法1: アプリ内のデータ投入機能を使用（推奨）

### 手順

1. **アプリを起動**
   ```bash
   flutter run
   ```

2. **ホーム画面のメニューから「データ投入」を選択**
   - 右上のメニューアイコンをタップ
   - 「データ投入」オプションを選択

3. **確認ダイアログで「投入する」をタップ**
   - 用語データがFirestoreに自動投入されます
   - 完了メッセージが表示されます

### メリット
- ✅ 簡単・安全
- ✅ UIから実行可能
- ✅ エラーハンドリング済み

---

## 方法2: Firebase Consoleから手動投入

### 手順

1. **Firebase Consoleにアクセス**
   - https://console.firebase.google.com/

2. **Firestoreデータベースを開く**
   - プロジェクトを選択
   - 左メニューから「Firestore Database」を選択

3. **`terms`コレクションを作成/確認**

4. **各用語を手動で追加**
   - ドキュメントIDとフィールドを設定

### メリット
- ✅ 細かい制御が可能
- ✅ 個別編集が可能

### デメリット
- ⚠️ 手間がかかる（51用語）
- ⚠️ ミスの可能性

---

## 方法3: スクリプトで投入（開発者向け）

現在`seed_firestore.dart`にtermsの投入処理が既に実装されています：

```dart
// lib/utils/seed_firestore.dart
Future<void> seedFirestore() async {
  final db = FirebaseFirestore.instance;
  
  // Terms投入
  for (final term in initialTerms) {
    await db.collection('terms').doc(term.id).set(term.toMap());
  }
}
```

---

## 確認方法

### 1. アプリで確認
- 用語集画面を開く
- 51用語が表示されることを確認
- カテゴリフィルタが正しく動作することを確認

### 2. Firebase Consoleで確認
- `terms`コレクションに51ドキュメントがあることを確認

---

## トラブルシューティング

### エラー: 権限がない
**原因:** Firestoreルールで書き込み権限がない  
**解決:** 一時的にルールを緩和するか、認証済みユーザーで実行

### エラー: データが表示されない
**原因:** Firestoreルールの読み取り権限  
**解決:** ルールを確認、`allow read: if true`を確認

---

## おすすめ手順

1. ✅ **方法1（アプリ内投入）を使用**
2. ✅ **Firebase Consoleで確認**
3. ✅ **アプリで動作確認**

これで51用語がユーザーに提供されます！
