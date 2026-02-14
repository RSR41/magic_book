import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  bool _isInitialized = false;
  DateTime? _lastAdShown;

  InterstitialAd? _interstitialAd;
  bool _isLoadingInterstitial = false;

  bool get isInitialized => _isInitialized;

  String get bannerAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return const String.fromEnvironment('ANDROID_BANNER_AD_UNIT_ID');
    }
    if (Platform.isIOS) {
      return const String.fromEnvironment('IOS_BANNER_AD_UNIT_ID');
    }
    return '';
  }

  String get interstitialAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return const String.fromEnvironment('ANDROID_INTERSTITIAL_AD_UNIT_ID');
    }
    if (Platform.isIOS) {
      return const String.fromEnvironment('IOS_INTERSTITIAL_AD_UNIT_ID');
    }
    return '';
  }

  Future<void> initialize() async {
    if (_isInitialized || kIsWeb) {
      _isInitialized = true;
      return;
    }

    await MobileAds.instance.initialize();
    _isInitialized = true;

    unawaited(loadInterstitialAd());
  }

  bool shouldShowInterstitial(int tryAgainCount, bool isAdFree) {
    if (isAdFree || kIsWeb || !_isInitialized) return false;

    if (tryAgainCount <= 3) return false;
    if (tryAgainCount % 5 != 0) return false;

    if (_lastAdShown != null) {
      final elapsed = DateTime.now().difference(_lastAdShown!);
      if (elapsed.inSeconds < 60) return false;
    }

    return true;
  }

  Future<BannerAd?> loadBannerAd({required bool isAdFree}) async {
    if (isAdFree || kIsWeb || !_isInitialized) return null;
    if (bannerAdUnitId.isEmpty) return null;

    final completer = Completer<BannerAd?>();

    final ad = BannerAd(
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          completer.complete(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd load failed: $error');
          ad.dispose();
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    );

    ad.load();
    return completer.future;
  }

  Future<void> loadInterstitialAd() async {
    if (kIsWeb || !_isInitialized || _isLoadingInterstitial) return;
    if (_interstitialAd != null || interstitialAdUnitId.isEmpty) return;

    _isLoadingInterstitial = true;
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoadingInterstitial = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd load failed: $error');
          _interstitialAd = null;
          _isLoadingInterstitial = false;
        },
      ),
    );
  }

  Future<void> showInterstitialIfEligible({
    required int tryAgainCount,
    required bool isAdFree,
  }) async {
    if (!shouldShowInterstitial(tryAgainCount, isAdFree)) {
      if (_interstitialAd == null) {
        unawaited(loadInterstitialAd());
      }
      return;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      unawaited(loadInterstitialAd());
      return;
    }

    final completer = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _lastAdShown = DateTime.now();
        unawaited(loadInterstitialAd());
        if (!completer.isCompleted) completer.complete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('InterstitialAd show failed: $error');
        ad.dispose();
        _interstitialAd = null;
        unawaited(loadInterstitialAd());
        if (!completer.isCompleted) completer.complete();
      },
    );

    ad.show();
    await completer.future;
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
