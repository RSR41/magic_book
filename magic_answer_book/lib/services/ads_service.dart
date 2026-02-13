import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService extends ChangeNotifier {
  bool _isInitialized = false;
  bool _isAdFree = false;

  DateTime? _lastAdShown;

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;

  bool get isInitialized => _isInitialized;
  BannerAd? get bannerAd => _bannerAd;
  bool get hasBannerAd => _bannerAd != null;

  String get _bannerAdUnitId {
    if (kIsWeb) return '';

    if (!kReleaseMode) {
      if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/6300978111';
      if (Platform.isIOS) return 'ca-app-pub-3940256099942544/2934735716';
      return '';
    }

    if (Platform.isAndroid) {
      return const String.fromEnvironment('ANDROID_BANNER_AD_UNIT_ID');
    }
    if (Platform.isIOS) {
      return const String.fromEnvironment('IOS_BANNER_AD_UNIT_ID');
    }
    return '';
  }

  String get _interstitialAdUnitId {
    if (kIsWeb) return '';

    if (!kReleaseMode) {
      if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/1033173712';
      if (Platform.isIOS) return 'ca-app-pub-3940256099942544/4411468910';
      return '';
    }

    if (Platform.isAndroid) {
      return const String.fromEnvironment('ANDROID_INTERSTITIAL_AD_UNIT_ID');
    }
    if (Platform.isIOS) {
      return const String.fromEnvironment('IOS_INTERSTITIAL_AD_UNIT_ID');
    }
    return '';
  }

  Future<void> initialize({required bool isAdFree}) async {
    _isAdFree = isAdFree;

    if (_isAdFree || kIsWeb || _isInitialized) {
      return;
    }

    await MobileAds.instance.initialize();
    _isInitialized = true;

    loadBannerAd();
    loadInterstitialAd();
  }

  void updateAdFreeStatus(bool isAdFree) {
    _isAdFree = isAdFree;

    if (_isAdFree) {
      _disposeBanner();
      _disposeInterstitial();
      notifyListeners();
      return;
    }

    if (_isInitialized) {
      loadBannerAd();
      loadInterstitialAd();
    }
  }

  void loadBannerAd() {
    if (!_canLoadAds || _bannerAd != null) return;

    final adUnitId = _bannerAdUnitId;
    if (adUnitId.isEmpty) return;

    final ad = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
          debugPrint('Banner ad failed to load: $error');
          notifyListeners();
        },
      ),
    );

    ad.load();
  }

  void loadInterstitialAd() {
    if (!_canLoadAds || _interstitialAd != null || _isInterstitialLoading) {
      return;
    }

    final adUnitId = _interstitialAdUnitId;
    if (adUnitId.isEmpty) return;

    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isInterstitialLoading = false;
          _interstitialAd = ad;
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Interstitial failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoading = false;
          _interstitialAd = null;
          debugPrint('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  bool shouldShowInterstitial(int tryAgainCount, bool isAdFree) {
    if (isAdFree || _isAdFree) return false;
    if (kIsWeb) return false;

    if (tryAgainCount <= 3) return false;
    if (tryAgainCount % 5 != 0) return false;

    if (_lastAdShown != null) {
      final elapsed = DateTime.now().difference(_lastAdShown!);
      if (elapsed.inSeconds < 60) return false;
    }

    return true;
  }

  Future<bool> showInterstitialIfEligible({
    required int tryAgainCount,
    required bool isAdFree,
    Duration postResultDelay = const Duration(milliseconds: 700),
  }) async {
    if (!shouldShowInterstitial(tryAgainCount, isAdFree)) {
      return false;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      loadInterstitialAd();
      return false;
    }

    if (postResultDelay > Duration.zero) {
      await Future.delayed(postResultDelay);
    }

    ad.show();
    recordAdShown();
    return true;
  }

  void recordAdShown() {
    _lastAdShown = DateTime.now();
  }

  bool get _canLoadAds => !_isAdFree && _isInitialized && !kIsWeb;

  void _disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  void _disposeInterstitial() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialLoading = false;
  }

  @override
  void dispose() {
    _disposeBanner();
    _disposeInterstitial();
    super.dispose();
  }
}
