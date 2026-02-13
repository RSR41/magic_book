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
class IapService {
  IapService({
    IapGateway? gateway,
    bool initialAdFree = false,
    void Function(bool isAdFree)? onAdFreeChanged,
  })  : _gateway = gateway ?? StubIapGateway(),
        _isAdFree = initialAdFree,
        _onAdFreeChanged = onAdFreeChanged;

  static const String productId = 'remove_ads_forever_4990';

  final IapGateway _gateway;
  final void Function(bool isAdFree)? _onAdFreeChanged;

  bool _isAvailable = false;
  bool _isAdFree;

  bool get isAvailable => _isAvailable;
  bool get isAdFree => _isAdFree;

  Future<void> initialize() async {
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
  }

  void dispose() {}
}
