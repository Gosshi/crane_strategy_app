// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '抓娃娃助手';

  @override
  String get homeTitle => '抓娃娃助手';

  @override
  String get scanButton => '扫描';

  @override
  String get collectionTitle => '我的收藏';

  @override
  String get accountTitle => '账户';

  @override
  String get glossaryTitle => '抓娃娃指南';

  @override
  String get premiumFeatures => '高级功能';

  @override
  String get watchAdFor24h => '观看广告获得24小时高级会员';

  @override
  String get premiumUnlocked => '✨ 高级会员已解锁24小时！';

  @override
  String get noAds => '无广告';

  @override
  String get searchPlaceholder => '按名称或标签搜索（例如：手办）';

  @override
  String get guestUser => '游客用户';

  @override
  String get accountSettings => '账户设置';

  @override
  String get linkAccount => '账户关联';

  @override
  String get linkWithGoogle => '关联Google账户';

  @override
  String get signInWithApple => '使用Apple登录';

  @override
  String get accountLinked => '账户已关联';

  @override
  String get dataIsSafe => '您的数据已安全存储。';

  @override
  String get settings => '设置';

  @override
  String get soundEffects => '音效';

  @override
  String get playSoundOnScan => '扫描和获奖时播放音效';

  @override
  String get premiumMember => '高级会员';

  @override
  String remainingTime(Object hours, Object minutes) {
    return '剩余时间：$hours小时$minutes分钟';
  }

  @override
  String get subscriptionActive => '订阅有效';

  @override
  String get limited24Hours => '24小时解锁中';

  @override
  String get premiumBenefits => '高级特权：';

  @override
  String get exclusiveBadge => '专属徽章（Phase 2）';

  @override
  String get experiencePremiumFor24h => '观看广告体验24小时高级功能！';

  @override
  String get allAdsHidden => '所有广告已隐藏';

  @override
  String get loading => '加载中...';

  @override
  String get errorOccurred => '发生错误';

  @override
  String get collectionScreenTitle => 'My Collection';

  @override
  String get gridView => 'Grid View';

  @override
  String get listView => 'List View';

  @override
  String get noPrizes => 'No prizes collected yet';

  @override
  String error(Object error) {
    return 'Error: $error';
  }

  @override
  String get acquiredDate => 'Acquired';

  @override
  String get note => 'Note';

  @override
  String get shopName => 'Shop';

  @override
  String get shareAction => 'Share (Brag)';

  @override
  String get searchTerms => 'Search terms...';

  @override
  String get allCategory => 'All';

  @override
  String get noTermsFound => 'No matching terms found';

  @override
  String get editPost => 'Edit Post';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get categoryBasic => 'Basic Terms';

  @override
  String get categoryTechnique => 'Techniques';

  @override
  String get categoryPrize => 'Prizes';

  @override
  String get categoryMachine => 'Machine/Settings';

  @override
  String get scanResult => 'Scan Result';

  @override
  String get searching => 'Searching...';

  @override
  String get postStrategy => 'Post Strategy';

  @override
  String get loginRequired => 'Login required (authentication failed)';

  @override
  String gotIt(Object name) {
    return 'Got $name!';
  }

  @override
  String get shareProduct => 'Share this product';

  @override
  String get editProduct => 'Edit';

  @override
  String get gotThisProduct => 'Got this product!';

  @override
  String get noRelatedStrategies => 'No related strategies yet';

  @override
  String loadStrategyError(Object error) {
    return 'Error loading strategies: $error';
  }

  @override
  String get noPostsYet => 'No posts yet.\\nBe the first to share tips!';

  @override
  String get cannotOpenVideo => 'Could not open video';

  @override
  String get watchVideoYouTube => 'Watch on YouTube';

  @override
  String get yahooSearching => 'Searching Yahoo! Shopping...';

  @override
  String get registerWithThis => 'Register with this info';

  @override
  String get returnHome => 'Return Home';

  @override
  String get manualRegister => 'Register Manually';

  @override
  String get notFound => 'Not found';

  @override
  String get noStrategiesYet => 'No strategies yet';

  @override
  String get linkGoogleAccount =>
      'Link your data permanently\\nwith your Google account.';

  @override
  String get linkSuccess => 'Successfully linked!';

  @override
  String linkError(Object error) {
    return 'Link error: $error';
  }

  @override
  String get dataSeeding => 'Data Seeding';

  @override
  String get cancel => 'Cancel';

  @override
  String get seed => 'Seed';

  @override
  String get seedSuccess => 'Data seeding completed';

  @override
  String get productNameRequired => 'Please enter product name';

  @override
  String get categoryRequired => 'Please select at least one category';

  @override
  String registerError(Object error) {
    return 'Registration error: $error';
  }

  @override
  String get productRegistration => 'Product Registration';

  @override
  String barcode(Object barcode) {
    return 'Barcode: $barcode';
  }

  @override
  String get addToCollection =>
      'Also add to \"My Collection\" upon registration';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '夾娃娃助手';

  @override
  String get homeTitle => '夾娃娃助手';

  @override
  String get scanButton => '掃描';

  @override
  String get collectionTitle => '我的收藏';

  @override
  String get accountTitle => '帳戶';

  @override
  String get glossaryTitle => '夾娃娃指南';

  @override
  String get premiumFeatures => '高級功能';

  @override
  String get watchAdFor24h => '觀看廣告獲得24小時高級會員';

  @override
  String get premiumUnlocked => '✨ 高級會員已解鎖24小時！';

  @override
  String get noAds => '無廣告';

  @override
  String get searchPlaceholder => '按名稱或標籤搜尋（例如：公仔）';

  @override
  String get guestUser => '訪客用戶';

  @override
  String get accountSettings => '帳戶設定';

  @override
  String get linkAccount => '帳戶關聯';

  @override
  String get linkWithGoogle => '關聯Google帳戶';

  @override
  String get signInWithApple => '使用Apple登入';

  @override
  String get accountLinked => '帳戶已關聯';

  @override
  String get dataIsSafe => '您的資料已安全儲存。';

  @override
  String get settings => '設定';

  @override
  String get soundEffects => '音效';

  @override
  String get playSoundOnScan => '掃描和獲獎時播放音效';

  @override
  String get premiumMember => '高級會員';

  @override
  String remainingTime(Object hours, Object minutes) {
    return '剩餘時間：$hours小時$minutes分鐘';
  }

  @override
  String get subscriptionActive => '訂閱有效';

  @override
  String get limited24Hours => '24小時解鎖中';

  @override
  String get premiumBenefits => '高級特權：';

  @override
  String get exclusiveBadge => '專屬徽章（Phase 2）';

  @override
  String get experiencePremiumFor24h => '觀看廣告體驗24小時高級功能！';

  @override
  String get allAdsHidden => '所有廣告已隱藏';

  @override
  String get loading => '載入中...';

  @override
  String get errorOccurred => '發生錯誤';
}
