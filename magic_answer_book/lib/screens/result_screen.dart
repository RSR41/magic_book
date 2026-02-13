import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final VoidCallback onTryAgain;
  final VoidCallback onDismiss;

  const ResultScreen({
    super.key,
    required this.onTryAgain,
    required this.onDismiss,
  });

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scaleUp = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveAnswer() async {
    final answer = ref.read(currentAnswerProvider);
    final question = ref.read(currentQuestionProvider);
    if (answer == null) return;

    final l = AppLocalizations.of(context)!;
    final success = await ref
        .read(savedAnswersProvider.notifier)
        .saveAnswer(answer, question);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? l.saveSuccess : l.saveFailed,
            style: GoogleFonts.cinzelDecorative(),
          ),
          backgroundColor: AppTheme.accentPurple.withOpacity(0.9),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _shareAnswer() {
    final answer = ref.read(currentAnswerProvider);
    final question = ref.read(currentQuestionProvider);
    final locale = ref.read(languageProvider);
    if (answer == null) return;

    final l = AppLocalizations.of(context)!;
    final text = l.shareFormat(
      question,
      answer.getLocalizedText(locale),
      answer.getLocalizedSubtext(locale),
    );
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final answer = ref.watch(currentAnswerProvider);
    final locale = ref.watch(languageProvider);
    final l = AppLocalizations.of(context)!;

    if (answer == null) return const SizedBox.shrink();

    // Magical Text Style
    final answerStyle = GoogleFonts.cinzelDecorative(
      fontSize: 28, // Reduced from 32
      fontWeight: FontWeight.w900,
      color: const Color(0xFF2E1A47),
      height: 1.3, // Slightly tighter line height
      shadows: [
         Shadow(
          color: Colors.white.withOpacity(0.8),
          blurRadius: 10,
          offset: const Offset(0, 0),
        ),
      ],
    );

    final subtextStyle = GoogleFonts.cinzelDecorative(
      fontSize: 15, // Reduced from 18
      fontWeight: FontWeight.w700,
      color: const Color(0xFF4A3B69),
      height: 1.3,
      shadows: [
        Shadow(color: Colors.white.withOpacity(0.5), blurRadius: 2),
      ],
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeIn.value,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // 1. Background Image (Magic Book)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/result_book_bg.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.deepBlue.withOpacity(0.95),
                      );
                    },
                  ),
                ),

                // 2. Twinkling Stars Overlay (Multiple instances)
                const Positioned.fill(child: _TwinklingStars(count: 50)),

                // 3. Main Content
                SafeArea(
                  child: Transform.scale(
                    scale: _scaleUp.value,
                    child: Column(
                      children: [
                        // Close button
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 24),
                              ),
                              onPressed: widget.onDismiss,
                            ),
                          ),
                        ),

                        const Spacer(
                            flex:
                                5), // Reduced from 7 to move text UP

                        // Answer Text Area
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                answer.getLocalizedText(locale),
                                textAlign: TextAlign.center,
                                style: answerStyle,
                              ),
                              const SizedBox(height: 10), // Reduced from 16
                              Text(
                                answer.getLocalizedSubtext(locale),
                                textAlign: TextAlign.center,
                                style: subtextStyle,
                              ),
                            ],
                          ),
                        ),

                        const Spacer(flex: 8), // Increased from 6 to balance the move

                        // Action Buttons (Moved up)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Save Button
                              _buildImageButton(
                                assetPath: 'assets/images/button_save.png',
                                label: l.save,
                                onTap: _saveAnswer,
                                fallbackIcon: Icons.bookmark_outline,
                                scale: 1.1,
                              ),
                              const SizedBox(width: 20),

                              // Main Retry Button
                              _buildImageButton(
                                assetPath: 'assets/images/button_retry.png',
                                label: l.tryAgain,
                                onTap: widget.onTryAgain,
                                fallbackIcon: Icons.refresh_rounded,
                                isMain: true,
                                scale: 1.2,
                              ),
                              const SizedBox(width: 20),

                              // Share Button
                              _buildImageButton(
                                assetPath: 'assets/images/button_share.png',
                                label: l.share,
                                onTap: _shareAnswer,
                                fallbackIcon: Icons.share_outlined,
                                scale: 1.1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageButton({
    required String assetPath,
    required String label,
    required VoidCallback onTap,
    required IconData fallbackIcon,
    bool isMain = false,
    double scale = 1.0,
  }) {
    // Magical Font for Buttons
    final labelStyle = GoogleFonts.cinzelDecorative(
      fontSize: isMain ? 16 : 14,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFFFD700), // Gold color
      shadows: [
        const Shadow(color: Colors.black, blurRadius: 4, offset: Offset(1, 1)),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isMain ? 180 : 64,
              height: 64,
              decoration: isMain ? null : const BoxDecoration(),
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: isMain
                          ? AppTheme.accentCyan
                          : AppTheme.cardDark.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppTheme.accentPurple.withOpacity(0.5)),
                    ),
                    child: Center(
                      child: isMain
                          ? Text(label,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))
                          : Icon(fallbackIcon,
                              color: AppTheme.starWhite, size: 28),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            Text(label, style: labelStyle),
          ],
        ),
      ),
    );
  }
}

// Twinkling Star Widget
class _TwinklingStars extends StatelessWidget {
  final int count;

  const _TwinklingStars({this.count = 10});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(count, (index) {
        return _SingleStar(key: ValueKey(index));
      }),
    );
  }
}

class _SingleStar extends StatefulWidget {
  const _SingleStar({super.key});

  @override
  State<_SingleStar> createState() => _SingleStarState();
}

class _SingleStarState extends State<_SingleStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  // Random properties
  late double _left;
  late double _top;
  late double _size;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _randomizeProperties();

    _controller = AnimationController(
        duration: Duration(
            milliseconds:
                500 + _random.nextInt(1500)), // Random loop duration (Faster)
        vsync: this);

    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start with random delay
    Future.delayed(Duration(milliseconds: _random.nextInt(1000)), () {
      if (mounted) _controller.repeat();
    });
  }

  void _randomizeProperties() {
    _left =
        _random.nextDouble() * 1.0 - 0.5; // Horizontal alignment (-0.5 to 0.5)
    _top = _random.nextDouble() * 0.6 - 0.1; // Vertical alignment (-0.1 to 0.5)
    _size = 20 + _random.nextDouble() * 30; // Random size 20-50
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(_left, _top),
      child: AnimatedBuilder(
        animation: _opacity,
        builder: (context, child) {
          return Opacity(
            opacity: _opacity.value,
            child: Image.asset(
              'assets/images/decoration_stars.png',
              width: _size,
              height: _size,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
