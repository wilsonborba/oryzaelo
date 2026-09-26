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
              const Text(
                'Aguardando dados analíticos e predição fenológica.',
                style: TextStyle(fontWeight: FontWeight.w600),
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
                      title: 'PROBABILIDADE FENOLÓGICA (CATBOOST ONNX)',
                      subtitle: 'Distribuição bayesiana de pertinência por estágio BBCH',
                      icon: Icons.pie_chart_outline,
                      child: PhenologyProbabilitiesDonut(
                        probabilities: prediction?.probabilities ?? {},
                        isDark: isDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 5,
                    child: _buildPanel(
                      context,
                      title: 'RADAR AGROMETEOROLÓGICO MULTIDIMENSIONAL',
                      subtitle: 'Índice de adequação biofísica da cultura do arroz (5 eixos)',
                      icon: Icons.radar,
                      child: BiometRadarChart(
                        dimensions: analytics?.biometRadar ?? [],
                        isDark: isDark,
                      ),
                    ),
                  ),
                ],
              )
            else ...[
              _buildPanel(
                context,
                title: 'PROBABILIDADE FENOLÓGICA (CATBOOST ONNX)',
                subtitle: 'Distribuição bayesiana de pertinência por estágio BBCH',
                icon: Icons.pie_chart_outline,
                child: PhenologyProbabilitiesDonut(
                  probabilities: prediction?.probabilities ?? {},
                  isDark: isDark,
                ),
              ),
              const SizedBox(height: 16),
              _buildPanel(
                context,
                title: 'RADAR AGROMETEOROLÓGICO MULTIDIMENSIONAL',
                subtitle: 'Índice de adequação biofísica da cultura do arroz (5 eixos)',
                icon: Icons.radar,
                child: BiometRadarChart(
                  dimensions: analytics?.biometRadar ?? [],
                  isDark: isDark,
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Row 2: Environmental Correlation Matrix Heatmap
            _buildPanel(
              context,
              title: 'MATRIZ DE CORRELAÇÃO AMBIENTAL DE PEARSON',
              subtitle: 'Interações lineares entre condutores climáticos (-1.0 a +1.0) calculadas na borda',
              icon: Icons.grid_on,
              child: CorrelationHeatmap(
                correlation: analytics?.correlationMatrix,
                isDark: isDark,
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
    required IconData icon,
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
          Row(
            children: [
              Icon(icon, size: 16, color: isDark ? Colors.green.shade300 : Colors.green.shade800),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
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
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Ubuntu Sans',
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  const PhenologyProbabilitiesDonut({
    super.key,
    required this.probabilities,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (probabilities.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('Sem distribuição probabilística disponível')),
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

    return Row(
      children: [
        // Donut
        SizedBox(
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
        ),
        const SizedBox(width: 16),
        // Legend
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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
                    Text(
                      '${(item.value * 100).toStringAsFixed(1)}%',
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
          ),
        ),
      ],
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

  const BiometRadarChart({
    super.key,
    required this.dimensions,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (dimensions.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('Aguardando cálculo das dimensões biofísicas')),
      );
    }

    return SizedBox(
      height: 220,
      child: CustomPaint(
        size: Size.infinite,
        painter: _RadarPainter(dimensions: dimensions, isDark: isDark),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final List<RadarDimensionScore> dimensions;
  final bool isDark;

  _RadarPainter({required this.dimensions, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
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

      final label = dimensions[i].label;
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
      tp.paint(canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));
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

  const CorrelationHeatmap({
    super.key,
    required this.correlation,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (correlation == null || correlation!.variables.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('Aguardando cálculo da matriz de correlação')),
      );
    }

    final vars = correlation!.variables;
    final mat = correlation!.matrix;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
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
                  child: Center(
                    child: Text(
                      v,
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
                    child: Text(
                      rowName,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Ubuntu Sans Mono',
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.right,
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
