import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magic_answer_book/l10n/app_localizations.dart';
import 'package:magic_answer_book/providers/providers.dart';
import 'package:magic_answer_book/screens/settings_screen.dart';
import 'package:magic_answer_book/services/iap_service.dart';
import 'package:magic_answer_book/services/storage_service.dart';

class FakeStorageService extends StorageService {
  bool _vibration = true;
  bool _shake = true;
  bool _sound = true;
  String _language = 'ko';
  bool _isAdFree = false;
  bool _hasSeenIntro = false;

  @override
  bool get vibration => _vibration;
  @override
  set vibration(bool value) => _vibration = value;

  @override
  bool get shake => _shake;
  @override
  set shake(bool value) => _shake = value;

  @override
  bool get sound => _sound;
  @override
  set sound(bool value) => _sound = value;

  @override
  String get language => _language;
  @override
  set language(String value) => _language = value;

  @override
  bool get isAdFree => _isAdFree;
  @override
  set isAdFree(bool value) => _isAdFree = value;

  @override
  bool get hasSeenIntro => _hasSeenIntro;
  @override
  set hasSeenIntro(bool value) => _hasSeenIntro = value;
}

class AlwaysSuccessIapGateway implements IapGateway {
  @override
  Future<bool> purchaseAdRemoval(String productId) async => true;

  @override
  Future<bool> restorePurchases() async => true;
}

void main() {
  testWidgets('구매 성공 시 광고 제거 상태와 UI가 함께 갱신된다', (tester) async {
    final fakeStorage = FakeStorageService();
    final container = ProviderContainer(
      overrides: [
        storageServiceProvider.overrideWithValue(fakeStorage),
        iapServiceProvider.overrideWithValue(
          IapService(gateway: AlwaysSuccessIapGateway()),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('ko'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: SettingsScreen()),
        ),
      ),
    );

    await tester.tap(find.byKey(SettingsScreen.removeAdsTileKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(SettingsScreen.purchaseConfirmButtonKey));
    await tester.pumpAndSettle();

    expect(container.read(isAdFreeProvider), isTrue);
    expect(fakeStorage.isAdFree, isTrue);
    expect(find.byKey(SettingsScreen.removeAdsPurchasedIconKey), findsOneWidget);

    final removeAdsTile = tester.widget<ListTile>(
      find.descendant(
        of: find.byKey(SettingsScreen.removeAdsTileKey),
        matching: find.byType(ListTile),
      ),
    );
    expect(removeAdsTile.enabled, isFalse);
  });
}
