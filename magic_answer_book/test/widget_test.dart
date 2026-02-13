import 'package:flutter_test/flutter_test.dart';
import 'package:magic_answer_book/services/ads_service.dart';

void main() {
  group('AdsService.shouldShowInterstitial', () {
    test('isAdFree=true이면 시도 횟수와 무관하게 항상 false를 반환한다', () {
      final service = AdsService();

      for (var count = 0; count <= 30; count++) {
        expect(service.shouldShowInterstitial(count, true), isFalse);
      }
    });

    test('isAdFree=false일 때 노출 규칙(최소 시도 횟수/5회 주기)을 따른다', () {
      final service = AdsService();

      expect(service.shouldShowInterstitial(3, false), isFalse);
      expect(service.shouldShowInterstitial(4, false), isFalse);
      expect(service.shouldShowInterstitial(5, false), isTrue);
      expect(service.shouldShowInterstitial(6, false), isFalse);
      expect(service.shouldShowInterstitial(10, false), isTrue);
    });
  });
}
