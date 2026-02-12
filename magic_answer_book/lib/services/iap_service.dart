/// Stub IAP service for MVP
/// Real implementation requires App Store Connect / Google Play Console setup
class IapService {
  static const String productId = 'remove_ads_forever_4990';
  bool _isAvailable = false;

  bool get isAvailable => _isAvailable;

  Future<void> initialize() async {
    // In production:
    // final available = await InAppPurchase.instance.isAvailable();
    // _isAvailable = available;
    // Listen to purchase stream
    _isAvailable = false; // Stub: IAP not available in dev
  }

  Future<bool> purchaseAdRemoval() async {
    // Stub implementation
    // In production:
    // final response = await InAppPurchase.instance.queryProductDetails({productId});
    // final product = response.productDetails.first;
    // final purchaseParam = PurchaseParam(productDetails: product);
    // return await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    return false;
  }

  Future<void> restorePurchases() async {
    // Stub implementation
    // In production:
    // await InAppPurchase.instance.restorePurchases();
  }

  void dispose() {
    // Clean up subscription streams
  }
}
