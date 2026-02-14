// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Magic Answer Book';

  @override
  String get homeTitle => 'Get Answers';

  @override
  String get shakeGuide => 'Shake your phone to get an answer';

  @override
  String get getAnswerButton => 'Get Answer';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get save => 'Save';

  @override
  String get share => 'Share';

  @override
  String get close => 'Close';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Home';

  @override
  String get startButton => 'Start Solving';

  @override
  String get introTitle => 'Magic Answer Book';

  @override
  String get introSubtitle => 'When in doubt, give it a shake';

  @override
  String get disclaimer =>
      'Answers are for entertainment only. Not a substitute for professional advice on medical, legal, or financial matters.';

  @override
  String get vibration => 'Vibration';

  @override
  String get vibrationSub => 'Haptic feedback on answer';

  @override
  String get shakeDetection => 'Shake Detection';

  @override
  String get shakeDetectionSub => 'Shake to get an answer';

  @override
  String get sound => 'Sound';

  @override
  String get soundSub => 'Sound effects on answer';

  @override
  String get language => 'Language';

  @override
  String get general => 'General';

  @override
  String get purchase => 'Purchase';

  @override
  String get info => 'Info';

  @override
  String get removeAds => 'Remove Ads';

  @override
  String get removeAdsComplete => 'Ads Removed';

  @override
  String get removeAdsPrice => '\$4.99 (Lifetime)';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get restorePurchasesSub => 'Restore previous purchases';

  @override
  String get caution => 'Caution';

  @override
  String get cautionText =>
      'This app is for entertainment purposes only.\nFor important decisions, please consult a professional.\nNo guarantees of efficacy or predictions.';

  @override
  String get licenses => 'Open Source Licenses';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyText =>
      'This app does not require sign-up, and question/answer data is stored locally on your device.\nWhen ads are shown, the ad provider (e.g., AdMob) may process device identifiers such as the advertising ID.\nFor ad-removal purchases, the in-app purchase provider may process data required for payment verification.';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsOfServiceText =>
      'Answers provided by this app are for entertainment and reference only.\nFor medical, legal, or financial decisions, please consult a qualified professional.\nUsers are responsible for decisions and outcomes based on app answers.';

  @override
  String get version => 'Version';

  @override
  String get noSavedAnswers => 'No saved answers yet';

  @override
  String get noSavedAnswersSub => 'Tap Save on a result card to keep it';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get deleteAllConfirm => 'Delete all saved answers?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get saveFailed => 'Failed to save.';

  @override
  String get saveSuccess => 'Saved!';

  @override
  String get purchaseSuccess => 'Purchase completed. Ads are now removed.';

  @override
  String get restoreSuccess => 'Restore completed. Ads are now removed.';

  @override
  String get purchaseFailed => 'Purchase failed. Please try again.';

  @override
  String get restoreFailed => 'No purchase could be restored.';

  @override
  String get iapUnavailable => 'In-app purchases are currently unavailable.';

  @override
  String get purchaseCancelled => 'Purchase was cancelled.';

  @override
  String get networkError => 'Please check your network connection.';

  @override
  String get testMode =>
      'Test mode: payments available after store registration.';

  @override
  String get testModeRestore =>
      'Test mode: restore available after store registration.';

  @override
  String get purchaseDialogContent =>
      '\$4.99 (Lifetime)\n\nRemove all ads permanently.\n\n※ Currently in test mode.';

  @override
  String get purchaseButton => 'Purchase';

  @override
  String get searchingAnswer => 'Finding your answer...';

  @override
  String shareFormat(String question, String answer, String subtext) {
    return 'Q: $question\nA: $answer — $subtext\n\n— Magic Answer Book';
  }

  @override
  String get homeInstruction1 =>
      '1. Think deeply about your question or worry.';

  @override
  String get homeInstruction2 => '2. Focus for 3 seconds, then shake or tap.';

  @override
  String get homeInstruction3 => '3. The answer you seek will appear.';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get chinese => '中文';
}
