// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'クレナビ';

  @override
  String get homeTitle => 'クレナビ';

  @override
  String get scanButton => 'スキャン';

  @override
  String get collectionTitle => '獲得履歴';

  @override
  String get accountTitle => 'アカウント';

  @override
  String get glossaryTitle => '用語集';

  @override
  String get premiumFeatures => 'プレミアム機能';

  @override
  String get watchAdFor24h => '広告を見て24時間プレミアム体験';

  @override
  String get premiumUnlocked => '✨ 24時間プレミアム機能が解放されました！';

  @override
  String get noAds => '広告なし';

  @override
  String get searchPlaceholder => '商品名やタグで検索 (例: フィギュア)';

  @override
  String get guestUser => 'ゲストユーザー';

  @override
  String get accountSettings => 'アカウント設定';

  @override
  String get linkAccount => 'アカウント連携';

  @override
  String get linkWithGoogle => 'Googleアカウントと連携';

  @override
  String get signInWithApple => 'Appleでサインイン';

  @override
  String get accountLinked => 'アカウント連携済み';

  @override
  String get dataIsSafe => 'データは安全に保存されています。';

  @override
  String get settings => '設定';

  @override
  String get soundEffects => '効果音';

  @override
  String get playSoundOnScan => 'スキャンや獲得時の効果音を再生';

  @override
  String get premiumMember => 'プレミアム会員';

  @override
  String remainingTime(Object hours, Object minutes) {
    return '残り時間: $hours時間$minutes分';
  }

  @override
  String get subscriptionActive => 'サブスクリプション有効';

  @override
  String get limited24Hours => '24時間解放中';

  @override
  String get premiumBenefits => 'プレミアム特典:';

  @override
  String get exclusiveBadge => '限定バッジ（Phase 2で実装予定）';

  @override
  String get experiencePremiumFor24h => '広告を見て24時間プレミアム機能を体験！';

  @override
  String get allAdsHidden => '全ての広告が非表示';

  @override
  String get loading => '読み込み中...';

  @override
  String get errorOccurred => 'エラーが発生しました';

  @override
  String get collectionScreenTitle => '獲得コレクション';

  @override
  String get gridView => 'グリッド表示';

  @override
  String get listView => 'リスト表示';

  @override
  String get noPrizes => 'まだ獲得した景品はありません';

  @override
  String error(Object error) {
    return 'エラー: $error';
  }

  @override
  String get acquiredDate => '獲得日';

  @override
  String get note => 'メモ';

  @override
  String get shopName => '店舗';

  @override
  String get shareAction => '自慢する (シェア)';

  @override
  String get searchTerms => '用語を検索...';

  @override
  String get allCategory => 'すべて';

  @override
  String get noTermsFound => '該当する用語が見つかりません';

  @override
  String get editPost => '投稿を編集';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get categoryBasic => '基本用語';

  @override
  String get categoryTechnique => '技術・攻略';

  @override
  String get categoryPrize => '景品関連';

  @override
  String get categoryMachine => '機械・設定';

  @override
  String get scanResult => 'スキャン結果';

  @override
  String get searching => '商品を検索中...';

  @override
  String get postStrategy => '攻略を投稿';

  @override
  String get loginRequired => 'ログインが必要です (認証に失敗しました)';

  @override
  String gotIt(Object name) {
    return '$name をGETしました！';
  }

  @override
  String get shareProduct => 'この商品を共有';

  @override
  String get editProduct => '編集する';

  @override
  String get gotThisProduct => 'この商品をGETした！';

  @override
  String get noRelatedStrategies => '関連する攻略法はまだありません';

  @override
  String loadStrategyError(Object error) {
    return '攻略法の読み込みエラー: $error';
  }

  @override
  String get noPostsYet => 'No posts yet.\\nBe the first to share tips!';

  @override
  String get cannotOpenVideo => '動画を開けませんでした';

  @override
  String get watchVideoYouTube => '動画を見る (YouTube)';

  @override
  String get yahooSearching => 'Yahoo!ショッピングから情報を検索中...';

  @override
  String get registerWithThis => 'この情報を使って登録';

  @override
  String get returnHome => 'ホームに戻る';

  @override
  String get manualRegister => '手動で登録する';

  @override
  String get notFound => '見つかりませんでした';

  @override
  String get noStrategiesYet => '攻略法がまだありません';

  @override
  String get linkGoogleAccount => 'データを永続化するために、\\nGoogleアカウントと連携しましょう。';

  @override
  String get linkSuccess => '連携に成功しました！';

  @override
  String linkError(Object error) {
    return '連携エラー: $error';
  }

  @override
  String get dataSeeding => 'データ投入';

  @override
  String get cancel => 'キャンセル';

  @override
  String get seed => '投入する';

  @override
  String get seedSuccess => 'データ投入が完了しました';

  @override
  String get productNameRequired => '商品名を入力してください';

  @override
  String get categoryRequired => 'カテゴリを少なくとも1つ選択してください';

  @override
  String registerError(Object error) {
    return '登録エラー: $error';
  }

  @override
  String get productRegistration => '商品登録';

  @override
  String barcode(Object barcode) {
    return 'バーコード: $barcode';
  }

  @override
  String get addToCollection => '登録と同時に「獲得コレクション」にも追加されます';

  @override
  String get dangerZone => '危険な操作';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get deleteAccountDescription => 'アカウントを完全に削除します。この操作は取り消せません。';

  @override
  String get deleteAccountTitle => 'アカウント削除の確認';

  @override
  String get deleteAccountWarning =>
      'この操作を行うと、アカウントと関連するすべてのデータが完全に削除されます。この操作は取り消すことができません。';

  @override
  String get deleteAccountConfirm => '削除する';

  @override
  String get deleteAccountSuccess => 'アカウントが削除されました';

  @override
  String deleteAccountError(String error) {
    return 'アカウント削除エラー: $error';
  }
}
