import 'dart:io';
import 'package:flutter/foundation.dart';

/// Stub AdMob service for MVP (uses test IDs)
class AdsService {
  bool _isInitialized = false;
  // int _retryCount = 0; // Unused

  DateTime? _lastAdShown;

  bool get isInitialized => _isInitialized;

  // Test Ad IDs
  String get bannerAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/6300978111';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/2934735716';
    return '';
  }

  String get interstitialAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/1033173712';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/4411468910';
    return '';
  }

  Future<void> initialize() async {
    // AdMob initialization would go here
    // await MobileAds.instance.initialize();
    _isInitialized = true;
  }

  bool shouldShowInterstitial(int tryAgainCount, bool isAdFree) {
    if (isAdFree) return false;
    if (kIsWeb) return false;

    // Don't show for first 3 tries
    if (tryAgainCount <= 3) return false;

    // Show every 5 tries
    if (tryAgainCount % 5 != 0) return false;

    // Minimum 60 second interval
    if (_lastAdShown != null) {
      final elapsed = DateTime.now().difference(_lastAdShown!);
      if (elapsed.inSeconds < 60) return false;
    }

    return true;
  }

  void recordAdShown() {
    _lastAdShown = DateTime.now();
  }

  void dispose() {
    // Clean up ad resources
  }
}
