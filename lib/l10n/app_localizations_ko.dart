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
  String remainingTime(int hours, int minutes) {
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
  String error(String error) {
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
}
