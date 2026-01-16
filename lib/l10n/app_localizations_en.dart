// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Crenavi';

  @override
  String get homeTitle => 'Crenavi';

  @override
  String get scanButton => 'Scan Prize';

  @override
  String get collectionTitle => 'My Collection';

  @override
  String get accountTitle => 'Account';

  @override
  String get glossaryTitle => 'UFO Catcher Guide';

  @override
  String get premiumFeatures => 'Premium Features';

  @override
  String get watchAdFor24h => 'Watch ad for 24h premium';

  @override
  String get premiumUnlocked => '✨ Premium unlocked for 24 hours!';

  @override
  String get noAds => 'No Ads';

  @override
  String get searchPlaceholder => 'Search by name or tag (e.g., figure)';

  @override
  String get guestUser => 'Guest User';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get linkAccount => 'Link Account';

  @override
  String get linkWithGoogle => 'Link with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get accountLinked => 'Account Linked';

  @override
  String get dataIsSafe => 'Your data is safely stored.';

  @override
  String get settings => 'Settings';

  @override
  String get soundEffects => 'Sound Effects';

  @override
  String get playSoundOnScan => 'Play sound on scan and prize catch';

  @override
  String get premiumMember => 'Premium Member';

  @override
  String remainingTime(Object hours, Object minutes) {
    return 'Remaining time: $hours hours $minutes minutes';
  }

  @override
  String get subscriptionActive => 'Subscription Active';

  @override
  String get limited24Hours => '24-hour unlock active';

  @override
  String get premiumBenefits => 'Premium Benefits:';

  @override
  String get exclusiveBadge => 'Exclusive Badge (Phase 2)';

  @override
  String get experiencePremiumFor24h =>
      'Watch ad to experience premium for 24 hours!';

  @override
  String get allAdsHidden => 'All ads hidden';

  @override
  String get loading => 'Loading...';

  @override
  String get errorOccurred => 'An error occurred';

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
  String get dangerZone => 'Danger Zone';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountDescription =>
      'Permanently delete your account. This action cannot be undone.';

  @override
  String get deleteAccountTitle => 'Confirm Account Deletion';

  @override
  String get deleteAccountWarning =>
      'This will permanently delete your account and all associated data. This action cannot be undone.';

  @override
  String get deleteAccountConfirm => 'Delete';

  @override
  String get deleteAccountSuccess => 'Account deleted successfully';

  @override
  String deleteAccountError(String error) {
    return 'Account deletion error: $error';
  }
}
