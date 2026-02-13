// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '魔法の解決策';

  @override
  String get homeTitle => '悩み解決';

  @override
  String get shakeGuide => 'スマホを振って答えをもらう';

  @override
  String get getAnswerButton => '答えを見る';

  @override
  String get tryAgain => 'もう一度';

  @override
  String get save => '保存';

  @override
  String get share => '共有';

  @override
  String get close => '閉じる';

  @override
  String get history => '履歴';

  @override
  String get settings => '設定';

  @override
  String get home => 'ホーム';

  @override
  String get startButton => '始める';

  @override
  String get introTitle => '魔法の解決策';

  @override
  String get introSubtitle => '悩みがある時、振ってみて';

  @override
  String get disclaimer => '本アプリの回答は娯楽目的です。医療・法律等の専門的判断の代わりにはなりません。';

  @override
  String get vibration => 'バイブレーション';

  @override
  String get vibrationSub => '回答時に振動する';

  @override
  String get shakeDetection => 'シェイク機能';

  @override
  String get shakeDetectionSub => '振って回答を得る';

  @override
  String get sound => 'サウンド';

  @override
  String get soundSub => '回答時の効果音';

  @override
  String get language => '言語';

  @override
  String get general => '一般';

  @override
  String get purchase => '購入';

  @override
  String get info => '情報';

  @override
  String get removeAds => '広告を削除';

  @override
  String get removeAdsComplete => '広告削除済み';

  @override
  String get removeAdsPrice => '¥490 (永久)';

  @override
  String get restorePurchases => '購入の復元';

  @override
  String get restorePurchasesSub => '以前の購入を復元する';

  @override
  String get caution => '注意事項';

  @override
  String get cautionText =>
      '本アプリはエンターテイメント目的です。\n重要な判断は専門家にご相談ください。\n効能や予言を保証するものではありません。';

  @override
  String get licenses => 'オープンソースライセンス';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get privacyPolicyText =>
      '本アプリは個人情報を収集しません。\nすべてのデータは端末内に保存されます。\nオフラインで動作します。';

  @override
  String get termsOfService => '利用規約';

  @override
  String get termsOfServiceText => '回答は娯楽目的で提供されます。\n決定に対する責任は利用者にあります。';

  @override
  String get version => 'バージョン';

  @override
  String get noSavedAnswers => '保存された回答がありません';

  @override
  String get noSavedAnswersSub => '回答を保存してみましょう';

  @override
  String get deleteAll => '全削除';

  @override
  String get deleteAllConfirm => '保存された回答をすべて削除しますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get saveFailed => '保存に失敗しました。';

  @override
  String get saveSuccess => '保存しました！';

  @override
  String get purchaseSuccess => '購入が完了し、広告が削除されました。';

  @override
  String get restoreSuccess => '復元が完了し、広告が削除されました。';

  @override
  String get purchaseFailed => '購入に失敗しました。再試行してください。';

  @override
  String get restoreFailed => '復元できる購入が見つかりませんでした。';

  @override
  String get iapUnavailable => '現在、アプリ内課金を利用できません。';

  @override
  String get purchaseCancelled => '購入がキャンセルされました。';

  @override
  String get networkError => 'ネットワークを確認してください。';

  @override
  String get testMode => 'テストモード: ストア登録後に利用可能です。';

  @override
  String get testModeRestore => 'テストモード: 復元はストア登録後に利用可能です。';

  @override
  String get purchaseDialogContent =>
      '¥490 (永久)\n\n広告を永久に削除します。\n\n※ 現在テストモードです。';

  @override
  String get purchaseButton => '購入する';

  @override
  String get searchingAnswer => '答えを探しています...';

  @override
  String shareFormat(String question, String answer, String subtext) {
    return 'Q: $question\nA: $answer — $subtext\n\n— 魔法の解決策';
  }

  @override
  String get homeInstruction1 => '1. 解決したい悩みや質問を思い浮かべます。';

  @override
  String get homeInstruction2 => '2. 3秒以上集中した後、振るかボタンを押します。';

  @override
  String get homeInstruction3 => '3. あなたが求めていた答えが現れます。';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get chinese => '中文';
}
