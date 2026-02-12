import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

/// Warp-speed starfield animation.
class WaitingOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const WaitingOverlay({super.key, required this.onComplete});

  @override
  State<WaitingOverlay> createState() => _WaitingOverlayState();
}

class _WaitingOverlayState extends State<WaitingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _warpSpeed;
  late Animation<double> _flashOpacity;

  final List<_WarpStar> _stars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 120; i++) {
      _stars.add(_WarpStar(
        angle: _random.nextDouble() * 2 * pi,
        initialDepth: _random.nextDouble() * 0.8 + 0.05,
        speed: _random.nextDouble() * 0.6 + 0.4,
        size: _random.nextDouble() * 1.8 + 0.5,
        colorIndex: _random.nextInt(4),
      ));
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.12, curve: Curves.easeIn),
      ),
    );

    _warpSpeed = Tween<double>(begin: 0.1, end: 3.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.85, curve: Curves.easeIn),
      ),
    );

    _flashOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 60),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.82, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeIn.value.clamp(0.0, 1.0),
          child: Container(
            color: AppTheme.deepBlue.withOpacity(0.95),
            child: Stack(
              children: [
                CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _WarpStarFieldPainter(
                    stars: _stars,
                    progress: _controller.value,
                    warpSpeed: _warpSpeed.value,
                  ),
                ),
                Center(
                  child: Container(
                    width: 80 + _controller.value * 60,
                    height: 80 + _controller.value * 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white
                              .withOpacity(0.15 + _controller.value * 0.25),
                          AppTheme.accentCyan
                              .withOpacity(0.08 + _controller.value * 0.12),
                          AppTheme.accentPurple.withOpacity(0.03),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.25, 0.55, 1.0],
                      ),
                    ),
                  ),
                ),
                if (_flashOpacity.value > 0)
                  Container(
                    color: Colors.white.withOpacity(_flashOpacity.value * 0.8),
                  ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.18,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: (_controller.value < 0.8)
                        ? 1.0
                        : (1.0 - (_controller.value - 0.8) / 0.2)
                            .clamp(0.0, 1.0),
                    child: Text(
                      l.searchingAnswer, // Using localized string
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.dimGray,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
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
}

class _WarpStar {
  final double angle;
  final double initialDepth;
  final double speed;
  final double size;
  final int colorIndex;

  _WarpStar({
    required this.angle,
    required this.initialDepth,
    required this.speed,
    required this.size,
    required this.colorIndex,
  });
}

class _WarpStarFieldPainter extends CustomPainter {
  final List<_WarpStar> stars;
  final double progress;
  final double warpSpeed;

  static const _starColors = [
    Colors.white,
    Color(0xFFB0C4FF),
    Color(0xFFE0D0FF),
    Color(0xFFA0F0E0),
  ];

  _WarpStarFieldPainter({
    required this.stars,
    required this.progress,
    required this.warpSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final maxRadius = sqrt(centerX * centerX + centerY * centerY);

    for (final star in stars) {
      final depth =
          (star.initialDepth + progress * star.speed * warpSpeed) % 1.0;

      final radius = depth * maxRadius;

      final x = centerX + cos(star.angle) * radius;
      final y = centerY + sin(star.angle) * radius;

      if (x < -10 || x > size.width + 10 || y < -10 || y > size.height + 10) {
        continue;
      }

      final sizeMultiplier = 0.3 + depth * 2.5;
      final starSize = star.size * sizeMultiplier;

      final opacityBase = (depth * 1.2).clamp(0.0, 1.0);
      final twinkle = (sin(progress * 12 * pi + star.angle * 3) + 1) / 2;
      final opacity = (opacityBase * (0.6 + twinkle * 0.4)).clamp(0.0, 1.0);

      final color = _starColors[star.colorIndex];

      if (depth > 0.15 && warpSpeed > 0.5) {
        final trailLength = (depth * warpSpeed * 15).clamp(0.0, radius * 0.3);
        final trailStartX = centerX + cos(star.angle) * (radius - trailLength);
        final trailStartY = centerY + sin(star.angle) * (radius - trailLength);

        final trailPaint = Paint()
          ..shader = LinearGradient(
            colors: [
              color.withOpacity(0),
              color.withOpacity(opacity * 0.6),
            ],
          ).createShader(
            Rect.fromPoints(
              Offset(trailStartX, trailStartY),
              Offset(x, y),
            ),
          )
          ..strokeWidth = starSize * 0.6
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(
          Offset(trailStartX, trailStartY),
          Offset(x, y),
          trailPaint,
        );
      }

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), starSize, paint);

      if (starSize > 1.5 && opacity > 0.5) {
        final glowPaint = Paint()
          ..color = color.withOpacity(opacity * 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(Offset(x, y), starSize * 2, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WarpStarFieldPainter oldDelegate) => true;
}
