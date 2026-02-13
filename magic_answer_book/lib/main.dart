import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'l10n/app_localizations.dart';
import 'providers/providers.dart';
import 'screens/home_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/settings_screen.dart';
import 'services/ads_service.dart';
import 'services/answers_service.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppTheme.deepBlue,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  final storageService = StorageService();
  await storageService.init();

  final answersService = AnswersService();
  await answersService.loadAnswers();

  final adsService = AdsService();
  await adsService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
        answersServiceProvider.overrideWithValue(answersService),
        adsServiceProvider.overrideWithValue(adsService),
      ],
      child: const MagicAnswerBookApp(),
    ),
  );
}

class MagicAnswerBookApp extends ConsumerWidget {
  const MagicAnswerBookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    return MaterialApp(
      title: '우주의 기운',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: Locale(language),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko'),
        Locale('en'),
        Locale('ja'),
        Locale('zh'),
      ],
      home: const AppNavigator(),
    );
  }
}

class AppNavigator extends ConsumerStatefulWidget {
  const AppNavigator({super.key});

  @override
  ConsumerState<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends ConsumerState<AppNavigator> {
  bool _showIntro = false;

  @override
  void initState() {
    super.initState();
    _showIntro = !ref.read(hasSeenIntroProvider);
  }

  void _onIntroComplete() {
    final storage = ref.read(storageServiceProvider);
    storage.hasSeenIntro = true;
    ref.read(hasSeenIntroProvider.notifier).state = true;
    setState(() {
      _showIntro = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showIntro) {
      return IntroScreen(onStart: _onIntroComplete);
    }
    return const MainTabScreen();
  }
}

class MainTabScreen extends ConsumerStatefulWidget {
  const MainTabScreen({super.key});

  @override
  ConsumerState<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends ConsumerState<MainTabScreen> {
  int _currentIndex = 0;
  BannerAd? _bannerAd;
  ProviderSubscription<bool>? _isAdFreeSubscription;

  final List<Widget> _screens = const [
    HomeScreen(),
    SavedScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadBannerAdIfNeeded(ref.read(isAdFreeProvider));

    _isAdFreeSubscription = ref.listenManual<bool>(isAdFreeProvider, (previous, next) {
      if (next) {
        _disposeBanner();
      } else {
        _loadBannerAdIfNeeded(false);
      }
    });
  }

  Future<void> _loadBannerAdIfNeeded(bool isAdFree) async {
    if (isAdFree || _bannerAd != null) return;

    final adsService = ref.read(adsServiceProvider);
    final ad = await adsService.loadBannerAd(isAdFree: isAdFree);
    if (!mounted || ad == null) return;

    setState(() {
      _bannerAd = ad;
    });
  }

  void _disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _isAdFreeSubscription?.close();
    _disposeBanner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isAdFree = ref.watch(isAdFreeProvider);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isAdFree && _bannerAd != null)
            Container(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              color: AppTheme.midBlue,
              child: AdWidget(ad: _bannerAd!),
            ),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.midBlue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      assetPath: 'assets/images/icon_home.png',
                      label: l.home,
                      index: 0,
                    ),
                    _buildNavItem(
                      assetPath: 'assets/images/icon_history.png',
                      label: l.history,
                      index: 1,
                    ),
                    _buildNavItem(
                      assetPath: 'assets/images/icon_settings.png',
                      label: l.settings,
                      index: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String assetPath,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentPurple.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: isSelected ? 1.0 : 0.5,
              child: Image.asset(
                assetPath,
                width: 28,
                height: 28,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppTheme.accentPurple : AppTheme.dimGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
