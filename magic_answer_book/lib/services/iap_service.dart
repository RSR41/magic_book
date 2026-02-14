import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

abstract class IapGateway {
  Future<bool> purchaseAdRemoval(String productId);
  Future<bool> restorePurchases();
}

class StubIapGateway implements IapGateway {
  @override
  Future<bool> purchaseAdRemoval(String productId) async => false;

  @override
  Future<bool> restorePurchases() async => false;
}

/// In-app purchase service.
/// If [gateway] is supplied, it is used (for tests).
/// Otherwise, it uses the real store APIs via in_app_purchase.
class IapService {
  IapService({
    IapGateway? gateway,
    bool initialAdFree = false,
    void Function(bool isAdFree)? onAdFreeChanged,
  })  : _gateway = gateway,
        _isAdFree = initialAdFree,
        _onAdFreeChanged = onAdFreeChanged;

  static const String productId = 'remove_ads_forever_4990';

  final IapGateway? _gateway;
  final void Function(bool isAdFree)? _onAdFreeChanged;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  bool _isAvailable = false;
  bool _isAdFree;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  Completer<bool>? _pendingCompleter;

  bool get isAvailable => _isAvailable;
  bool get isAdFree => _isAdFree;

  Future<void> initialize() async {
    if (_gateway != null) {
      _isAvailable = true;
      return;
    }

    if (_purchaseSubscription != null) return;
    _isAvailable = await _inAppPurchase.isAvailable();
    if (!_isAvailable) return;
    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (_) => _resolvePending(false),
      onDone: () => _purchaseSubscription?.cancel(),
    );
  }

  Future<bool> purchaseAdRemoval() async {
    if (_gateway != null) {
      final purchased = await _gateway!.purchaseAdRemoval(productId);
      if (purchased) _setAdFree(true);
      return purchased;
    }

    await initialize();
    if (!_isAvailable) return false;

    final productResponse = await _inAppPurchase.queryProductDetails({
      productId,
    });
    if (productResponse.error != null ||
        productResponse.notFoundIDs.contains(productId) ||
        productResponse.productDetails.isEmpty) {
      return false;
    }

    _pendingCompleter = Completer<bool>();
    final started = await _inAppPurchase.buyNonConsumable(
      purchaseParam: PurchaseParam(
        productDetails: productResponse.productDetails.first,
      ),
    );
    if (!started) return _resolvePending(false);

    return _pendingCompleter!.future.timeout(
      const Duration(minutes: 2),
      onTimeout: () => _resolvePending(false),
    );
  }

  Future<bool> restorePurchases() async {
    if (_gateway != null) {
      final restored = await _gateway!.restorePurchases();
      if (restored) _setAdFree(true);
      return restored;
    }

    await initialize();
    if (!_isAvailable) return false;

    _pendingCompleter = Completer<bool>();
    await _inAppPurchase.restorePurchases();
    return _pendingCompleter!.future.timeout(
      const Duration(minutes: 2),
      onTimeout: () => _resolvePending(false),
    );
  }

  void dispose() {
    _purchaseSubscription?.cancel();
    _purchaseSubscription = null;
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID != productId) continue;

      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _setAdFree(true);
          _resolvePending(true);
          break;
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          _resolvePending(false);
          break;
        case PurchaseStatus.pending:
          break;
      }

      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
    }
  }

  bool _resolvePending(bool value) {
    final completer = _pendingCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(value);
    }
    _pendingCompleter = null;
    return value;
  }

  void _setAdFree(bool value) {
    _isAdFree = value;
    _onAdFreeChanged?.call(value);
  }
}
