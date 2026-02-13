import 'package:flutter_test/flutter_test.dart';
import 'package:magic_answer_book/models/answer.dart';
import 'package:magic_answer_book/services/ads_service.dart';

void main() {
  group('AdsService.shouldShowInterstitial', () {
    test('returns false for ad-free users', () {
      final service = AdsService();
      expect(service.shouldShowInterstitial(5, true), isFalse);
    });

    test('follows first-tries and modulo policy', () {
      final service = AdsService();

      expect(service.shouldShowInterstitial(1, false), isFalse);
      expect(service.shouldShowInterstitial(3, false), isFalse);
      expect(service.shouldShowInterstitial(4, false), isFalse);
      expect(service.shouldShowInterstitial(5, false), isTrue);
      expect(service.shouldShowInterstitial(10, false), isTrue);
    });

    test('enforces minimum interval after showing an ad', () {
      final service = AdsService();

      expect(service.shouldShowInterstitial(5, false), isTrue);
      service.recordAdShown();
      expect(service.shouldShowInterstitial(10, false), isFalse);
    });
  });

  group('Answer localization fallback', () {
    test('falls back to ko then en when locale is missing', () {
      final answer = Answer(
        id: 'A1',
        tags: const ['go'],
        text: const {
          'ko': '한국어 답변',
          'en': 'english answer',
        },
        subtext: const {
          'en': 'english subtext',
        },
      );

      expect(answer.getLocalizedText('ja'), '한국어 답변');
      expect(answer.getLocalizedSubtext('ja'), 'english subtext');
    });
  });
}
