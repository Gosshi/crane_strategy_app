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
  String remainingTime(int hours, int minutes) {
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
}
