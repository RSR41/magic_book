import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

enum IapResultStatus {
  success,
  restored,
  canceled,
  networkError,
  failed,
  unavailable,
}

class IapResult {
  const IapResult(this.status);

  final IapResultStatus status;

  bool get isSuccess =>
      status == IapResultStatus.success || status == IapResultStatus.restored;
}

class IapService {
  static const String productId = 'remove_ads_forever_4990';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  bool _isAvailable = false;
  bool _isInitialized = false;
  ProductDetails? _removeAdsProduct;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  Completer<IapResult>? _pendingPurchaseCompleter;
  bool _isRestoreFlow = false;

  bool get isAvailable => _isAvailable;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _isAvailable = await _inAppPurchase.isAvailable();
    if (!_isAvailable) {
      _isInitialized = true;
      return;
    }

    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (_) => _resolvePendingResult(IapResultStatus.failed),
      onDone: () => _purchaseSubscription?.cancel(),
    );

    await _loadProductDetails();
    _isInitialized = true;
  }

  Future<IapResult> purchaseAdRemoval() async {
    await initialize();
    if (!_isAvailable) {
      return const IapResult(IapResultStatus.unavailable);
    }

    if (_removeAdsProduct == null && !(await _loadProductDetails())) {
      return const IapResult(IapResultStatus.failed);
    }

    _isRestoreFlow = false;
    _pendingPurchaseCompleter = Completer<IapResult>();

    final didStartPurchase = await _inAppPurchase.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: _removeAdsProduct!),
    );

    if (!didStartPurchase) {
      _pendingPurchaseCompleter = null;
      return const IapResult(IapResultStatus.failed);
    }

    return _pendingPurchaseCompleter!.future.timeout(
      const Duration(minutes: 2),
      onTimeout: () => const IapResult(IapResultStatus.failed),
    );
  }

  Future<IapResult> restorePurchases() async {
    await initialize();
    if (!_isAvailable) {
      return const IapResult(IapResultStatus.unavailable);
    }

    _isRestoreFlow = true;
    _pendingPurchaseCompleter = Completer<IapResult>();

    await _inAppPurchase.restorePurchases();

    return _pendingPurchaseCompleter!.future.timeout(
      const Duration(minutes: 2),
      onTimeout: () => const IapResult(IapResultStatus.failed),
    );
  }

  Future<bool> _loadProductDetails() async {
    final response = await _inAppPurchase.queryProductDetails({productId});
    if (response.error != null || response.notFoundIDs.contains(productId)) {
      return false;
    }

    for (final product in response.productDetails) {
      if (product.id == productId) {
        _removeAdsProduct = product;
        return true;
      }
    }

    return false;
  }

  Future<void> _handlePurchaseUpdates(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.productID != productId) {
        continue;
      }

      switch (purchaseDetails.status) {
        case PurchaseStatus.purchased:
          _resolvePendingResult(IapResultStatus.success);
          break;
        case PurchaseStatus.restored:
          _resolvePendingResult(IapResultStatus.restored);
          break;
        case PurchaseStatus.error:
          _resolvePendingResult(_mapErrorToStatus(purchaseDetails.error));
          break;
        case PurchaseStatus.canceled:
          _resolvePendingResult(IapResultStatus.canceled);
          break;
        case PurchaseStatus.pending:
          continue;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  IapResultStatus _mapErrorToStatus(IAPError? error) {
    final code = error?.code.toLowerCase() ?? '';
    final message = error?.message.toLowerCase() ?? '';

    if (code.contains('network') ||
        code.contains('connection') ||
        message.contains('network') ||
        message.contains('connection')) {
      return IapResultStatus.networkError;
    }

    if (code.contains('cancel')) {
      return IapResultStatus.canceled;
    }

    return IapResultStatus.failed;
  }

  void _resolvePendingResult(IapResultStatus status) {
    final completer = _pendingPurchaseCompleter;
    if (completer == null || completer.isCompleted) {
      return;
    }

    if (_isRestoreFlow && status == IapResultStatus.success) {
      completer.complete(const IapResult(IapResultStatus.restored));
    } else {
      completer.complete(IapResult(status));
    }

    _pendingPurchaseCompleter = null;
  }

  void dispose() {
    _purchaseSubscription?.cancel();
    _pendingPurchaseCompleter = null;
  }
}
