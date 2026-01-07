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
  String remainingTime(int hours, int minutes) {
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
}
