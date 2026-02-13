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
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'마법의 고민해결책'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In ko, this message translates to:
  /// **'고민 해결'**
  String get homeTitle;

  /// No description provided for @shakeGuide.
  ///
  /// In ko, this message translates to:
  /// **'폰을 흔들어 답변을 받아보세요'**
  String get shakeGuide;

  /// No description provided for @getAnswerButton.
  ///
  /// In ko, this message translates to:
  /// **'답변 받기'**
  String get getAnswerButton;

  /// No description provided for @tryAgain.
  ///
  /// In ko, this message translates to:
  /// **'다시 뽑기'**
  String get tryAgain;

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// No description provided for @share.
  ///
  /// In ko, this message translates to:
  /// **'공유'**
  String get share;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @history.
  ///
  /// In ko, this message translates to:
  /// **'기록'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get home;

  /// No description provided for @startButton.
  ///
  /// In ko, this message translates to:
  /// **'고민 해결 시작'**
  String get startButton;

  /// No description provided for @introTitle.
  ///
  /// In ko, this message translates to:
  /// **'마법의 고민해결책'**
  String get introTitle;

  /// No description provided for @introSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'고민이 있을 때, 흔들어 보세요'**
  String get introSubtitle;

  /// No description provided for @disclaimer.
  ///
  /// In ko, this message translates to:
  /// **'본 앱의 답변은 참고/오락용이며, 의료·법률·투자 등 전문적 판단을 대체하지 않습니다.'**
  String get disclaimer;

  /// No description provided for @vibration.
  ///
  /// In ko, this message translates to:
  /// **'진동'**
  String get vibration;

  /// No description provided for @vibrationSub.
  ///
  /// In ko, this message translates to:
  /// **'답변 시 진동 피드백'**
  String get vibrationSub;

  /// No description provided for @shakeDetection.
  ///
  /// In ko, this message translates to:
  /// **'흔들기 실행'**
  String get shakeDetection;

  /// No description provided for @shakeDetectionSub.
  ///
  /// In ko, this message translates to:
  /// **'폰 흔들어서 답변 받기'**
  String get shakeDetectionSub;

  /// No description provided for @sound.
  ///
  /// In ko, this message translates to:
  /// **'사운드'**
  String get sound;

  /// No description provided for @soundSub.
  ///
  /// In ko, this message translates to:
  /// **'답변 시 효과음'**
  String get soundSub;

  /// No description provided for @language.
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get language;

  /// No description provided for @general.
  ///
  /// In ko, this message translates to:
  /// **'일반'**
  String get general;

  /// No description provided for @purchase.
  ///
  /// In ko, this message translates to:
  /// **'구매'**
  String get purchase;

  /// No description provided for @info.
  ///
  /// In ko, this message translates to:
  /// **'정보'**
  String get info;

  /// No description provided for @removeAds.
  ///
  /// In ko, this message translates to:
  /// **'광고 제거'**
  String get removeAds;

  /// No description provided for @removeAdsComplete.
  ///
  /// In ko, this message translates to:
  /// **'광고 제거 완료'**
  String get removeAdsComplete;

  /// No description provided for @removeAdsPrice.
  ///
  /// In ko, this message translates to:
  /// **'₩4,990 (영구)'**
  String get removeAdsPrice;

  /// No description provided for @restorePurchases.
  ///
  /// In ko, this message translates to:
  /// **'구매 복원'**
  String get restorePurchases;

  /// No description provided for @restorePurchasesSub.
  ///
  /// In ko, this message translates to:
  /// **'이전 구매 내역 복원'**
  String get restorePurchasesSub;

  /// No description provided for @caution.
  ///
  /// In ko, this message translates to:
  /// **'주의 사항'**
  String get caution;

  /// No description provided for @cautionText.
  ///
  /// In ko, this message translates to:
  /// **'본 앱은 엔터테인먼트/오락 목적입니다.\n의료·법률·투자 등 중요한 판단은 전문가 상담을 권장합니다.\n효능이나 예언을 보장하지 않습니다.'**
  String get cautionText;

  /// No description provided for @licenses.
  ///
  /// In ko, this message translates to:
  /// **'오픈소스 라이선스'**
  String get licenses;

  /// No description provided for @privacyPolicy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyText.
  ///
  /// In ko, this message translates to:
  /// **'본 앱은 개인 정보를 수집하지 않습니다.\n모든 데이터는 기기에 로컬로 저장됩니다.\n네트워크 연결 없이 오프라인으로 동작합니다.'**
  String get privacyPolicyText;

  /// No description provided for @termsOfService.
  ///
  /// In ko, this message translates to:
  /// **'이용약관'**
  String get termsOfService;

  /// No description provided for @termsOfServiceText.
  ///
  /// In ko, this message translates to:
  /// **'본 앱의 답변은 오락/참고 목적으로 제공됩니다.\n답변에 대한 법적 책임은 사용자에게 있습니다.\n의료·법률·투자 등 전문적 판단은 전문가 상담을 이용해 주세요.'**
  String get termsOfServiceText;

  /// No description provided for @version.
  ///
  /// In ko, this message translates to:
  /// **'버전'**
  String get version;

  /// No description provided for @noSavedAnswers.
  ///
  /// In ko, this message translates to:
  /// **'아직 저장한 답변이 없어요'**
  String get noSavedAnswers;

  /// No description provided for @noSavedAnswersSub.
  ///
  /// In ko, this message translates to:
  /// **'답변 카드에서 저장 버튼을 눌러보세요'**
  String get noSavedAnswersSub;

  /// No description provided for @deleteAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 삭제'**
  String get deleteAll;

  /// No description provided for @deleteAllConfirm.
  ///
  /// In ko, this message translates to:
  /// **'저장된 답변을 모두 삭제할까요?'**
  String get deleteAllConfirm;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// No description provided for @saveFailed.
  ///
  /// In ko, this message translates to:
  /// **'저장에 실패했습니다.'**
  String get saveFailed;

  /// No description provided for @saveSuccess.
  ///
  /// In ko, this message translates to:
  /// **'저장되었습니다!'**
  String get saveSuccess;

  /// No description provided for @purchaseSuccess.
  ///
  /// In ko, this message translates to:
  /// **'구매가 완료되어 광고가 제거되었습니다.'**
  String get purchaseSuccess;

  /// No description provided for @restoreSuccess.
  ///
  /// In ko, this message translates to:
  /// **'복원이 완료되어 광고가 제거되었습니다.'**
  String get restoreSuccess;

  /// No description provided for @purchaseFailed.
  ///
  /// In ko, this message translates to:
  /// **'구매에 실패했습니다. 다시 시도해 주세요.'**
  String get purchaseFailed;

  /// No description provided for @restoreFailed.
  ///
  /// In ko, this message translates to:
  /// **'복원할 구매 내역을 찾지 못했습니다.'**
  String get restoreFailed;

  /// No description provided for @iapUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'인앱 구매를 현재 사용할 수 없습니다.'**
  String get iapUnavailable;

  /// No description provided for @purchaseCancelled.
  ///
  /// In ko, this message translates to:
  /// **'구매가 취소되었습니다.'**
  String get purchaseCancelled;

  /// No description provided for @networkError.
  ///
  /// In ko, this message translates to:
  /// **'네트워크를 확인해 주세요.'**
  String get networkError;

  /// No description provided for @testMode.
  ///
  /// In ko, this message translates to:
  /// **'테스트 모드: 실제 결제는 스토어 등록 후 가능합니다.'**
  String get testMode;

  /// No description provided for @testModeRestore.
  ///
  /// In ko, this message translates to:
  /// **'테스트 모드: 구매 복원은 스토어 등록 후 가능합니다.'**
  String get testModeRestore;

  /// No description provided for @purchaseDialogContent.
  ///
  /// In ko, this message translates to:
  /// **'₩4,990 (영구)\n\n모든 광고를 영구적으로 제거합니다.\n\n※ 현재 테스트 모드입니다.'**
  String get purchaseDialogContent;

  /// No description provided for @purchaseButton.
  ///
  /// In ko, this message translates to:
  /// **'구매하기'**
  String get purchaseButton;

  /// No description provided for @searchingAnswer.
  ///
  /// In ko, this message translates to:
  /// **'답을 찾고 있어요...'**
  String get searchingAnswer;

  /// No description provided for @shareFormat.
  ///
  /// In ko, this message translates to:
  /// **'Q: {question}\nA: {answer} — {subtext}\n\n— 마법의 고민해결책'**
  String shareFormat(String question, String answer, String subtext);

  /// No description provided for @homeInstruction1.
  ///
  /// In ko, this message translates to:
  /// **'1. 고민이나 질문을 떠올려보세요.'**
  String get homeInstruction1;

  /// No description provided for @homeInstruction2.
  ///
  /// In ko, this message translates to:
  /// **'2. 3초 집중 후, 흔들거나 터치하세요.'**
  String get homeInstruction2;

  /// No description provided for @homeInstruction3.
  ///
  /// In ko, this message translates to:
  /// **'3. 마법의 답변이 나타납니다.'**
  String get homeInstruction3;

  /// No description provided for @korean.
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get korean;

  /// No description provided for @english.
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In ko, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @chinese.
  ///
  /// In ko, this message translates to:
  /// **'中文'**
  String get chinese;
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
      'that was used.');
}
