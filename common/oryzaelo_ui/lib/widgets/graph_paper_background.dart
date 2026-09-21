import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/state.dart';

/// Immersive Flooded Rice Paddy Topographic Background (Topografia de Várzea de Arroz).
/// Renders sinuous organic contour bunds (taipas), shallow terraced water basins (lâminas d'água),
/// specular aquatic reflections, and discreet agronomic survey elevations.
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
      List.generate(20, (index) => _FieldPollenParticle(index));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
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
          painter: _RicePaddyTopographyPainter(
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

class _RicePaddyTopographyPainter extends CustomPainter {
  final double progress;
  final double scrollOffset;
  final List<_FieldPollenParticle> particles;
  final bool isDark;

  _RicePaddyTopographyPainter({
    required this.progress,
    required this.scrollOffset,
    required this.particles,
    required this.isDark,
  });

  // Mathematical Elevation Function for organic rice paddy contour terraces
  double _getContourY(double x, int tier, Size size) {
    final nx = x / size.width;
    final yBase = size.height * (tier * 0.075 - 0.04) - scrollOffset * 0.035;
    final wave1 = sin(nx * 2.6 * pi + tier * 0.42 + progress * 0.5 * pi) * (26.0 + (tier % 4) * 7.0);
    final wave2 = cos(nx * 4.8 * pi + tier * 0.68) * 11.0;
    final wave3 = sin(nx * 1.3 * pi + 1.6) * 15.0;
    return yBase + wave1 + wave2 + wave3;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Base architectural field canvas
    final baseColor = isDark ? const Color(0xFF101510) : const Color(0xFFF7F6F0);
    canvas.drawRect(rect, Paint()..color = baseColor);

    // 2. Solar & Sky Atmospheric Infiltration (Warm sunlight over the flooded valley)
    final sunCenter = Offset(size.width * 0.45, size.height * 0.15 - scrollOffset * 0.02);
    final sunRadius = size.width * 0.75;
    final breathe = sin(progress * pi);

    final sunGradient = RadialGradient(
      colors: [
        isDark
            ? OryzaColors.mustardYellow.withValues(alpha: 0.04 + 0.015 * breathe)
            : OryzaColors.mustardYellow.withValues(alpha: 0.06 + 0.02 * breathe),
        isDark ? const Color(0xFF131A13).withValues(alpha: 0.01) : Colors.white.withValues(alpha: 0.0),
        Colors.transparent,
      ],
      stops: const [0.0, 0.6, 1.0],
    );
    canvas.drawCircle(
      sunCenter,
      sunRadius,
      Paint()..shader = sunGradient.createShader(Rect.fromCircle(center: sunCenter, radius: sunRadius)),
    );

    // 3. Deep Rice Field Mud & Canopy Depth (Bottom-right rich gradient)
    final mudCenter = Offset(size.width * 0.85, size.height * 0.75 - scrollOffset * 0.03);
    final mudRadius = size.width * 0.65;
    final mudGradient = RadialGradient(
      colors: [
        isDark
            ? OryzaColors.militaryGreen.withValues(alpha: 0.08)
            : OryzaColors.militaryGreen.withValues(alpha: 0.05),
        Colors.transparent,
      ],
      stops: const [0.0, 1.0],
    );
    canvas.drawCircle(
      mudCenter,
      mudRadius,
      Paint()..shader = mudGradient.createShader(Rect.fromCircle(center: mudCenter, radius: mudRadius)),
    );

    // 4. Sinuous Flooded Rice Paddy Terraces (Lâminas de Água e Patamares)
    const int totalTiers = 16;
    const double stepX = 40.0;

    // A) Paint Flooded Water Basins (Translucent aquatic green reflections between terrace pairs)
    for (int i = 0; i < totalTiers - 1; i++) {
      // Alternate basins to mimic stepped water terraces
      if (i % 2 == 0) {
        final basinPath = Path();
        final firstY = _getContourY(0, i, size);
        basinPath.moveTo(0, firstY);

        // Forward along top contour
        for (double x = stepX; x <= size.width; x += stepX) {
          basinPath.lineTo(x, _getContourY(x, i, size));
        }
        basinPath.lineTo(size.width, _getContourY(size.width, i, size));

        // Connect to bottom contour
        basinPath.lineTo(size.width, _getContourY(size.width, i + 1, size));

        // Backward along bottom contour
        for (double x = size.width - stepX; x >= 0; x -= stepX) {
          basinPath.lineTo(x, _getContourY(x, i + 1, size));
        }
        basinPath.close();

        // Water reflection gradient
        final waterTopColor = isDark
            ? const Color(0xFF1B3D23).withValues(alpha: 0.18 + 0.04 * breathe)
            : const Color(0xFF7FA878).withValues(alpha: 0.07 + 0.02 * breathe);
        final waterBottomColor = isDark
            ? const Color(0xFF122617).withValues(alpha: 0.06)
            : const Color(0xFF5B8A57).withValues(alpha: 0.025);

        final waterGradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [waterTopColor, waterBottomColor],
        );

        final basinBounds = basinPath.getBounds();
        if (basinBounds.height > 0 && basinBounds.width > 0) {
          final waterPaint = Paint()..shader = waterGradient.createShader(basinBounds);
          canvas.drawPath(basinPath, waterPaint);
        }
      }
    }

    // B) Topographic Contour Lines (Taipas e Diques de Contenção de Várzea)
    // Curvas mestras (index contours) are thicker and rich green; intermediate curves are delicate.
    final primaryLinePaint = Paint()
      ..color = isDark
          ? const Color(0xFF62AD69).withValues(alpha: 0.35)
          : const Color(0xFF275C2B).withValues(alpha: 0.40)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final secondaryLinePaint = Paint()
      ..color = isDark
          ? const Color(0xFF4C8F53).withValues(alpha: 0.22)
          : const Color(0xFF38753C).withValues(alpha: 0.26)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final specularPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.white).withValues(alpha: isDark ? 0.08 : 0.45)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final surveyLabels = [
      "COTA +10.5m • LÂMINA 7.5cm",
      "VÁRZEA INUNDADA • TAIPA 02",
      "COTA +11.2m • CONDUTIVIDADE",
      "CANAL DE ALIMENTAÇÃO • RS-485",
      "COTA +12.0m • TALHÃO DE ARROZ",
      "PATAMAR CENTRAL • BBCH 25",
    ];

    for (int i = 0; i < totalTiers; i++) {
      final isPrimary = i % 3 == 0;
      final path = Path();
      final specularPath = Path();

      final startY = _getContourY(0, i, size);
      path.moveTo(0, startY);
      specularPath.moveTo(0, startY - 0.8);

      for (double x = stepX; x <= size.width; x += stepX) {
        final cy = _getContourY(x, i, size);
        path.lineTo(x, cy);
        specularPath.lineTo(x, cy - 0.8);
      }

      // Draw main contour line
      canvas.drawPath(path, isPrimary ? primaryLinePaint : secondaryLinePaint);

      // Draw subtle specular aquatic highlight along top of primary bunds
      if (isPrimary && !isDark) {
        canvas.drawPath(specularPath, specularPaint);
      }

      // C) Agronomic Elevation Survey Annotations along primary curves
      if (isPrimary && i > 0 && i < totalTiers - 2) {
        final labelIndex = (i ~/ 3) % surveyLabels.length;
        final labelText = surveyLabels[labelIndex];
        final labelX = (size.width * (0.15 + (i % 3) * 0.28)) % (size.width - 240);
        final labelY = _getContourY(labelX, i, size) - 4.0;

        _drawElevationLabel(canvas, labelText, Offset(labelX, labelY));
      }
    }

    // 5. Airborne Rice Pollen Particles in gentle suspension
    _drawPollenParticles(canvas, size);
  }

  void _drawElevationLabel(Canvas canvas, String text, Offset position) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: OryzaTypography.monoFontFamily,
          package: 'oryzaelo_ui',
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: isDark
              ? const Color(0xFF7CB881).withValues(alpha: 0.40)
              : const Color(0xFF275C2B).withValues(alpha: 0.50),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, position);
  }

  void _drawPollenParticles(Canvas canvas, Size size) {
    final particlePaint = Paint()
      ..color = (isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange)
          .withValues(alpha: isDark ? 0.08 : 0.06);

    for (final p in particles) {
      final pos = p.position(size, progress, scrollOffset);
      canvas.drawCircle(pos, p.radius, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RicePaddyTopographyPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.scrollOffset != scrollOffset ||
        oldDelegate.isDark != isDark;
  }
}

class _FieldPollenParticle {
  _FieldPollenParticle(int seed)
      : _rng = Random(seed * 77 + 13),
        radius = 0.85 + (seed % 3) * 0.45,
        speed = 0.12 + (seed % 4) * 0.035;

  final Random _rng;
  final double radius;
  final double speed;

  Offset position(Size size, double progress, double scrollOffset) {
    final dx = _rng.nextDouble() * size.width;
    final dy = _rng.nextDouble() * size.height;
    final float = sin(progress * pi * 2 + dx * 0.003) * 8 * speed;
    return Offset(dx, (dy + float - scrollOffset * 0.025) % size.height);
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
