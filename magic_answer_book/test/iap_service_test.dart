import 'package:flutter_test/flutter_test.dart';
import 'package:magic_answer_book/services/iap_service.dart';

class FakeIapGateway implements IapGateway {
  FakeIapGateway({required this.purchaseResult, required this.restoreResult});

  final bool purchaseResult;
  final bool restoreResult;

  @override
  Future<bool> purchaseAdRemoval(String productId) async => purchaseResult;

  @override
  Future<bool> restorePurchases() async => restoreResult;
}

void main() {
  group('IapService', () {
    test('구매 성공 시 isAdFree 상태가 true로 갱신된다', () async {
      var callbackValue = false;
      final service = IapService(
        gateway: FakeIapGateway(purchaseResult: true, restoreResult: false),
        onAdFreeChanged: (isAdFree) => callbackValue = isAdFree,
      );

      final result = await service.purchaseAdRemoval();

      expect(result, isTrue);
      expect(service.isAdFree, isTrue);
      expect(callbackValue, isTrue);
    });

    test('구매 실패 시 isAdFree 상태가 유지된다', () async {
      var callbackCalled = false;
      final service = IapService(
        gateway: FakeIapGateway(purchaseResult: false, restoreResult: false),
        onAdFreeChanged: (_) => callbackCalled = true,
      );

      final result = await service.purchaseAdRemoval();

      expect(result, isFalse);
      expect(service.isAdFree, isFalse);
      expect(callbackCalled, isFalse);
    });

    test('복원 성공 시 isAdFree 상태가 true로 갱신된다', () async {
      final service = IapService(
        gateway: FakeIapGateway(purchaseResult: false, restoreResult: true),
      );

      final result = await service.restorePurchases();

      expect(result, isTrue);
      expect(service.isAdFree, isTrue);
    });
  });
}
