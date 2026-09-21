import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/state.dart';

/// Redesigned Spatial & Atmospheric Background for Oryza-Elo.
/// Replaces dense graph-paper grids with breathing studio illumination,
/// subtle microclimatic depth, and optional Swiss engineering dot matrix.
class OryzaAtmosphericBackground extends StatefulWidget {
  final Widget child;
  final bool isDark;
  final OryzaBackgroundStyle style;
  final ScrollController? scrollController;

  const OryzaAtmosphericBackground({
    super.key,
    required this.child,
    required this.isDark,
    this.style = OryzaBackgroundStyle.atmospheric,
    this.scrollController,
  });

  @override
  State<OryzaAtmosphericBackground> createState() => _OryzaAtmosphericBackgroundState();
}

class _OryzaAtmosphericBackgroundState extends State<OryzaAtmosphericBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_FieldPollenParticle> _particles =
      List.generate(18, (index) => _FieldPollenParticle(index));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
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
          painter: _OryzaAtmosphericPainter(
            progress: _controller.value,
            scrollOffset: scrollOffset,
            particles: _particles,
            isDark: widget.isDark,
            style: widget.style,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class _OryzaAtmosphericPainter extends CustomPainter {
  final double progress;
  final double scrollOffset;
  final List<_FieldPollenParticle> particles;
  final bool isDark;
  final OryzaBackgroundStyle style;

  _OryzaAtmosphericPainter({
    required this.progress,
    required this.scrollOffset,
    required this.particles,
    required this.isDark,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Base architectural canvas fill
    final baseColor = isDark ? const Color(0xFF101510) : const Color(0xFFFAF8F5);
    canvas.drawRect(rect, Paint()..color = baseColor);

    // 2. Spatial Studio Illumination (Top-center warm breathing glow)
    final spotlightCenter = Offset(
      size.width * 0.5,
      size.height * 0.12 - scrollOffset * 0.04,
    );
    final spotlightRadius = size.width * 0.65;
    final breathe = sin(progress * pi);

    final spotlightColor = isDark
        ? OryzaColors.mustardYellow.withValues(alpha: 0.035 + 0.015 * breathe)
        : OryzaColors.mustardYellow.withValues(alpha: 0.04 + 0.012 * breathe);

    final spotlightGradient = RadialGradient(
      center: Alignment.center,
      radius: 0.85,
      colors: [
        spotlightColor,
        isDark
            ? const Color(0xFF141914).withValues(alpha: 0.01)
            : Colors.white.withValues(alpha: 0.0),
        Colors.transparent,
      ],
      stops: const [0.0, 0.55, 1.0],
    );

    final spotlightPaint = Paint()
      ..shader = spotlightGradient.createShader(
        Rect.fromCircle(center: spotlightCenter, radius: spotlightRadius),
      );
    canvas.drawCircle(spotlightCenter, spotlightRadius, spotlightPaint);

    // 3. Canopy / Mud deep field glow (Bottom-right depth)
    final canopyCenter = Offset(
      size.width * 0.85,
      size.height * 0.65 - scrollOffset * 0.03,
    );
    final canopyRadius = size.width * 0.55;
    final canopyColor = isDark
        ? OryzaColors.militaryGreen.withValues(alpha: 0.045)
        : OryzaColors.militaryGreen.withValues(alpha: 0.03);

    final canopyGradient = RadialGradient(
      colors: [canopyColor, Colors.transparent],
      stops: const [0.0, 1.0],
    );
    final canopyPaint = Paint()
      ..shader = canopyGradient.createShader(
        Rect.fromCircle(center: canopyCenter, radius: canopyRadius),
      );
    canvas.drawCircle(canopyCenter, canopyRadius, canopyPaint);

    // 4. Style-specific features
    switch (style) {
      case OryzaBackgroundStyle.atmospheric:
        _drawPollenParticles(canvas, size);
        break;

      case OryzaBackgroundStyle.cleanStudio:
        _drawVignette(canvas, size);
        break;

      case OryzaBackgroundStyle.swissDots:
        _drawSwissDots(canvas, size);
        break;

      case OryzaBackgroundStyle.topographic:
        _drawTopographicCurves(canvas, size);
        break;
    }
  }

  void _drawPollenParticles(Canvas canvas, Size size) {
    final particlePaint = Paint()
      ..color = (isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange)
          .withValues(alpha: isDark ? 0.07 : 0.05);

    for (final p in particles) {
      final pos = p.position(size, progress, scrollOffset);
      canvas.drawCircle(pos, p.radius, particlePaint);
    }
  }

  void _drawSwissDots(Canvas canvas, Size size) {
    const spacing = 48.0;
    final dotColor = (isDark ? Colors.white : Colors.black)
        .withValues(alpha: isDark ? 0.045 : 0.05);
    final dotPaint = Paint()..color = dotColor;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.75, dotPaint);
      }
    }
  }

  void _drawTopographicCurves(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = (isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen)
          .withValues(alpha: isDark ? 0.04 : 0.035)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    const baseSteps = 6;
    for (int i = 0; i < baseSteps; i++) {
      final yBase = size.height * (0.15 + i * 0.15) - scrollOffset * 0.02;
      final path = Path();
      path.moveTo(0, yBase);
      for (double x = 0; x < size.width; x += 120) {
        final wave = sin((x / size.width) * 4 * pi + i + progress * pi) * 24.0;
        path.lineTo(x + 60, yBase + wave);
      }
      path.lineTo(size.width, yBase);
      canvas.drawPath(path, linePaint);
    }
  }

  void _drawVignette(Canvas canvas, Size size) {
    final vignetteGradient = RadialGradient(
      center: Alignment.center,
      radius: 1.1,
      colors: [
        Colors.transparent,
        (isDark ? Colors.black : const Color(0xFFECE7DB)).withValues(alpha: isDark ? 0.25 : 0.15),
      ],
      stops: const [0.65, 1.0],
    );
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = vignetteGradient.createShader(
          Offset.zero & size,
        ),
    );
  }

  @override
  bool shouldRepaint(covariant _OryzaAtmosphericPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.scrollOffset != scrollOffset ||
        oldDelegate.isDark != isDark ||
        oldDelegate.style != style;
  }
}

class _FieldPollenParticle {
  _FieldPollenParticle(int seed)
      : _rng = Random(seed * 77 + 13),
        radius = 0.75 + (seed % 3) * 0.4,
        speed = 0.1 + (seed % 4) * 0.03;

  final Random _rng;
  final double radius;
  final double speed;

  Offset position(Size size, double progress, double scrollOffset) {
    final dx = _rng.nextDouble() * size.width;
    final dy = _rng.nextDouble() * size.height;
    final float = sin(progress * pi * 2 + dx * 0.003) * 7 * speed;
    return Offset(dx, (dy + float - scrollOffset * 0.025) % size.height);
  }
}

/// Backward-compatible wrapper for existing callers, dynamically respecting
/// the active background style from [OryzaScope].
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
    final controller = OryzaScope.of(context);
    return OryzaAtmosphericBackground(
      isDark: isDark,
      style: controller.backgroundStyle,
      child: child,
    );
  }
}
