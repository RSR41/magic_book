import 'dart:async';
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
class AdsService {
  bool _isInitialized = false;
  DateTime? _lastAdShown;

  InterstitialAd? _interstitialAd;
  bool _isLoadingInterstitial = false;

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
  String get bannerAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) return 'ca-app-pub-xxxxxxxxxxxxxxxx/banner_android';
    if (Platform.isIOS) return 'ca-app-pub-xxxxxxxxxxxxxxxx/banner_ios';
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
    if (Platform.isAndroid) {
      return 'ca-app-pub-xxxxxxxxxxxxxxxx/interstitial_android';
    }
    if (Platform.isIOS) return 'ca-app-pub-xxxxxxxxxxxxxxxx/interstitial_ios';
    return '';
  }

  Future<void> initialize() async {
    if (_isInitialized || kIsWeb) {
      _isInitialized = true;
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

  Future<bool> showInterstitialIfEligible({
    required int tryAgainCount,
    required bool isAdFree,
    Duration postResultDelay = const Duration(milliseconds: 700),
  }) async {
    if (!shouldShowInterstitial(tryAgainCount, isAdFree)) {
      return false;
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
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
