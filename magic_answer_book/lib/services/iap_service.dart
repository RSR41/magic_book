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

/// IAP service with test-friendly gateway abstraction.
import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

enum IapActionStatus {
  success,
  cancelled,
  unavailable,
  productNotFound,
  failed,
}

class IapActionResult {
  const IapActionResult(this.status, {this.errorMessage});

  final IapActionStatus status;
  final String? errorMessage;

  bool get isSuccess => status == IapActionStatus.success;
  bool get isNetworkError {
    final message = errorMessage?.toLowerCase() ?? '';
    return message.contains('network') ||
        message.contains('connection') ||
        message.contains('timeout');
  }
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
  IapService({
    IapGateway? gateway,
    bool initialAdFree = false,
    void Function(bool isAdFree)? onAdFreeChanged,
  })  : _gateway = gateway ?? StubIapGateway(),
        _isAdFree = initialAdFree,
        _onAdFreeChanged = onAdFreeChanged;

  static const String productId = 'remove_ads_forever_4990';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  bool _isAvailable = false;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  Completer<IapActionResult>? _pendingActionCompleter;
  final IapGateway _gateway;
  final void Function(bool isAdFree)? _onAdFreeChanged;

  bool _isAvailable = false;
  bool _isAdFree;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  bool _isAvailable = false;
  bool _isInitialized = false;
  ProductDetails? _removeAdsProduct;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  Completer<IapResult>? _pendingPurchaseCompleter;
  bool _isRestoreFlow = false;

  bool get isAvailable => _isAvailable;
  bool get isAdFree => _isAdFree;

  Future<void> initialize() async {
    if (_purchaseSubscription != null) {
      return;
    }

    _isAvailable = await _inAppPurchase.isAvailable();
    _purchaseSubscription =
        _inAppPurchase.purchaseStream.listen(_handlePurchaseUpdates);
  }

  Future<IapActionResult> purchaseAdRemoval() async {
    await initialize();
    if (!_isAvailable) {
      return const IapActionResult(IapActionStatus.unavailable);
    }

    final productResponse =
        await _inAppPurchase.queryProductDetails({productId});

    if (productResponse.error != null) {
      return IapActionResult(
        IapActionStatus.failed,
        errorMessage: productResponse.error!.message,
      );
    }

    if (productResponse.notFoundIDs.contains(productId) ||
        productResponse.productDetails.isEmpty) {
      return const IapActionResult(IapActionStatus.productNotFound);
    }

    final product = productResponse.productDetails.firstWhere(
      (detail) => detail.id == productId,
      orElse: () => productResponse.productDetails.first,
    );

    _pendingActionCompleter = Completer<IapActionResult>();

    final started = await _inAppPurchase.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );

    if (!started) {
      return _completePendingAction(
        const IapActionResult(IapActionStatus.failed),
      );
    }

    return _waitForPendingAction();
  }

  Future<IapActionResult> restorePurchases() async {
    await initialize();
    if (!_isAvailable) {
      return const IapActionResult(IapActionStatus.unavailable);
    }

    _pendingActionCompleter = Completer<IapActionResult>();

    await _inAppPurchase.restorePurchases();

    return _waitForPendingAction();
  }

  Future<IapActionResult> _waitForPendingAction() async {
    final completer = _pendingActionCompleter;
    if (completer == null) {
      return const IapActionResult(IapActionStatus.failed);
    }

    try {
      return await completer.future.timeout(
        const Duration(seconds: 20),
        onTimeout: () => const IapActionResult(IapActionStatus.failed),
      );
    } finally {
      _pendingActionCompleter = null;
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID != productId) {
        continue;
      }

      switch (purchase.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _completePendingAction(
            const IapActionResult(IapActionStatus.success),
          );
          break;
        case PurchaseStatus.error:
          _completePendingAction(
            IapActionResult(
              IapActionStatus.failed,
              errorMessage: purchase.error?.message,
            ),
          );
          break;
        case PurchaseStatus.canceled:
          _completePendingAction(
            const IapActionResult(IapActionStatus.cancelled),
          );
          break;
      }

      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
    }
  }

  IapActionResult _completePendingAction(IapActionResult result) {
    final completer = _pendingActionCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(result);
    }
    return result;
    _isAvailable = true;
  }

  Future<bool> purchaseAdRemoval() async {
    final purchased = await _gateway.purchaseAdRemoval(productId);
    if (purchased) {
      _setAdFree(true);
    }
    return purchased;
  }

  Future<bool> restorePurchases() async {
    final restored = await _gateway.restorePurchases();
    if (restored) {
      _setAdFree(true);
    }
    return restored;
  }

  void _setAdFree(bool value) {
    _isAdFree = value;
    _onAdFreeChanged?.call(value);
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
    _purchaseSubscription = null;
    _pendingPurchaseCompleter = null;
  }

  void dispose() {}
}

