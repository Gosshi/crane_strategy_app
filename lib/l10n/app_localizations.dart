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

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Crenavi'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Crenavi'**
  String get homeTitle;

  /// No description provided for @scanButton.
  ///
  /// In en, this message translates to:
  /// **'Scan Prize'**
  String get scanButton;

  /// No description provided for @collectionTitle.
  ///
  /// In en, this message translates to:
  /// **'My Collection'**
  String get collectionTitle;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @glossaryTitle.
  ///
  /// In en, this message translates to:
  /// **'UFO Catcher Guide'**
  String get glossaryTitle;

  /// No description provided for @premiumFeatures.
  ///
  /// In en, this message translates to:
  /// **'Premium Features'**
  String get premiumFeatures;

  /// No description provided for @watchAdFor24h.
  ///
  /// In en, this message translates to:
  /// **'Watch ad for 24h premium'**
  String get watchAdFor24h;

  /// No description provided for @premiumUnlocked.
  ///
  /// In en, this message translates to:
  /// **'✨ Premium unlocked for 24 hours!'**
  String get premiumUnlocked;

  /// No description provided for @noAds.
  ///
  /// In en, this message translates to:
  /// **'No Ads'**
  String get noAds;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by name or tag (e.g., figure)'**
  String get searchPlaceholder;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @linkAccount.
  ///
  /// In en, this message translates to:
  /// **'Link Account'**
  String get linkAccount;

  /// No description provided for @linkWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Link with Google'**
  String get linkWithGoogle;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @accountLinked.
  ///
  /// In en, this message translates to:
  /// **'Account Linked'**
  String get accountLinked;

  /// No description provided for @dataIsSafe.
  ///
  /// In en, this message translates to:
  /// **'Your data is safely stored.'**
  String get dataIsSafe;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get soundEffects;

  /// No description provided for @playSoundOnScan.
  ///
  /// In en, this message translates to:
  /// **'Play sound on scan and prize catch'**
  String get playSoundOnScan;

  /// No description provided for @premiumMember.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premiumMember;

  /// No description provided for @remainingTime.
  ///
  /// In en, this message translates to:
  /// **'Remaining time: {hours} hours {minutes} minutes'**
  String remainingTime(Object hours, Object minutes);

  /// No description provided for @subscriptionActive.
  ///
  /// In en, this message translates to:
  /// **'Subscription Active'**
  String get subscriptionActive;

  /// No description provided for @limited24Hours.
  ///
  /// In en, this message translates to:
  /// **'24-hour unlock active'**
  String get limited24Hours;

  /// No description provided for @premiumBenefits.
  ///
  /// In en, this message translates to:
  /// **'Premium Benefits:'**
  String get premiumBenefits;

  /// No description provided for @exclusiveBadge.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Badge (Phase 2)'**
  String get exclusiveBadge;

  /// No description provided for @experiencePremiumFor24h.
  ///
  /// In en, this message translates to:
  /// **'Watch ad to experience premium for 24 hours!'**
  String get experiencePremiumFor24h;

  /// No description provided for @allAdsHidden.
  ///
  /// In en, this message translates to:
  /// **'All ads hidden'**
  String get allAdsHidden;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @collectionScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'My Collection'**
  String get collectionScreenTitle;

  /// No description provided for @gridView.
  ///
  /// In en, this message translates to:
  /// **'Grid View'**
  String get gridView;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get listView;

  /// No description provided for @noPrizes.
  ///
  /// In en, this message translates to:
  /// **'No prizes collected yet'**
  String get noPrizes;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(Object error);

  /// No description provided for @acquiredDate.
  ///
  /// In en, this message translates to:
  /// **'Acquired'**
  String get acquiredDate;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @shopName.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopName;

  /// No description provided for @shareAction.
  ///
  /// In en, this message translates to:
  /// **'Share (Brag)'**
  String get shareAction;

  /// No description provided for @searchTerms.
  ///
  /// In en, this message translates to:
  /// **'Search terms...'**
  String get searchTerms;

  /// No description provided for @allCategory.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategory;

  /// No description provided for @noTermsFound.
  ///
  /// In en, this message translates to:
  /// **'No matching terms found'**
  String get noTermsFound;

  /// No description provided for @editPost.
  ///
  /// In en, this message translates to:
  /// **'Edit Post'**
  String get editPost;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @categoryBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic Terms'**
  String get categoryBasic;

  /// No description provided for @categoryTechnique.
  ///
  /// In en, this message translates to:
  /// **'Techniques'**
  String get categoryTechnique;

  /// No description provided for @categoryPrize.
  ///
  /// In en, this message translates to:
  /// **'Prizes'**
  String get categoryPrize;

  /// No description provided for @categoryMachine.
  ///
  /// In en, this message translates to:
  /// **'Machine/Settings'**
  String get categoryMachine;

  /// No description provided for @scanResult.
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get scanResult;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @postStrategy.
  ///
  /// In en, this message translates to:
  /// **'Post Strategy'**
  String get postStrategy;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login required (authentication failed)'**
  String get loginRequired;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got {name}!'**
  String gotIt(Object name);

  /// No description provided for @shareProduct.
  ///
  /// In en, this message translates to:
  /// **'Share this product'**
  String get shareProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editProduct;

  /// No description provided for @gotThisProduct.
  ///
  /// In en, this message translates to:
  /// **'Got this product!'**
  String get gotThisProduct;

  /// No description provided for @noRelatedStrategies.
  ///
  /// In en, this message translates to:
  /// **'No related strategies yet'**
  String get noRelatedStrategies;

  /// No description provided for @loadStrategyError.
  ///
  /// In en, this message translates to:
  /// **'Error loading strategies: {error}'**
  String loadStrategyError(Object error);

  /// No description provided for @noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet.\\nBe the first to share tips!'**
  String get noPostsYet;

  /// No description provided for @cannotOpenVideo.
  ///
  /// In en, this message translates to:
  /// **'Could not open video'**
  String get cannotOpenVideo;

  /// No description provided for @watchVideoYouTube.
  ///
  /// In en, this message translates to:
  /// **'Watch on YouTube'**
  String get watchVideoYouTube;

  /// No description provided for @yahooSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching Yahoo! Shopping...'**
  String get yahooSearching;

  /// No description provided for @registerWithThis.
  ///
  /// In en, this message translates to:
  /// **'Register with this info'**
  String get registerWithThis;

  /// No description provided for @returnHome.
  ///
  /// In en, this message translates to:
  /// **'Return Home'**
  String get returnHome;

  /// No description provided for @manualRegister.
  ///
  /// In en, this message translates to:
  /// **'Register Manually'**
  String get manualRegister;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @noStrategiesYet.
  ///
  /// In en, this message translates to:
  /// **'No strategies yet'**
  String get noStrategiesYet;

  /// No description provided for @linkGoogleAccount.
  ///
  /// In en, this message translates to:
  /// **'Link your data permanently\\nwith your Google account.'**
  String get linkGoogleAccount;

  /// No description provided for @linkSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully linked!'**
  String get linkSuccess;

  /// No description provided for @linkError.
  ///
  /// In en, this message translates to:
  /// **'Link error: {error}'**
  String linkError(Object error);

  /// No description provided for @dataSeeding.
  ///
  /// In en, this message translates to:
  /// **'Data Seeding'**
  String get dataSeeding;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @seed.
  ///
  /// In en, this message translates to:
  /// **'Seed'**
  String get seed;

  /// No description provided for @seedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data seeding completed'**
  String get seedSuccess;

  /// No description provided for @productNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter product name'**
  String get productNameRequired;

  /// No description provided for @categoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one category'**
  String get categoryRequired;

  /// No description provided for @registerError.
  ///
  /// In en, this message translates to:
  /// **'Registration error: {error}'**
  String registerError(Object error);

  /// No description provided for @productRegistration.
  ///
  /// In en, this message translates to:
  /// **'Product Registration'**
  String get productRegistration;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode: {barcode}'**
  String barcode(Object barcode);

  /// No description provided for @addToCollection.
  ///
  /// In en, this message translates to:
  /// **'Also add to \"My Collection\" upon registration'**
  String get addToCollection;
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
