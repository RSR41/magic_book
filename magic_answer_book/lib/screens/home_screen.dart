import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import '../providers/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/waiting_overlay.dart';
import '../l10n/app_localizations.dart';
import 'result_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  StreamSubscription? _accelerometerSubscription;
  bool _isAnimating = false;
  bool _showResult = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Star animation
  late AnimationController _starController;
  final List<_Star> _stars = [];

  static const double _shakeThreshold = 2.7;
  DateTime _lastShakeTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Initialize stars
    _starController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    final random = Random();
    for (int i = 0; i < 60; i++) {
      _stars.add(_Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2.0 + 1.0,
        opacity: random.nextDouble() * 0.6 + 0.2,
        twinkleSpeed: random.nextDouble() * 1.5 + 0.5,
        twinkleOffset: random.nextDouble() * 2 * pi,
      ));
    }

    _initShakeDetection();
  }

  void _initShakeDetection() {
    _accelerometerSubscription = userAccelerometerEventStream().listen(
      (UserAccelerometerEvent event) {
        final shakeEnabled = ref.read(shakeEnabledProvider);
        if (!shakeEnabled || _isAnimating || _showResult) return;

        final magnitude = sqrt(
          event.x * event.x + event.y * event.y + event.z * event.z,
        );

        if (magnitude > _shakeThreshold * 9.8) {
          final now = DateTime.now();
          if (now.difference(_lastShakeTime).inMilliseconds > 1000) {
            _lastShakeTime = now;
            _triggerAnswer();
          }
        }
      },
      onError: (error) {},
    );
  }

  void _triggerAnswer() {
    if (_isAnimating || _showResult) return;

    setState(() {
      _isAnimating = true;
      _showResult = false;
    });

    if (ref.read(vibrationProvider)) {
      HapticFeedback.mediumImpact();
    }

    final answersService = ref.read(answersServiceProvider);
    final answer = answersService.getRandomAnswer();
    ref.read(currentAnswerProvider.notifier).state = answer;
    ref.read(currentQuestionProvider.notifier).state = '';

    final storage = ref.read(storageServiceProvider);
    storage.totalAnswersCount = storage.totalAnswersCount + 1;
  }

  void _onAnimationComplete() {
    setState(() {
      _isAnimating = false;
      _showResult = true;
    });
  }

  void _onResultDismiss() {
    setState(() {
      _showResult = false;
    });
  }

  void _onTryAgain() {
    setState(() {
      _showResult = false;
    });
    ref.read(tryAgainCountProvider.notifier).state++;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _triggerAnswer();
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _pulseController.dispose();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Stack(
      children: [
        // Background Image + Gradient Overlay
        Container(
          decoration: const BoxDecoration(
            color: AppTheme.deepBlue,
            image: DecorationImage(
              image: AssetImage('assets/images/home_background.png'),
              fit: BoxFit.cover,
              opacity: 0.6, // Dim the background slightly
            ),
          ),
        ),

        // Stars Layer
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

        // Main Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Instructions
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.accentPurple.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInstructionItem(l.homeInstruction1),
                      const SizedBox(height: 12),
                      _buildInstructionItem(l.homeInstruction2),
                      const SizedBox(height: 12),
                      _buildInstructionItem(l.homeInstruction3),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // Magic Button
                _buildMagicButton(l),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ),

        if (_isAnimating) WaitingOverlay(onComplete: _onAnimationComplete),
        if (_showResult)
          ResultScreen(
            onTryAgain: _onTryAgain,
            onDismiss: _onResultDismiss,
          ),
      ],
    );
  }

  Widget _buildInstructionItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4, right: 10),
          child: Icon(Icons.auto_awesome, size: 12, color: AppTheme.accentCyan),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.starWhite,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMagicButton(AppLocalizations l) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: GestureDetector(
            onTap: _isAnimating ? null : _triggerAnswer,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage('assets/images/magic_button.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentPurple.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: AppTheme.accentCyan.withOpacity(0.3),
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                // Fallback text/icon if image fails or for added clarity
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // If image is missing, this icon shows.
                    // If image is present, this sits on top (optional, can remove if image is self-explanatory)
                    // The user asked for "magical image", so I'll keep text minimal or remove it.
                    // But for accessibility/fallback, I'll keep a transparent hit area or subtle glow.
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
      final currentOpacity = star.opacity * (0.5 + twinkle * 0.5);

      final paint = Paint()
        ..color = Colors.white.withOpacity(currentOpacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size * (0.8 + twinkle * 0.2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => true;
}
