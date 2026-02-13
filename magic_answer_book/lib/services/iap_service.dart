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
}

class IapService {
  static const String productId = 'remove_ads_forever_4990';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  bool _isAvailable = false;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  Completer<IapActionResult>? _pendingActionCompleter;

  bool get isAvailable => _isAvailable;

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
  }

  void dispose() {
    _purchaseSubscription?.cancel();
    _purchaseSubscription = null;
  }
}

