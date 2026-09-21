import 'package:flutter/material.dart';
import '../core/theme.dart';

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
    return CustomPaint(
      painter: _GraphPaperPainter(
        gridColor: isDark ? OryzaColors.darkGridLine : OryzaColors.lightGridLine,
        accentColor: isDark
            ? OryzaColors.darkBorder.withValues(alpha: 0.45)
            : OryzaColors.lightBorder.withValues(alpha: 0.12),
        spacing: 24.0,
      ),
      child: child,
    );
  }
}

class _GraphPaperPainter extends CustomPainter {
  final Color gridColor;
  final Color accentColor;
  final double spacing;

  _GraphPaperPainter({
    required this.gridColor,
    required this.accentColor,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final finePaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final accentPaint = Paint()
      ..color = accentColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw vertical lines
    int vCount = 0;
    for (double x = 0; x < size.width; x += spacing) {
      final paintToUse = (vCount % 5 == 0) ? accentPaint : finePaint;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paintToUse);
      vCount++;
    }

    // Draw horizontal lines
    int hCount = 0;
    for (double y = 0; y < size.height; y += spacing) {
      final paintToUse = (hCount % 5 == 0) ? accentPaint : finePaint;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintToUse);
      hCount++;
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPaperPainter oldDelegate) {
    return oldDelegate.gridColor != gridColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.spacing != spacing;
  }
}
