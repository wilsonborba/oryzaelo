import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/state.dart';

/// Senior UI/UX Engineered Atmospheric Background for Oryza-Elo.
/// Renders an ultra-refined, whispering rice paddy topography (várzea de arroz)
/// designed to elevate and frame foreground cards with impeccable visual hierarchy,
/// serene negative space, and zero visual clutter.
class OryzaAtmosphericBackground extends StatefulWidget {
  final Widget child;
  final bool isDark;
  final OryzaBackgroundStyle style;
  final ScrollController? scrollController;

  const OryzaAtmosphericBackground({
    super.key,
    required this.child,
    required this.isDark,
    this.style = OryzaBackgroundStyle.topographic,
    this.scrollController,
  });

  @override
  State<OryzaAtmosphericBackground> createState() => _OryzaAtmosphericBackgroundState();
}

class _OryzaAtmosphericBackgroundState extends State<OryzaAtmosphericBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_FieldPollenParticle> _particles =
      List.generate(14, (index) => _FieldPollenParticle(index));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
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

  _SeniorRicePaddyTopographyPainter({
    required this.progress,
    required this.scrollOffset,
    required this.particles,
    required this.isDark,
  });

  // Harmonically balanced organic curve representing terraced flooded paddy contours
  double _getContourY(double x, int tier, Size size) {
    final nx = x / size.width;
    final yBase = size.height * (tier * 0.082 - 0.03) - scrollOffset * 0.03;
    final wave1 = sin(nx * 2.4 * pi + tier * 0.45 + progress * 0.4 * pi) * (20.0 + (tier % 3) * 6.0);
    final wave2 = cos(nx * 4.2 * pi + tier * 0.6) * 9.0;
    final wave3 = sin(nx * 1.2 * pi + 1.4) * 12.0;
    return yBase + wave1 + wave2 + wave3;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Base architectural field canvas
    final baseColor = isDark ? const Color(0xFF101410) : const Color(0xFFF9F8F5);
    canvas.drawRect(rect, Paint()..color = baseColor);

    // 2. Spatial Studio Illumination (Soft, wide ambient glow behind content)
    final sunCenter = Offset(size.width * 0.5, size.height * 0.12 - scrollOffset * 0.02);
    final sunRadius = size.width * 0.7;
    final breathe = sin(progress * pi);

    final sunGradient = RadialGradient(
      colors: [
        isDark
            ? OryzaColors.mustardYellow.withValues(alpha: 0.025 + 0.01 * breathe)
            : OryzaColors.mustardYellow.withValues(alpha: 0.035 + 0.012 * breathe),
        isDark ? const Color(0xFF121712).withValues(alpha: 0.005) : Colors.white.withValues(alpha: 0.0),
        Colors.transparent,
      ],
      stops: const [0.0, 0.65, 1.0],
    );
    canvas.drawCircle(
      sunCenter,
      sunRadius,
      Paint()..shader = sunGradient.createShader(Rect.fromCircle(center: sunCenter, radius: sunRadius)),
    );

    // 3. Deep Agronomic Canopy & Earth Depth (Gentle peripheral gradient)
    final mudCenter = Offset(size.width * 0.9, size.height * 0.8 - scrollOffset * 0.025);
    final mudRadius = size.width * 0.6;
    final mudGradient = RadialGradient(
      colors: [
        isDark
            ? OryzaColors.militaryGreen.withValues(alpha: 0.045)
            : OryzaColors.militaryGreen.withValues(alpha: 0.025),
        Colors.transparent,
      ],
      stops: const [0.0, 1.0],
    );
    canvas.drawCircle(
      mudCenter,
      mudRadius,
      Paint()..shader = mudGradient.createShader(Rect.fromCircle(center: mudCenter, radius: mudRadius)),
    );

    // 4. Sinuous Rice Paddy Terraces (Whispering Topography)
    // Clean, elegant, low-contrast hairline contours that frame the cards without distraction.
    const int totalTiers = 14;
    const double stepX = 50.0;

    // A) Extremely subtle terrace wash between alternate terrace tiers
    for (int i = 0; i < totalTiers - 1; i += 2) {
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
        ..color = isDark
            ? const Color(0xFF1B3821).withValues(alpha: 0.04 + 0.01 * breathe)
            : const Color(0xFF4A7C4E).withValues(alpha: 0.015 + 0.005 * breathe);

      canvas.drawPath(basinPath, washPaint);
    }

    // B) Delicate Agronomic Contour Lines
    // Tuned with tasteful opacities: primary at 0.08 / 0.07; secondary at 0.045 / 0.04.
    final primaryLinePaint = Paint()
      ..color = isDark
          ? const Color(0xFF68B270).withValues(alpha: 0.08)
          : const Color(0xFF28502A).withValues(alpha: 0.085)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final secondaryLinePaint = Paint()
      ..color = isDark
          ? const Color(0xFF509658).withValues(alpha: 0.045)
          : const Color(0xFF336035).withValues(alpha: 0.048)
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < totalTiers; i++) {
      final isPrimary = i % 3 == 0;
      final path = Path();
      path.moveTo(0, _getContourY(0, i, size));

      for (double x = stepX; x <= size.width; x += stepX) {
        path.lineTo(x, _getContourY(x, i, size));
      }

      canvas.drawPath(path, isPrimary ? primaryLinePaint : secondaryLinePaint);
    }

    // 5. Airborne Rice Pollen Particles (Gentle, micro-scale, soft)
    _drawPollenParticles(canvas, size);
  }

  void _drawPollenParticles(Canvas canvas, Size size) {
    final particlePaint = Paint()
      ..color = (isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange)
          .withValues(alpha: isDark ? 0.045 : 0.035);

    for (final p in particles) {
      final pos = p.position(size, progress, scrollOffset);
      canvas.drawCircle(pos, p.radius, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SeniorRicePaddyTopographyPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.scrollOffset != scrollOffset ||
        oldDelegate.isDark != isDark;
  }
}

class _FieldPollenParticle {
  _FieldPollenParticle(int seed)
      : _rng = Random(seed * 77 + 13),
        radius = 0.75 + (seed % 3) * 0.35,
        speed = 0.10 + (seed % 4) * 0.025;

  final Random _rng;
  final double radius;
  final double speed;

  Offset position(Size size, double progress, double scrollOffset) {
    final dx = _rng.nextDouble() * size.width;
    final dy = _rng.nextDouble() * size.height;
    final float = sin(progress * pi * 2 + dx * 0.003) * 6 * speed;
    return Offset(dx, (dy + float - scrollOffset * 0.02) % size.height);
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
