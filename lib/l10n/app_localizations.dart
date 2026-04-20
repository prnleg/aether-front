import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

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
    Locale('pt')
  ];

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @playground.
  ///
  /// In en, this message translates to:
  /// **'Playground'**
  String get playground;

  /// No description provided for @whatIfSimulator.
  ///
  /// In en, this message translates to:
  /// **'What-If Simulator'**
  String get whatIfSimulator;

  /// No description provided for @simulatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Test hypothetical portfolio changes and see projected impact.'**
  String get simulatorDesc;

  /// No description provided for @scenarioParameters.
  ///
  /// In en, this message translates to:
  /// **'Scenario Parameters'**
  String get scenarioParameters;

  /// No description provided for @sellSkins.
  ///
  /// In en, this message translates to:
  /// **'Sell CS:GO Skins'**
  String get sellSkins;

  /// No description provided for @buyCrypto.
  ///
  /// In en, this message translates to:
  /// **'Buy Crypto (BTC/ETH)'**
  String get buyCrypto;

  /// No description provided for @simulationSaved.
  ///
  /// In en, this message translates to:
  /// **'Simulation saved to scenarios.'**
  String get simulationSaved;

  /// No description provided for @saveScenario.
  ///
  /// In en, this message translates to:
  /// **'Save Scenario'**
  String get saveScenario;

  /// No description provided for @projectedROI.
  ///
  /// In en, this message translates to:
  /// **'Projected 12-Month ROI'**
  String get projectedROI;

  /// No description provided for @estimatedImpact.
  ///
  /// In en, this message translates to:
  /// **'Estimated +\$12,450.00'**
  String get estimatedImpact;

  /// No description provided for @assets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get assets;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @totalNetWorth.
  ///
  /// In en, this message translates to:
  /// **'Total Net Worth'**
  String get totalNetWorth;

  /// No description provided for @portfolioStats.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Statistics'**
  String get portfolioStats;

  /// No description provided for @totalAssets.
  ///
  /// In en, this message translates to:
  /// **'Total Assets'**
  String get totalAssets;

  /// No description provided for @highestValue.
  ///
  /// In en, this message translates to:
  /// **'Highest Value'**
  String get highestValue;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @dailyProfit.
  ///
  /// In en, this message translates to:
  /// **'Daily Profit'**
  String get dailyProfit;

  /// No description provided for @yourAssets.
  ///
  /// In en, this message translates to:
  /// **'Your Assets'**
  String get yourAssets;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @editAsset.
  ///
  /// In en, this message translates to:
  /// **'Edit Asset'**
  String get editAsset;

  /// No description provided for @volatility.
  ///
  /// In en, this message translates to:
  /// **'Volatility'**
  String get volatility;

  /// No description provided for @highest30d.
  ///
  /// In en, this message translates to:
  /// **'Highest (30d)'**
  String get highest30d;

  /// No description provided for @lowest30d.
  ///
  /// In en, this message translates to:
  /// **'Lowest (30d)'**
  String get lowest30d;

  /// No description provided for @profileConfig.
  ///
  /// In en, this message translates to:
  /// **'Profile Configuration'**
  String get profileConfig;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @twoFactorAuth.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuth;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @myAssets.
  ///
  /// In en, this message translates to:
  /// **'My Assets'**
  String get myAssets;

  /// No description provided for @addAsset.
  ///
  /// In en, this message translates to:
  /// **'Add Asset'**
  String get addAsset;

  /// No description provided for @expandPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Expand Your Portfolio'**
  String get expandPortfolio;

  /// No description provided for @expandPortfolioDesc.
  ///
  /// In en, this message translates to:
  /// **'Click below to add a new crypto, stock, or collectible to your tracked assets.'**
  String get expandPortfolioDesc;

  /// No description provided for @addNewAsset.
  ///
  /// In en, this message translates to:
  /// **'Add New Asset'**
  String get addNewAsset;

  /// No description provided for @noAssetsFound.
  ///
  /// In en, this message translates to:
  /// **'No assets found'**
  String get noAssetsFound;

  /// No description provided for @assetDetails.
  ///
  /// In en, this message translates to:
  /// **'Asset Details'**
  String get assetDetails;

  /// No description provided for @assetName.
  ///
  /// In en, this message translates to:
  /// **'Asset Name'**
  String get assetName;

  /// No description provided for @assetType.
  ///
  /// In en, this message translates to:
  /// **'Asset Type'**
  String get assetType;

  /// No description provided for @initialValue.
  ///
  /// In en, this message translates to:
  /// **'Initial Value (\$)'**
  String get initialValue;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @searchAssets.
  ///
  /// In en, this message translates to:
  /// **'Search assets...'**
  String get searchAssets;

  /// No description provided for @noAssetsMatch.
  ///
  /// In en, this message translates to:
  /// **'No assets match your filters'**
  String get noAssetsMatch;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @oneWeekShort.
  ///
  /// In en, this message translates to:
  /// **'1W'**
  String get oneWeekShort;

  /// No description provided for @oneMonthShort.
  ///
  /// In en, this message translates to:
  /// **'1M'**
  String get oneMonthShort;

  /// No description provided for @threeMonthsShort.
  ///
  /// In en, this message translates to:
  /// **'3M'**
  String get threeMonthsShort;

  /// No description provided for @sixMonthsShort.
  ///
  /// In en, this message translates to:
  /// **'6M'**
  String get sixMonthsShort;

  /// No description provided for @oneYearShort.
  ///
  /// In en, this message translates to:
  /// **'1Y'**
  String get oneYearShort;

  /// No description provided for @allShort.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get allShort;

  /// No description provided for @vaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Vault & Security'**
  String get vaultTitle;

  /// No description provided for @securitySection.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securitySection;

  /// No description provided for @biometricLock.
  ///
  /// In en, this message translates to:
  /// **'Biometric Lock'**
  String get biometricLock;

  /// No description provided for @biometricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require FaceID/TouchID to open'**
  String get biometricSubtitle;

  /// No description provided for @preferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesSection;

  /// No description provided for @primaryCurrency.
  ///
  /// In en, this message translates to:
  /// **'Primary Currency'**
  String get primaryCurrency;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @apiConnections.
  ///
  /// In en, this message translates to:
  /// **'API Connections'**
  String get apiConnections;

  /// No description provided for @biometricsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics not available on this device'**
  String get biometricsNotAvailable;

  /// No description provided for @biometricReason.
  ///
  /// In en, this message translates to:
  /// **'Please authenticate to enable the Vault'**
  String get biometricReason;

  /// No description provided for @twoFactorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of protection'**
  String get twoFactorSubtitle;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @steamInventoryApi.
  ///
  /// In en, this message translates to:
  /// **'Steam Inventory API'**
  String get steamInventoryApi;

  /// No description provided for @connectedAs.
  ///
  /// In en, this message translates to:
  /// **'Connected as \"{username}\"'**
  String connectedAs(Object username);

  /// No description provided for @exchangeApiKeys.
  ///
  /// In en, this message translates to:
  /// **'Exchange API Keys'**
  String get exchangeApiKeys;

  /// No description provided for @exchangeApiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Binance, Coinbase, Kraken'**
  String get exchangeApiSubtitle;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account & Data'**
  String get deleteAccount;

  /// No description provided for @vaultHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Data is Encrypted'**
  String get vaultHeaderTitle;

  /// No description provided for @vaultHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Aether uses military-grade AES-256 encryption to keep your assets private.'**
  String get vaultHeaderSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// No description provided for @usdName.
  ///
  /// In en, this message translates to:
  /// **'United States Dollar'**
  String get usdName;

  /// No description provided for @brlName.
  ///
  /// In en, this message translates to:
  /// **'Brazilian Real'**
  String get brlName;

  /// No description provided for @eurName.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get eurName;

  /// No description provided for @btcName.
  ///
  /// In en, this message translates to:
  /// **'Bitcoin'**
  String get btcName;

  /// No description provided for @discoveryHub.
  ///
  /// In en, this message translates to:
  /// **'Discovery Hub'**
  String get discoveryHub;

  /// No description provided for @searchDiscovery.
  ///
  /// In en, this message translates to:
  /// **'Search assets (e.g. Dragon Lore, BTC)...'**
  String get searchDiscovery;

  /// No description provided for @portfolioWeight.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Weight'**
  String get portfolioWeight;

  /// No description provided for @concentrationRisk.
  ///
  /// In en, this message translates to:
  /// **'Concentration Risk'**
  String get concentrationRisk;

  /// No description provided for @exposureModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate Exposure'**
  String get exposureModerate;

  /// No description provided for @diversified.
  ///
  /// In en, this message translates to:
  /// **'Well Diversified'**
  String get diversified;

  /// No description provided for @failedToLoadAssets.
  ///
  /// In en, this message translates to:
  /// **'Failed to load assets.'**
  String get failedToLoadAssets;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @bullish.
  ///
  /// In en, this message translates to:
  /// **'Bullish'**
  String get bullish;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @volatile.
  ///
  /// In en, this message translates to:
  /// **'Volatile'**
  String get volatile;

  /// No description provided for @csgoSkin.
  ///
  /// In en, this message translates to:
  /// **'CS:GO Skin'**
  String get csgoSkin;

  /// No description provided for @crypto.
  ///
  /// In en, this message translates to:
  /// **'Crypto'**
  String get crypto;

  /// No description provided for @nft.
  ///
  /// In en, this message translates to:
  /// **'NFT'**
  String get nft;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @collectible.
  ///
  /// In en, this message translates to:
  /// **'Collectible'**
  String get collectible;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @unifiedAssets.
  ///
  /// In en, this message translates to:
  /// **'Your assets, unified.'**
  String get unifiedAssets;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @financialJourney.
  ///
  /// In en, this message translates to:
  /// **'Start your financial journey.'**
  String get financialJourney;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @highConcentrationRisk.
  ///
  /// In en, this message translates to:
  /// **'High Concentration Risk'**
  String get highConcentrationRisk;

  /// No description provided for @deepDiveAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Deep Dive Analysis'**
  String get deepDiveAnalysis;

  /// No description provided for @volatilityIndex.
  ///
  /// In en, this message translates to:
  /// **'Volatility Index'**
  String get volatilityIndex;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @correlations.
  ///
  /// In en, this message translates to:
  /// **'Correlations'**
  String get correlations;

  /// No description provided for @noCorrelations.
  ///
  /// In en, this message translates to:
  /// **'No correlations available'**
  String get noCorrelations;

  /// No description provided for @historicalJourney.
  ///
  /// In en, this message translates to:
  /// **'Historical Journey'**
  String get historicalJourney;

  /// No description provided for @noMilestones.
  ///
  /// In en, this message translates to:
  /// **'No historical milestones available'**
  String get noMilestones;

  /// No description provided for @sellHypothetical.
  ///
  /// In en, this message translates to:
  /// **'What if you sold here? {amount} extra'**
  String sellHypothetical(Object amount);

  /// No description provided for @pendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingReview;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @inPortfolio.
  ///
  /// In en, this message translates to:
  /// **'In Portfolio'**
  String get inPortfolio;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @syncInventory.
  ///
  /// In en, this message translates to:
  /// **'Sync Inventory'**
  String get syncInventory;

  /// No description provided for @syncSteamInventory.
  ///
  /// In en, this message translates to:
  /// **'Sync Steam Inventory'**
  String get syncSteamInventory;

  /// No description provided for @syncWarning.
  ///
  /// In en, this message translates to:
  /// **'This may take a while (up to 2 minutes for large inventories).'**
  String get syncWarning;

  /// No description provided for @syncResult.
  ///
  /// In en, this message translates to:
  /// **'Added {added}, Updated {updated}, Skipped {skipped}'**
  String syncResult(int added, int updated, int skipped);

  /// No description provided for @selectGame.
  ///
  /// In en, this message translates to:
  /// **'Select Game'**
  String get selectGame;

  /// No description provided for @cs2.
  ///
  /// In en, this message translates to:
  /// **'CS2 (Counter-Strike 2)'**
  String get cs2;

  /// No description provided for @dota2.
  ///
  /// In en, this message translates to:
  /// **'Dota 2'**
  String get dota2;

  /// No description provided for @customAppId.
  ///
  /// In en, this message translates to:
  /// **'Custom App ID'**
  String get customAppId;

  /// No description provided for @enterAppId.
  ///
  /// In en, this message translates to:
  /// **'Enter App ID'**
  String get enterAppId;

  /// No description provided for @steamId.
  ///
  /// In en, this message translates to:
  /// **'Steam ID'**
  String get steamId;

  /// No description provided for @setSteamId.
  ///
  /// In en, this message translates to:
  /// **'Set Steam ID'**
  String get setSteamId;

  /// No description provided for @steamIdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your SteamID64 (e.g. 76561198...)'**
  String get steamIdSubtitle;

  /// No description provided for @steamIdHint.
  ///
  /// In en, this message translates to:
  /// **'76561198...'**
  String get steamIdHint;

  /// No description provided for @steamIdHelper.
  ///
  /// In en, this message translates to:
  /// **'Find your SteamID64 at steamid.io'**
  String get steamIdHelper;

  /// No description provided for @noDiscoveryItems.
  ///
  /// In en, this message translates to:
  /// **'No items found for this filter.'**
  String get noDiscoveryItems;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed. Please try again.'**
  String get syncFailed;

  /// No description provided for @actionFailed.
  ///
  /// In en, this message translates to:
  /// **'Action failed. Please try again.'**
  String get actionFailed;

  /// No description provided for @rejectCheapItems.
  ///
  /// In en, this message translates to:
  /// **'Reject Cheap Items'**
  String get rejectCheapItems;

  /// No description provided for @rejectBelowPrice.
  ///
  /// In en, this message translates to:
  /// **'Reject all items below this price'**
  String get rejectBelowPrice;

  /// No description provided for @priceThreshold.
  ///
  /// In en, this message translates to:
  /// **'Max Price'**
  String get priceThreshold;

  /// No description provided for @rejectCountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Reject {count} item(s)'**
  String rejectCountConfirm(int count);

  /// No description provided for @noCheapItems.
  ///
  /// In en, this message translates to:
  /// **'No items below that price.'**
  String get noCheapItems;

  /// No description provided for @bulkRejected.
  ///
  /// In en, this message translates to:
  /// **'Bulk rejection done.'**
  String get bulkRejected;

  /// No description provided for @sortByPrice.
  ///
  /// In en, this message translates to:
  /// **'Sort by Price'**
  String get sortByPrice;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @valueHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Value: High → Low'**
  String get valueHighToLow;

  /// No description provided for @valueLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Value: Low → High'**
  String get valueLowToHigh;

  /// No description provided for @nameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name: A → Z'**
  String get nameAZ;

  /// No description provided for @change24hDesc.
  ///
  /// In en, this message translates to:
  /// **'24h Change: High → Low'**
  String get change24hDesc;
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
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
