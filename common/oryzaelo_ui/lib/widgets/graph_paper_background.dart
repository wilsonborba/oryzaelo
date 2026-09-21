import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/state.dart';

/// Senior UI/UX Engineered Atmospheric Background for Oryza-Elo.
/// Renders an ultra-soft, widely-spaced rice paddy topography (várzea de arroz)
/// focused on the Jingle/Hero section, smoothly fading out into a pure solid background.
class OryzaAtmosphericBackground extends StatefulWidget {
  final Widget child;
  final bool isDark;
  final OryzaBackgroundStyle style;
  final ScrollController? scrollController;
  final bool fadeBottom;

  const OryzaAtmosphericBackground({
    super.key,
    required this.child,
    required this.isDark,
    this.style = OryzaBackgroundStyle.topographic,
    this.scrollController,
    this.fadeBottom = true,
  });

  @override
  State<OryzaAtmosphericBackground> createState() => _OryzaAtmosphericBackgroundState();
}

class _OryzaAtmosphericBackgroundState extends State<OryzaAtmosphericBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_FieldPollenParticle> _particles =
      List.generate(10, (index) => _FieldPollenParticle(index));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listenables = <Listenable>[_controller];
    if (widget.scrollController != null) {
      listenables.add(widget.scrollController!);
    }

    return AnimatedBuilder(
      animation: Listenable.merge(listenables),
      builder: (context, _) {
        final scrollOffset = widget.scrollController?.hasClients == true
            ? widget.scrollController!.offset
            : 0.0;

        return CustomPaint(
          painter: _SeniorRicePaddyTopographyPainter(
            progress: _controller.value,
            scrollOffset: scrollOffset,
            particles: _particles,
            isDark: widget.isDark,
            fadeBottom: widget.fadeBottom,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class _SeniorRicePaddyTopographyPainter extends CustomPainter {
  final double progress;
  final double scrollOffset;
  final List<_FieldPollenParticle> particles;
  final bool isDark;
  final bool fadeBottom;

  _SeniorRicePaddyTopographyPainter({
    required this.progress,
    required this.scrollOffset,
    required this.particles,
    required this.isDark,
    required this.fadeBottom,
  });

  // Smooth vertical fade towards solid color
  double _getFadeMultiplier(int tier, int totalTiers) {
    if (!fadeBottom) return 1.0;
    final t = tier / (totalTiers - 1);
    if (t <= 0.45) return 1.0;
    return (1.0 - (t - 0.45) / 0.50).clamp(0.0, 1.0);
  }

  // Widely spaced, sweeping organic curve representing gentle paddy terraces
  double _getContourY(double x, int tier, Size size) {
    final nx = x / size.width;
    // Generous vertical spacing (~15% height per tier)
    final yBase = size.height * (tier * 0.15 + 0.04) - scrollOffset * 0.03;
    final wave1 = sin(nx * 2.2 * pi + tier * 0.5 + progress * 0.35 * pi) * (18.0 + (tier % 2) * 8.0);
    final wave2 = cos(nx * 3.8 * pi + tier * 0.7) * 8.0;
    final wave3 = sin(nx * 1.1 * pi + 1.2) * 10.0;
    return yBase + wave1 + wave2 + wave3;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Base architectural field canvas (Exact solid background color)
    final baseColor = isDark ? const Color(0xFF101410) : const Color(0xFFF7F6F0);
    canvas.drawRect(rect, Paint()..color = baseColor);

    // 2. Spatial Studio Illumination (Soft, warm ambient glow behind jingle & cards)
    final sunCenter = Offset(size.width * 0.5, size.height * 0.12 - scrollOffset * 0.02);
    final sunRadius = size.width * 0.7;
    final breathe = sin(progress * pi);

    final sunGradient = RadialGradient(
      colors: [
        isDark
            ? OryzaColors.mustardYellow.withValues(alpha: 0.015 + 0.006 * breathe)
            : OryzaColors.mustardYellow.withValues(alpha: 0.028 + 0.008 * breathe),
        isDark ? const Color(0xFF121712).withValues(alpha: 0.002) : Colors.white.withValues(alpha: 0.0),
        Colors.transparent,
      ],
      stops: const [0.0, 0.65, 1.0],
    );
    canvas.drawCircle(
      sunCenter,
      sunRadius,
      Paint()..shader = sunGradient.createShader(Rect.fromCircle(center: sunCenter, radius: sunRadius)),
    );

    // 3. Deep Agronomic Canopy & Earth Depth (Gentle peripheral gradient fading before bottom)
    final mudCenter = Offset(size.width * 0.9, size.height * 0.40 - scrollOffset * 0.02);
    final mudRadius = size.width * 0.55;
    final mudGradient = RadialGradient(
      colors: [
        isDark
            ? OryzaColors.militaryGreen.withValues(alpha: 0.025)
            : OryzaColors.militaryGreen.withValues(alpha: 0.018),
        Colors.transparent,
      ],
      stops: const [0.0, 1.0],
    );
    canvas.drawCircle(
      mudCenter,
      mudRadius,
      Paint()..shader = mudGradient.createShader(Rect.fromCircle(center: mudCenter, radius: mudRadius)),
    );

    // 4. Sinuous Rice Paddy Terraces (Few, widely-spaced, whisper-soft curves)
    const int totalTiers = 6;
    const double stepX = 60.0;

    // A) Ultra-delicate terrace wash in light theme, minimal in dark
    if (!isDark) {
      for (int i = 0; i < totalTiers - 1; i += 2) {
        final fade = _getFadeMultiplier(i, totalTiers);
        if (fade <= 0.001) continue;

        final basinPath = Path();
        basinPath.moveTo(0, _getContourY(0, i, size));

        for (double x = stepX; x <= size.width; x += stepX) {
          basinPath.lineTo(x, _getContourY(x, i, size));
        }
        basinPath.lineTo(size.width, _getContourY(size.width, i, size));
        basinPath.lineTo(size.width, _getContourY(size.width, i + 1, size));

        for (double x = size.width - stepX; x >= 0; x -= stepX) {
          basinPath.lineTo(x, _getContourY(x, i + 1, size));
        }
        basinPath.close();

        final washPaint = Paint()
          ..color = const Color(0xFF4A7C4E).withValues(alpha: 0.008 * fade);

        canvas.drawPath(basinPath, washPaint);
      }
    }

    // B) Delicate Agronomic Contour Lines (Ultra-soft in dark theme, airy in light)
    for (int i = 0; i < totalTiers; i++) {
      final fade = _getFadeMultiplier(i, totalTiers);
      if (fade <= 0.001) continue;

      final isPrimary = i % 2 == 0;
      final path = Path();
      path.moveTo(0, _getContourY(0, i, size));

      for (double x = stepX; x <= size.width; x += stepX) {
        path.lineTo(x, _getContourY(x, i, size));
      }

      final linePaint = Paint()
        ..color = isDark
            ? (isPrimary ? const Color(0xFF68B270) : const Color(0xFF509658))
                .withValues(alpha: (isPrimary ? 0.038 : 0.020) * fade)
            : (isPrimary ? const Color(0xFF28502A) : const Color(0xFF336035))
                .withValues(alpha: (isPrimary ? 0.065 : 0.036) * fade)
        ..strokeWidth = isDark
            ? (isPrimary ? 0.8 : 0.55)
            : (isPrimary ? 0.85 : 0.6)
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, linePaint);
    }

    // 5. Airborne Rice Pollen Particles (Gentle, micro-scale, soft)
    _drawPollenParticles(canvas, size);
  }

  void _drawPollenParticles(Canvas canvas, Size size) {
    final particlePaint = Paint()
      ..color = (isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange)
          .withValues(alpha: isDark ? 0.025 : 0.025);

    for (final p in particles) {
      final pos = p.position(size, progress, scrollOffset);
      if (pos.dy <= size.height * 0.70) {
        canvas.drawCircle(pos, p.radius, particlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SeniorRicePaddyTopographyPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.scrollOffset != scrollOffset ||
        oldDelegate.isDark != isDark ||
        oldDelegate.fadeBottom != fadeBottom;
  }
}

class _FieldPollenParticle {
  _FieldPollenParticle(int seed)
      : _rng = Random(seed * 77 + 13),
        radius = 0.70 + (seed % 3) * 0.3,
        speed = 0.08 + (seed % 4) * 0.02;

  final Random _rng;
  final double radius;
  final double speed;

  Offset position(Size size, double progress, double scrollOffset) {
    final dx = _rng.nextDouble() * size.width;
    final dy = _rng.nextDouble() * size.height;
    final float = sin(progress * pi * 2 + dx * 0.003) * 5 * speed;
    return Offset(dx, (dy + float - scrollOffset * 0.015) % size.height);
  }
}

/// Backward-compatible wrapper for existing callers
class GraphPaperBackground extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const GraphPaperBackground({
    super.key,
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return OryzaAtmosphericBackground(
      isDark: isDark,
      child: child,
    );
  }
}
