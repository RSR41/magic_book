import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/providers.dart';

class IntroScreen extends ConsumerStatefulWidget {
  final VoidCallback onStart;

  const IntroScreen({super.key, required this.onStart});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen>
    with TickerProviderStateMixin {
  // ... (animations) ...
  late AnimationController _starController;
  late AnimationController _titleController;
  late AnimationController _buttonController;
  late Animation<double> _titleFade;
  late Animation<double> _titleSlide;
  late Animation<double> _buttonFade;
  late Animation<double> _buttonScale;

  final List<_Star> _stars = [];

  @override
  void initState() {
    super.initState();
    // ... (init logic same) ...
    final random = Random();
    for (int i = 0; i < 80; i++) {
      _stars.add(_Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2.5 + 0.5,
        opacity: random.nextDouble() * 0.7 + 0.3,
        twinkleSpeed: random.nextDouble() * 2 + 1,
        twinkleOffset: random.nextDouble() * 2 * pi,
      ));
    }

    _starController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _titleController,
          curve: const Interval(0, 0.6, curve: Curves.easeOut)),
    );
    _titleSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
          parent: _titleController,
          curve: const Interval(0, 0.6, curve: Curves.easeOut)),
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );
    _buttonScale = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _titleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _starController.dispose();
    _titleController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
                color: Colors.black
                    .withOpacity(0.3)), // Dark overlay for readability
            AnimatedBuilder(
              animation: _starController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _StarPainter(
                    stars: _stars,
                    time: _starController.value,
                  ),
                );
              },
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3),
                    const Spacer(flex: 3),
                    // Removed star icon per user request
                    const SizedBox(height: 80),
                    const SizedBox(height: 40),
                    AnimatedBuilder(
                      animation: _titleController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _titleFade.value,
                          child: Transform.translate(
                            offset: Offset(0, _titleSlide.value),
                            child: Column(
                              children: [
                                Text(
                                  l.introTitle,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.starWhite,
                                    letterSpacing: 1.2,
                                    shadows: [
                                      Shadow(
                                        color: AppTheme.accentPurple
                                            .withOpacity(0.5),
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l.introSubtitle,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.dimGray,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const Spacer(flex: 2),
                    AnimatedBuilder(
                      animation: _buttonController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _buttonFade.value,
                          child: Transform.scale(
                            scale: _buttonScale.value,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              decoration: BoxDecoration(
                                gradient: AppTheme.ctaGradient,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppTheme.accentPurple.withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    ref
                                        .read(soundServiceProvider)
                                        .playSfx('sfx_button.wav');
                                    widget.onStart();
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 48, vertical: 18),
                                    child: Center(
                                      child: Text(
                                        l.startButton,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double twinkleSpeed;
  final double twinkleOffset;

  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.twinkleSpeed,
    required this.twinkleOffset,
  });
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double time;

  _StarPainter({required this.stars, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final twinkle =
          (sin(time * star.twinkleSpeed * 2 * pi + star.twinkleOffset) + 1) / 2;
      final paint = Paint()
        ..color = Colors.white.withOpacity(star.opacity * (0.3 + twinkle * 0.7))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size * (0.8 + twinkle * 0.2),
        paint,
      );

      if (star.size > 1.5) {
        final glowPaint = Paint()
          ..color = Colors.white.withOpacity(star.opacity * twinkle * 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(
          Offset(star.x * size.width, star.y * size.height),
          star.size * 2,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => true;
}
