// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '크레인 네비';

  @override
  String get homeTitle => '크레인 네비';

  @override
  String get scanButton => '스캔';

  @override
  String get collectionTitle => '내 컬렉션';

  @override
  String get accountTitle => '계정';

  @override
  String get glossaryTitle => 'UFO 캐처 가이드';

  @override
  String get premiumFeatures => '프리미엄 기능';

  @override
  String get watchAdFor24h => '광고 시청하고 24시간 프리미엄 이용';

  @override
  String get premiumUnlocked => '✨ 24시간 프리미엄이 잠금 해제되었습니다!';

  @override
  String get noAds => '광고 없음';

  @override
  String get searchPlaceholder => '이름이나 태그로 검색 (예: 피규어)';

  @override
  String get guestUser => '게스트 사용자';

  @override
  String get accountSettings => '계정 설정';

  @override
  String get linkAccount => '계정 연결';

  @override
  String get linkWithGoogle => 'Google 계정으로 연결';

  @override
  String get signInWithApple => 'Apple로 로그인';

  @override
  String get accountLinked => '계정 연결됨';

  @override
  String get dataIsSafe => '데이터가 안전하게 저장되었습니다.';

  @override
  String get settings => '설정';

  @override
  String get soundEffects => '효과음';

  @override
  String get playSoundOnScan => '스캔 및 획득 시 효과음 재생';

  @override
  String get premiumMember => '프리미엄 회원';

  @override
  String remainingTime(Object hours, Object minutes) {
    return '남은 시간: $hours시간 $minutes분';
  }

  @override
  String get subscriptionActive => '구독 활성';

  @override
  String get limited24Hours => '24시간 잠금 해제 중';

  @override
  String get premiumBenefits => '프리미엄 혜택:';

  @override
  String get exclusiveBadge => '독점 배지 (Phase 2)';

  @override
  String get experiencePremiumFor24h => '광고를 시청하고 24시간 프리미엄 기능을 체험하세요!';

  @override
  String get allAdsHidden => '모든 광고 숨김';

  @override
  String get loading => '로딩 중...';

  @override
  String get errorOccurred => '오류가 발생했습니다';

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

  @override
  String get dangerZone => '위험 영역';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get deleteAccountDescription => '계정을 영구적으로 삭제합니다. 이 작업은 취소할 수 없습니다.';

  @override
  String get deleteAccountTitle => '계정 삭제 확인';

  @override
  String get deleteAccountWarning =>
      '이 작업은 계정과 모든 관련 데이터를 영구적으로 삭제합니다. 이 작업은 취소할 수 없습니다.';

  @override
  String get deleteAccountConfirm => '삭제';

  @override
  String get deleteAccountSuccess => '계정이 삭제되었습니다';

  @override
  String deleteAccountError(String error) {
    return '계정 삭제 오류: $error';
  }
}
