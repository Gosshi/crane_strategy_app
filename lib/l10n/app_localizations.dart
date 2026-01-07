import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Crenavi'**
  String get appTitle;

  /// Home screen title
  ///
  /// In en, this message translates to:
  /// **'Crenavi'**
  String get homeTitle;

  /// Scan button label
  ///
  /// In en, this message translates to:
  /// **'Scan Prize'**
  String get scanButton;

  /// Collection screen title
  ///
  /// In en, this message translates to:
  /// **'My Collection'**
  String get collectionTitle;

  /// Account screen title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// Glossary screen title
  ///
  /// In en, this message translates to:
  /// **'UFO Catcher Guide'**
  String get glossaryTitle;

  /// Premium features section title
  ///
  /// In en, this message translates to:
  /// **'Premium Features'**
  String get premiumFeatures;

  /// Reward ad button text
  ///
  /// In en, this message translates to:
  /// **'Watch ad for 24h premium'**
  String get watchAdFor24h;

  /// Premium unlock success message
  ///
  /// In en, this message translates to:
  /// **'✨ Premium unlocked for 24 hours!'**
  String get premiumUnlocked;

  /// Premium benefit: no ads
  ///
  /// In en, this message translates to:
  /// **'No Ads'**
  String get noAds;

  /// Search field placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search by name or tag (e.g., figure)'**
  String get searchPlaceholder;

  /// Guest user label
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// Account settings title
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// Account linking section title
  ///
  /// In en, this message translates to:
  /// **'Link Account'**
  String get linkAccount;

  /// Link with Google button
  ///
  /// In en, this message translates to:
  /// **'Link with Google'**
  String get linkWithGoogle;

  /// Sign in with Apple button
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// Account linked status
  ///
  /// In en, this message translates to:
  /// **'Account Linked'**
  String get accountLinked;

  /// Data safety message
  ///
  /// In en, this message translates to:
  /// **'Your data is safely stored.'**
  String get dataIsSafe;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Sound effects setting label
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get soundEffects;

  /// Sound effects description
  ///
  /// In en, this message translates to:
  /// **'Play sound on scan and prize catch'**
  String get playSoundOnScan;

  /// Premium member status
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premiumMember;

  /// Remaining premium time
  ///
  /// In en, this message translates to:
  /// **'Remaining time: {hours} hours {minutes} minutes'**
  String remainingTime(int hours, int minutes);

  /// Active subscription status
  ///
  /// In en, this message translates to:
  /// **'Subscription Active'**
  String get subscriptionActive;

  /// 24-hour unlock status
  ///
  /// In en, this message translates to:
  /// **'24-hour unlock active'**
  String get limited24Hours;

  /// Premium benefits label
  ///
  /// In en, this message translates to:
  /// **'Premium Benefits:'**
  String get premiumBenefits;

  /// Exclusive badge benefit
  ///
  /// In en, this message translates to:
  /// **'Exclusive Badge (Phase 2)'**
  String get exclusiveBadge;

  /// Premium experience promotion
  ///
  /// In en, this message translates to:
  /// **'Watch ad to experience premium for 24 hours!'**
  String get experiencePremiumFor24h;

  /// All ads hidden benefit
  ///
  /// In en, this message translates to:
  /// **'All ads hidden'**
  String get allAdsHidden;

  /// Loading status
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
