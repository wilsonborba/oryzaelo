import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:local/domain/models/phenology_prediction.dart';
import 'package:local/domain/models/weather_analytics.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Multidimensional agrometeorological visualizations: Donut, Radar, and Correlation Heatmap.
class MultidimensionalVisualizations extends StatelessWidget {
  final PhenologyPrediction? prediction;
  final WeatherAnalyticsReport? analytics;

  const MultidimensionalVisualizations({
    super.key,
    required this.prediction,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final s = OryzaI18n.of(context);
    final state = OryzaScope.of(context);
    final locale = state.locale;
    final currentLang = locale.countryCode != null
        ? '${locale.languageCode}-${locale.countryCode}'
        : locale.languageCode;

    if (prediction == null && analytics == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.radar, size: 48, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                s.vizWaitingAnalytics,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }

    final alerts = analytics?.getAlertsForLocale(currentLang) ?? [];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 950;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dynamic Data-Driven Alerts Banner
            if (alerts.isNotEmpty) ...[
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: alerts.map((alert) => _buildAlertCard(context, alert, isDark)).toList(),
              ),
              const SizedBox(height: 18),
            ],

            // Row 1: Phenology Probabilities Donut + Biomet Agrometeorological Radar
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: _buildPanel(
                      context,
                      title: s.vizDonutHeader,
                      subtitle: s.vizDonutSubtitle,
                      child: PhenologyProbabilitiesDonut(
                        probabilities: prediction?.probabilities ?? {},
                        isDark: isDark,
                        emptyLabel: s.vizNoDonutData,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 5,
                    child: _buildPanel(
                      context,
                      title: s.vizRadarHeader,
                      subtitle: s.vizRadarSubtitle,
                      child: BiometRadarChart(
                        dimensions: analytics?.biometRadar ?? [],
                        isDark: isDark,
                        emptyLabel: s.vizNoRadarData,
                      ),
                    ),
                  ),
                ],
              )
            else ...[
              _buildPanel(
                context,
                title: s.vizDonutHeader,
                subtitle: s.vizDonutSubtitle,
                child: PhenologyProbabilitiesDonut(
                  probabilities: prediction?.probabilities ?? {},
                  isDark: isDark,
                  emptyLabel: s.vizNoDonutData,
                ),
              ),
              const SizedBox(height: 16),
              _buildPanel(
                context,
                title: s.vizRadarHeader,
                subtitle: s.vizRadarSubtitle,
                child: BiometRadarChart(
                  dimensions: analytics?.biometRadar ?? [],
                  isDark: isDark,
                  emptyLabel: s.vizNoRadarData,
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Row 2: Environmental Correlation Matrix Heatmap
            _buildPanel(
              context,
              title: s.vizCorrelationHeader,
              subtitle: s.vizCorrelationSubtitle,
              child: CorrelationHeatmap(
                correlation: analytics?.correlationMatrix,
                isDark: isDark,
                emptyLabel: s.vizNoCorrelationData,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAlertCard(BuildContext context, DynamicAdvisoryAlert alert, bool isDark) {
    Color bg;
    Color border;
    Color textCol;
    IconData icon;

    switch (alert.level) {
      case 'critical':
        bg = isDark ? Colors.red.shade900.withValues(alpha: 0.3) : Colors.red.shade50;
        border = isDark ? Colors.red.shade700 : Colors.red.shade300;
        textCol = isDark ? Colors.red.shade200 : Colors.red.shade900;
        icon = Icons.error_outline;
        break;
      case 'warning':
        bg = isDark ? Colors.amber.shade900.withValues(alpha: 0.25) : Colors.amber.shade50;
        border = isDark ? Colors.amber.shade700 : Colors.amber.shade300;
        textCol = isDark ? Colors.amber.shade200 : Colors.amber.shade900;
        icon = Icons.warning_amber;
        break;
      default:
        bg = isDark ? Colors.green.shade900.withValues(alpha: 0.25) : Colors.green.shade50;
        border = isDark ? Colors.green.shade700 : Colors.green.shade300;
        textCol = isDark ? Colors.green.shade200 : Colors.green.shade900;
        icon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: textCol),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  alert.title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Ubuntu Sans Mono',
                    color: textCol,
                  ),
                ),
                Text(
                  alert.action,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Ubuntu Sans',
                    color: textCol.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              fontFamily: 'Ubuntu Sans Mono',
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
            ),
          ),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'Ubuntu Sans',
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. Phenology Probabilities Donut Chart
// ─────────────────────────────────────────────────────────────────────────────

class PhenologyProbabilitiesDonut extends StatelessWidget {
  final Map<String, double> probabilities;
  final bool isDark;
  final String emptyLabel;

  const PhenologyProbabilitiesDonut({
    super.key,
    required this.probabilities,
    required this.isDark,
    required this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (probabilities.isEmpty) {
      return SizedBox(
        height: 180,
        child: Center(child: Text(emptyLabel)),
      );
    }

    final colors = [
      Colors.teal,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.amber.shade800,
      Colors.orange,
      Colors.red.shade700,
    ];

    final entries = probabilities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final dominant = entries.first;

    final donut = SizedBox(
      width: 150,
      height: 150,
      child: CustomPaint(
        painter: _DonutPainter(
          entries: entries,
          colors: colors,
          dominantText: '${(dominant.value * 100).toStringAsFixed(0)}%',
          isDark: isDark,
        ),
      ),
    );

    final legend = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: entries.asMap().entries.map((e) {
        final idx = e.key;
        final item = e.value;
        final col = colors[idx % colors.length];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.5),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: col, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.key,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                    fontFamily: 'Ubuntu Sans',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${(item.value * 100).toStringAsFixed(1)}%',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Ubuntu Sans Mono',
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );

    // Below ~300px the donut+legend side-by-side leaves too little room for
    // the legend to be readable — stack the donut above the legend instead.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: donut),
              const SizedBox(height: 12),
              legend,
            ],
          );
        }

        return Row(
          children: [
            donut,
            const SizedBox(width: 16),
            Expanded(child: legend),
          ],
        );
      },
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<MapEntry<String, double>> entries;
  final List<Color> colors;
  final String dominantText;
  final bool isDark;

  _DonutPainter({
    required this.entries,
    required this.colors,
    required this.dominantText,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 18.0;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < entries.length; i++) {
      final sweepAngle = (entries[i].value * 2 * math.pi);
      if (sweepAngle <= 0) continue;

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Center percentage label
    final tp = TextPainter(
      text: TextSpan(
        text: dominantText,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : Colors.black87,
          fontFamily: 'Ubuntu Sans Mono',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Biomet Multidimensional Radar Chart (5 Eixos)
// ─────────────────────────────────────────────────────────────────────────────

class BiometRadarChart extends StatelessWidget {
  final List<RadarDimensionScore> dimensions;
  final bool isDark;
  final String emptyLabel;

  const BiometRadarChart({
    super.key,
    required this.dimensions,
    required this.isDark,
    required this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (dimensions.isEmpty) {
      return SizedBox(
        height: 220,
        child: Center(child: Text(emptyLabel)),
      );
    }

    final s = OryzaI18n.of(context);
    final labelsByKey = {
      'thermal_suitability': s.radarThermalSuitability,
      'radiation_energy': s.radarRadiationEnergy,
      'water_security': s.radarWaterSecurity,
      'humidity_balance': s.radarHumidityBalance,
      'thermal_stability': s.radarThermalStability,
    };

    return SizedBox(
      height: 220,
      child: CustomPaint(
        size: Size.infinite,
        painter: _RadarPainter(dimensions: dimensions, isDark: isDark, labelsByKey: labelsByKey),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final List<RadarDimensionScore> dimensions;
  final bool isDark;
  final Map<String, String> labelsByKey;

  _RadarPainter({required this.dimensions, required this.isDark, required this.labelsByKey});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);

    final center = Offset(size.width / 2, size.height / 2);
    final maxR = math.min(size.width, size.height) / 2 - 32;
    final n = dimensions.length;

    final gridPaint = Paint()
      ..color = isDark ? Colors.white12 : Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw concentric rings (20%, 40%, 60%, 80%, 100%)
    for (int ring = 1; ring <= 5; ring++) {
      final r = maxR * (ring / 5.0);
      final ringPath = Path();
      for (int i = 0; i < n; i++) {
        final angle = (i * 2 * math.pi / n) - math.pi / 2;
        final x = center.dx + r * math.cos(angle);
        final y = center.dy + r * math.sin(angle);
        if (i == 0) {
          ringPath.moveTo(x, y);
        } else {
          ringPath.lineTo(x, y);
        }
      }
      ringPath.close();
      canvas.drawPath(ringPath, gridPaint);
    }

    // Draw spokes and axis labels
    for (int i = 0; i < n; i++) {
      final angle = (i * 2 * math.pi / n) - math.pi / 2;
      final x = center.dx + maxR * math.cos(angle);
      final y = center.dy + maxR * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), gridPaint);

      // Label
      final lx = center.dx + (maxR + 18) * math.cos(angle);
      final ly = center.dy + (maxR + 18) * math.sin(angle);

      final label = labelsByKey[dimensions[i].key] ?? dimensions[i].label;
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            fontFamily: 'Ubuntu Sans',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      // Clamp so long localized axis labels near the horizontal extremes
      // can't bleed past the canvas edge on a narrow (phone-width) card.
      final paintX = (lx - tp.width / 2).clamp(0.0, size.width - tp.width);
      final paintY = (ly - tp.height / 2).clamp(0.0, size.height - tp.height);
      tp.paint(canvas, Offset(paintX, paintY));
    }

    // Draw Score Polygon
    final scorePath = Path();
    for (int i = 0; i < n; i++) {
      final scoreRatio = (dimensions[i].score / 100.0).clamp(0.0, 1.0);
      final r = maxR * scoreRatio;
      final angle = (i * 2 * math.pi / n) - math.pi / 2;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);

      if (i == 0) {
        scorePath.moveTo(x, y);
      } else {
        scorePath.lineTo(x, y);
      }
    }
    scorePath.close();

    // Fill
    final fillPaint = Paint()
      ..color = Colors.green.withValues(alpha: isDark ? 0.35 : 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawPath(scorePath, fillPaint);

    // Stroke
    final strokePaint = Paint()
      ..color = isDark ? Colors.greenAccent : Colors.green.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(scorePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Environmental Correlation Matrix Heatmap
// ─────────────────────────────────────────────────────────────────────────────

class CorrelationHeatmap extends StatelessWidget {
  final CorrelationMatrix? correlation;
  final bool isDark;
  final String emptyLabel;

  const CorrelationHeatmap({
    super.key,
    required this.correlation,
    required this.isDark,
    required this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (correlation == null || correlation!.variables.isEmpty) {
      return SizedBox(
        height: 180,
        child: Center(child: Text(emptyLabel)),
      );
    }

    final vars = correlation!.variables;
    final mat = correlation!.matrix;

    return OryzaHorizontalScroller(
      isDark: isDark,
      step: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              const SizedBox(width: 80), // Corner space
              ...vars.map(
                (v) => SizedBox(
                  width: 65,
                  height: 32,
                  child: Center(
                    child: Text(
                      v,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Ubuntu Sans Mono',
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Data Rows
          ...List.generate(vars.length, (rowIdx) {
            final rowName = vars[rowIdx];
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    height: 32,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        rowName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Ubuntu Sans Mono',
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...List.generate(vars.length, (colIdx) {
                    final rVal = mat[rowIdx][colIdx];
                    return Container(
                      width: 65,
                      height: 32,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: _getHeatmapColor(rVal, isDark),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          rVal.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Ubuntu Sans Mono',
                            color: _getTextContrastColor(rVal),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getHeatmapColor(double r, bool isDark) {
    if (r >= 0) {
      // Emerald Green gradient
      return Colors.green.withValues(alpha: (0.15 + (r.abs() * 0.75)).clamp(0.0, 1.0));
    } else {
      // Coral Red gradient
      return Colors.red.withValues(alpha: (0.15 + (r.abs() * 0.75)).clamp(0.0, 1.0));
    }
  }

  Color _getTextContrastColor(double r) {
    if (r.abs() > 0.6) {
      return Colors.white;
    }
    return isDark ? Colors.white70 : Colors.black87;
  }
}
