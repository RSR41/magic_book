// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '魔法解答书';

  @override
  String get homeTitle => '解答烦恼';

  @override
  String get shakeGuide => '摇一摇获取答案';

  @override
  String get getAnswerButton => '获取答案';

  @override
  String get tryAgain => '再试一次';

  @override
  String get save => '保存';

  @override
  String get share => '分享';

  @override
  String get close => '关闭';

  @override
  String get history => '历史';

  @override
  String get settings => '设置';

  @override
  String get home => '首页';

  @override
  String get startButton => '开始';

  @override
  String get introTitle => '魔法解答书';

  @override
  String get introSubtitle => '有烦恼时，摇一摇';

  @override
  String get disclaimer => '本应用仅供娱乐，不能替代医疗、法律等专业建议。';

  @override
  String get vibration => '震动';

  @override
  String get vibrationSub => '获取答案时震动';

  @override
  String get shakeDetection => '摇一摇功能';

  @override
  String get shakeDetectionSub => '摇动手机获取答案';

  @override
  String get sound => '音效';

  @override
  String get soundSub => '获取答案时的音效';

  @override
  String get language => '语言';

  @override
  String get general => '常规';

  @override
  String get purchase => '购买';

  @override
  String get info => '信息';

  @override
  String get removeAds => '移除广告';

  @override
  String get removeAdsComplete => '已移除广告';

  @override
  String get removeAdsPrice => '¥30.00 (永久)';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get restorePurchasesSub => '恢复之前的购买记录';

  @override
  String get caution => '注意事项';

  @override
  String get cautionText => '本应用仅供娱乐。\n重要决定请咨询专家。\n不保证功效或预言准确性。';

  @override
  String get licenses => '开源许可证';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get privacyPolicyText => '本应用不收集个人信息。\n所有数据仅保存在本地。\n可离线使用。';

  @override
  String get termsOfService => '服务条款';

  @override
  String get termsOfServiceText => '回答仅供娱乐参考。\n用户需对基于回答做出的决定负责。';

  @override
  String get version => '版本';

  @override
  String get noSavedAnswers => '还没有保存的答案';

  @override
  String get noSavedAnswersSub => '试着保存一个答案吧';

  @override
  String get deleteAll => '删除所有';

  @override
  String get deleteAllConfirm => '确定要删除所有保存的答案吗？';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get saveFailed => '保存失败。';

  @override
  String get saveSuccess => '已保存！';

  @override
  String get purchaseSuccess => '购买完成，广告已移除。';

  @override
  String get restoreSuccess => '恢复完成，广告已移除。';

  @override
  String get purchaseFailed => '购买失败，请重试。';

  @override
  String get restoreFailed => '未找到可恢复的购买记录。';

  @override
  String get iapUnavailable => '当前无法使用应用内购买。';

  @override
  String get purchaseCancelled => '购买已取消。';

  @override
  String get networkError => '请检查网络连接。';

  @override
  String get testMode => '测试模式：上架后可用。';

  @override
  String get testModeRestore => '测试模式：上架后可用恢复功能。';

  @override
  String get purchaseDialogContent => '¥30.00 (永久)\n\n永久移除所有广告。\n\n※ 当前为测试模式。';

  @override
  String get purchaseButton => '购买';

  @override
  String get searchingAnswer => '正在寻找答案...';

  @override
  String shareFormat(String question, String answer, String subtext) {
    return 'Q: $question\nA: $answer — $subtext\n\n— 魔法解答书';
  }

  @override
  String get homeInstruction1 => '1. 此时心中想着你的烦恼或问题。';

  @override
  String get homeInstruction2 => '2. 专注3秒以上，然后摇晃手机或点击按钮。';

  @override
  String get homeInstruction3 => '3. 你想要的答案将会出现。';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get chinese => '中文';
}
