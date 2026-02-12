// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '마법의 고민해결책';

  @override
  String get homeTitle => '고민 해결';

  @override
  String get shakeGuide => '폰을 흔들어 답변을 받아보세요';

  @override
  String get getAnswerButton => '답변 받기';

  @override
  String get tryAgain => '다시 뽑기';

  @override
  String get save => '저장';

  @override
  String get share => '공유';

  @override
  String get close => '닫기';

  @override
  String get history => '기록';

  @override
  String get settings => '설정';

  @override
  String get home => '홈';

  @override
  String get startButton => '고민 해결 시작';

  @override
  String get introTitle => '마법의 고민해결책';

  @override
  String get introSubtitle => '고민이 있을 때, 흔들어 보세요';

  @override
  String get disclaimer => '본 앱의 답변은 참고/오락용이며, 의료·법률·투자 등 전문적 판단을 대체하지 않습니다.';

  @override
  String get vibration => '진동';

  @override
  String get vibrationSub => '답변 시 진동 피드백';

  @override
  String get shakeDetection => '흔들기 실행';

  @override
  String get shakeDetectionSub => '폰 흔들어서 답변 받기';

  @override
  String get sound => '사운드';

  @override
  String get soundSub => '답변 시 효과음';

  @override
  String get language => '언어';

  @override
  String get general => '일반';

  @override
  String get purchase => '구매';

  @override
  String get info => '정보';

  @override
  String get removeAds => '광고 제거';

  @override
  String get removeAdsComplete => '광고 제거 완료';

  @override
  String get removeAdsPrice => '₩4,990 (영구)';

  @override
  String get restorePurchases => '구매 복원';

  @override
  String get restorePurchasesSub => '이전 구매 내역 복원';

  @override
  String get caution => '주의 사항';

  @override
  String get cautionText =>
      '본 앱은 엔터테인먼트/오락 목적입니다.\n의료·법률·투자 등 중요한 판단은 전문가 상담을 권장합니다.\n효능이나 예언을 보장하지 않습니다.';

  @override
  String get licenses => '오픈소스 라이선스';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get privacyPolicyText =>
      '본 앱은 개인 정보를 수집하지 않습니다.\n모든 데이터는 기기에 로컬로 저장됩니다.\n네트워크 연결 없이 오프라인으로 동작합니다.';

  @override
  String get termsOfService => '이용약관';

  @override
  String get termsOfServiceText =>
      '본 앱의 답변은 오락/참고 목적으로 제공됩니다.\n답변에 대한 법적 책임은 사용자에게 있습니다.\n의료·법률·투자 등 전문적 판단은 전문가 상담을 이용해 주세요.';

  @override
  String get version => '버전';

  @override
  String get noSavedAnswers => '아직 저장한 답변이 없어요';

  @override
  String get noSavedAnswersSub => '답변 카드에서 저장 버튼을 눌러보세요';

  @override
  String get deleteAll => '전체 삭제';

  @override
  String get deleteAllConfirm => '저장된 답변을 모두 삭제할까요?';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get saveFailed => '저장에 실패했습니다.';

  @override
  String get saveSuccess => '저장되었습니다!';

  @override
  String get purchaseCancelled => '구매가 취소되었습니다.';

  @override
  String get networkError => '네트워크를 확인해 주세요.';

  @override
  String get testMode => '테스트 모드: 실제 결제는 스토어 등록 후 가능합니다.';

  @override
  String get testModeRestore => '테스트 모드: 구매 복원은 스토어 등록 후 가능합니다.';

  @override
  String get purchaseDialogContent =>
      '₩4,990 (영구)\n\n모든 광고를 영구적으로 제거합니다.\n\n※ 현재 테스트 모드입니다.';

  @override
  String get purchaseButton => '구매하기';

  @override
  String get searchingAnswer => '답을 찾고 있어요...';

  @override
  String shareFormat(String question, String answer, String subtext) {
    return 'Q: $question\nA: $answer — $subtext\n\n— 마법의 고민해결책';
  }

  @override
  String get homeInstruction1 => '1. 고민이나 질문을 떠올려보세요.';

  @override
  String get homeInstruction2 => '2. 3초 집중 후, 흔들거나 터치하세요.';

  @override
  String get homeInstruction3 => '3. 마법의 답변이 나타납니다.';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get chinese => '中文';
}
