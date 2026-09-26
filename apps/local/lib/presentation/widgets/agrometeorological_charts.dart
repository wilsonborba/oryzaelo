import 'package:flutter/material.dart';
import 'package:local/domain/models/weather_record.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

/// Senior agrometeorological charts: GDD curve, dual thermal trend, water balance & DTR band.
class AgrometeorologicalCharts extends StatelessWidget {
  final List<DailyWeatherRecord> records;

  const AgrometeorologicalCharts({
    super.key,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // These trend charts plot continuous numeric series -- a day still
    // waiting on one sensor can't contribute a point to any of them. The raw
    // table (Data Management screen) is where partial-day visibility
    // belongs; here we only ever plot complete days.
    final completeRecords = records.where((r) => r.isComplete).toList();

    if (completeRecords.isEmpty) {
      return ScrapbookCard(
        isDark: isDark,
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.25,
                    child: Image.asset(
                      'assets/plants/Jungle_Plant_1.png',
                      width: 140,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Image.asset(
                    'assets/icons3d/sun-dynamic-color.png',
                    width: 72,
                    height: 72,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                s.simEmptyTitle,
                style: const TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Text(
                  s.simEmptyDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 12.5,
                    color: isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 960;

        final gddCard = _AgroChartCard(
          title: s.dashFilterClimate.toUpperCase(),
          subtitle: s.chartGddAnalysis,
          unitBadge: s.chartUnitGdd,
          analysisText: s.chartGddAnalysis,
          meaningText: s.chartGddMeaning,
          actionText: s.chartGddAction,
          isDark: isDark,
          child: GddAccumulationChart(records: completeRecords, isDark: isDark, s: s),
        );

        final thermalCard = _AgroChartCard(
          title: '${s.tableColTmax} / ${s.tableColRh}'.toUpperCase(),
          subtitle: s.chartThermalAnalysis,
          unitBadge: '${s.chartUnitTemp} • ${s.chartUnitHumidity}',
          analysisText: s.chartThermalAnalysis,
          meaningText: s.chartThermalMeaning,
          actionText: s.chartThermalAction,
          isDark: isDark,
          child: ThermalHumidityChart(records: completeRecords, isDark: isDark, s: s),
        );

        final waterCard = _AgroChartCard(
          title: '${s.tableColRain} & ${s.tableColRad}'.toUpperCase(),
          subtitle: s.chartWaterAnalysis,
          unitBadge: '${s.chartUnitPrecipitation} • ${s.chartUnitRadiation}',
          analysisText: s.chartWaterAnalysis,
          meaningText: s.chartWaterMeaning,
          actionText: s.chartWaterAction,
          isDark: isDark,
          child: WaterRadiationChart(records: completeRecords, isDark: isDark, s: s),
        );

        final dtrCard = _AgroChartCard(
          title: s.chartUnitDtr.toUpperCase(),
          subtitle: s.chartDtrAnalysis,
          unitBadge: s.chartUnitDtr,
          analysisText: s.chartDtrAnalysis,
          meaningText: s.chartDtrMeaning,
          actionText: s.chartDtrAction,
          isDark: isDark,
          child: DtrBandChart(records: completeRecords, isDark: isDark, s: s),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: gddCard),
                  const SizedBox(width: 16),
                  Expanded(child: thermalCard),
                ],
              )
            else ...[
              gddCard,
              const SizedBox(height: 16),
              thermalCard,
            ],
            const SizedBox(height: 16),
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: waterCard),
                  const SizedBox(width: 16),
                  Expanded(child: dtrCard),
                ],
              )
            else ...[
              waterCard,
              const SizedBox(height: 16),
              dtrCard,
            ],
          ],
        );
      },
    );
  }
}

class _AgroChartCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String unitBadge;
  final String analysisText;
  final String meaningText;
  final String actionText;
  final bool isDark;
  final Widget child;

  const _AgroChartCard({
    required this.title,
    required this.subtitle,
    required this.unitBadge,
    required this.analysisText,
    required this.meaningText,
    required this.actionText,
    required this.isDark,
    required this.child,
  });

  @override
  State<_AgroChartCard> createState() => _AgroChartCardState();
}

class _AgroChartCardState extends State<_AgroChartCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final borderColor = widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final surfaceColor = widget.isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final textColor = widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: widget.isDark ? 0.3 : 0.08),
            offset: const Offset(2, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              fontFamily: OryzaTypography.monoFontFamily,
                              package: 'oryzaelo_ui',
                              color: textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: widget.isDark ? OryzaColors.darkCanvas : OryzaColors.botanicalGreenLight,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.botanicalGreenBorder,
                              ),
                            ),
                            child: Text(
                              widget.unitBadge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: OryzaTypography.monoFontFamily,
                                package: 'oryzaelo_ui',
                                color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        color: textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              // Expand / Info toggle button
              IconButton(
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                icon: Icon(
                  _isExpanded ? Icons.close : Icons.help_outline_rounded,
                  size: 18,
                  color: _isExpanded ? OryzaColors.burntOrange : textSecondary,
                ),
                tooltip: _isExpanded ? s.chartCollapseExpl : s.chartExpandExpl,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          // Expandable Explanations Card
          if (_isExpanded) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isDark ? const Color(0xFF161C16) : const Color(0xFFF4F6F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: OryzaColors.botanicalGreen.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildExplanationBullet(
                    label: s.chartWhatItAnalyzes,
                    content: widget.analysisText,
                    badgeColor: OryzaColors.burntOrange,
                    isDark: widget.isDark,
                  ),
                  const SizedBox(height: 8),
                  _buildExplanationBullet(
                    label: s.chartWhatItMeans,
                    content: widget.meaningText,
                    // Mustard yellow at full saturation is too low-contrast
                    // as small bold text on a light background.
                    badgeColor: widget.isDark ? OryzaColors.mustardYellow : Colors.amber.shade900,
                    isDark: widget.isDark,
                  ),
                  const SizedBox(height: 8),
                  _buildExplanationBullet(
                    label: s.chartHowToUseInField,
                    content: widget.actionText,
                    badgeColor: OryzaColors.botanicalGreen,
                    isDark: widget.isDark,
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
          SizedBox(height: 220, child: widget.child),
        ],
      ),
    );
  }

  Widget _buildExplanationBullet({
    required String label,
    required String content,
    required Color badgeColor,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              fontFamily: OryzaTypography.monoFontFamily,
              package: 'oryzaelo_ui',
              color: badgeColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            content,
            style: TextStyle(
              fontSize: 11,
              height: 1.35,
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              color: isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// 1. GDD Accumulation Curve (Line + Gradient Area)
// ─────────────────────────────────────────────────────────────────────────────

class GddAccumulationChart extends StatelessWidget {
  final List<DailyWeatherRecord> records;
  final bool isDark;
  final OryzaStrings s;

  const GddAccumulationChart({
    super.key,
    required this.records,
    required this.isDark,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    // Sort chronologically ascending
    final sorted = [...records]..sort((a, b) => a.date.compareTo(b.date));

    // Calculate cumulative GDD
    double cumGdd = 0.0;
    final List<double> cumSeries = [];
    for (final r in sorted) {
      cumGdd += r.dailyGdd ?? 0.0;
      cumSeries.add(cumGdd);
    }

    final maxVal = cumGdd > 0 ? cumGdd * 1.15 : 100.0;

    return CustomPaint(
      size: Size.infinite,
      painter: _GddPainter(
        cumSeries: cumSeries,
        maxVal: maxVal,
        isDark: isDark,
        totalLabel: s.chartGddTotalLabel,
      ),
    );
  }
}

class _GddPainter extends CustomPainter {
  final List<double> cumSeries;
  final double maxVal;
  final bool isDark;
  final String totalLabel;

  _GddPainter({
    required this.cumSeries,
    required this.maxVal,
    required this.isDark,
    required this.totalLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);

    const padB = 24.0;
    const padR = 12.0; // clearance so the right-edge marker/callout never clips
    final textStyle = TextStyle(
      fontSize: 9,
      fontFamily: 'Ubuntu Sans Mono',
      color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
    );

    // Size the left axis gutter from the widest label actually rendered,
    // instead of a fixed 40px that clips whenever GDD totals exceed ~3 digits.
    double padL = 32.0;
    for (int i = 0; i <= 4; i++) {
      final label = ((maxVal * (i / 4.0))).toStringAsFixed(0);
      final tp = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      padL = padL < tp.width + 12 ? tp.width + 12 : padL;
    }

    final w = size.width - padL - padR;
    final h = size.height - padB;

    final gridPaint = Paint()
      ..color = isDark ? Colors.white10 : Colors.black12
      ..strokeWidth = 1.0;

    // Draw horizontal grid lines (4 levels)
    for (int i = 0; i <= 4; i++) {
      final y = h - (h * (i / 4.0));
      canvas.drawLine(Offset(padL, y), Offset(size.width - padR, y), gridPaint);
      final label = ((maxVal * (i / 4.0))).toStringAsFixed(0);
      final tp = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset((padL - tp.width - 6).clamp(0.0, double.infinity), y - tp.height / 2));
    }

    if (cumSeries.length < 2) return;

    final path = Path();
    final fillPath = Path();

    final stepX = w / (cumSeries.length - 1);

    for (int i = 0; i < cumSeries.length; i++) {
      final x = padL + (i * stepX);
      final y = h - (h * (cumSeries[i] / maxVal));

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, h);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(padL + ((cumSeries.length - 1) * stepX), h);
    fillPath.close();

    // Gradient Fill
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.green.withValues(alpha: isDark ? 0.35 : 0.25),
        Colors.green.withValues(alpha: 0.0),
      ],
    );

    final fillPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(padL, 0, w, h));
    canvas.drawPath(fillPath, fillPaint);

    // Line stroke
    final linePaint = Paint()
      ..color = isDark ? Colors.greenAccent : Colors.green.shade700
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, linePaint);

    // Final total callout
    final lastVal = cumSeries.last;
    final lastX = padL + ((cumSeries.length - 1) * stepX);
    final lastY = h - (h * (lastVal / maxVal));

    canvas.drawCircle(
      Offset(lastX, lastY),
      4.0,
      Paint()..color = Colors.greenAccent.shade700,
    );

    final totalTp = TextPainter(
      text: TextSpan(
        text: '$totalLabel: ${lastVal.toStringAsFixed(1)} °C-d',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.greenAccent : Colors.green.shade900,
          fontFamily: 'Ubuntu Sans Mono',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    // Anchor to the left of the marker by default, but flip to the right
    // when there isn't enough room on the left (short series near the axis).
    final labelX = (lastX - totalTp.width - 8) < padL
        ? (lastX + 8).clamp(0.0, size.width - totalTp.width)
        : lastX - totalTp.width - 8;
    totalTp.paint(canvas, Offset(labelX, lastY - 14));
  }

  @override
  bool shouldRepaint(covariant _GddPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Thermal & Humidity Dual Trend (T_max, T_min, RH%)
// ─────────────────────────────────────────────────────────────────────────────

class ThermalHumidityChart extends StatelessWidget {
  final List<DailyWeatherRecord> records;
  final bool isDark;
  final OryzaStrings s;

  const ThermalHumidityChart({
    super.key,
    required this.records,
    required this.isDark,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...records]..sort((a, b) => a.date.compareTo(b.date));

    return CustomPaint(
      size: Size.infinite,
      painter: _ThermalHumidityPainter(
        records: sorted,
        isDark: isDark,
        legendTMax: s.chartLegendTMax,
        legendTMin: s.chartLegendTMin,
        legendHumidity: s.chartLegendHumidity,
      ),
    );
  }
}

class _ThermalHumidityPainter extends CustomPainter {
  final List<DailyWeatherRecord> records;
  final bool isDark;
  final String legendTMax;
  final String legendTMin;
  final String legendHumidity;

  _ThermalHumidityPainter({
    required this.records,
    required this.isDark,
    required this.legendTMax,
    required this.legendTMin,
    required this.legendHumidity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);

    const padL = 36.0;
    const padR = 36.0;
    const padB = 24.0;
    final w = size.width - padL - padR;
    final h = size.height - padB;

    final gridPaint = Paint()
      ..color = isDark ? Colors.white10 : Colors.black12
      ..strokeWidth = 1.0;

    // Grid
    for (int i = 0; i <= 4; i++) {
      final y = h - (h * (i / 4.0));
      canvas.drawLine(Offset(padL, y), Offset(size.width - padR, y), gridPaint);
    }

    if (records.length < 2) return;

    final stepX = w / (records.length - 1);

    // Temperature scale: 10°C to 45°C
    const minT = 10.0;
    const maxT = 45.0;

    // Humidity scale: 30% to 100%
    const minRh = 30.0;
    const maxRh = 100.0;

    final pathTMax = Path();
    final pathTMin = Path();
    final pathRh = Path();

    for (int i = 0; i < records.length; i++) {
      final r = records[i];
      final x = padL + (i * stepX);

      final yMax = h - (h * ((r.tMax! - minT) / (maxT - minT)).clamp(0.0, 1.0));
      final yMin = h - (h * ((r.tMin! - minT) / (maxT - minT)).clamp(0.0, 1.0));
      final yRh = h - (h * ((r.relativeHumidityPct! - minRh) / (maxRh - minRh)).clamp(0.0, 1.0));

      if (i == 0) {
        pathTMax.moveTo(x, yMax);
        pathTMin.moveTo(x, yMin);
        pathRh.moveTo(x, yRh);
      } else {
        pathTMax.lineTo(x, yMax);
        pathTMin.lineTo(x, yMin);
        pathRh.lineTo(x, yRh);
      }
    }

    // Draw RH % line (Cyan)
    final rhPaint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.7)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    canvas.drawPath(pathRh, rhPaint);

    // Draw T_min line (Blue)
    final tMinPaint = Paint()
      ..color = Colors.lightBlue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(pathTMin, tMinPaint);

    // Draw T_max line (Orange / Red)
    final tMaxPaint = Paint()
      ..color = Colors.deepOrangeAccent
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(pathTMax, tMaxPaint);

    // Legends at top, evenly spaced across the actual canvas width instead of
    // fixed +80/+160 offsets that overrun narrow (phone-width) chart cards.
    final legendSlot = w / 3;
    _drawLegend(canvas, padL, 4, legendTMax, Colors.deepOrangeAccent);
    _drawLegend(canvas, padL + legendSlot, 4, legendTMin, Colors.lightBlue);
    _drawLegend(canvas, padL + legendSlot * 2, 4, legendHumidity, Colors.cyan);
  }

  void _drawLegend(Canvas canvas, double x, double y, String label, Color color) {
    canvas.drawCircle(Offset(x + 4, y + 5), 3, Paint()..color = color);
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
          fontFamily: 'Ubuntu Sans Mono',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x + 12, y));
  }

  @override
  bool shouldRepaint(covariant _ThermalHumidityPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Water Balance & Radiation (Rainfall Bars + Radiation Curve)
// ─────────────────────────────────────────────────────────────────────────────

class WaterRadiationChart extends StatelessWidget {
  final List<DailyWeatherRecord> records;
  final bool isDark;
  final OryzaStrings s;

  const WaterRadiationChart({
    super.key,
    required this.records,
    required this.isDark,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...records]..sort((a, b) => a.date.compareTo(b.date));

    return CustomPaint(
      size: Size.infinite,
      painter: _WaterRadiationPainter(records: sorted, isDark: isDark, legend: s.chartLegendWaterRadiation),
    );
  }
}

class _WaterRadiationPainter extends CustomPainter {
  final List<DailyWeatherRecord> records;
  final bool isDark;
  final String legend;

  _WaterRadiationPainter({required this.records, required this.isDark, required this.legend});

  @override
  void paint(Canvas canvas, Size size) {
    const padL = 36.0;
    const padB = 24.0;
    final w = size.width - padL;
    final h = size.height - padB;

    if (records.isEmpty) return;

    double maxRain = 20.0;
    for (final r in records) {
      if ((r.precipitationMm ?? 0.0) > maxRain) maxRain = r.precipitationMm ?? 0.0;
    }
    maxRain *= 1.1;

    final n = records.length;
    final barW = (w / n) * 0.65;
    final stepX = w / n;

    // Draw rainfall bars
    final rainPaint = Paint()..color = Colors.blue.withValues(alpha: 0.6);
    for (int i = 0; i < n; i++) {
      final r = records[i];
      final x = padL + (i * stepX) + (stepX - barW) / 2;
      final barH = h * ((r.precipitationMm ?? 0.0) / maxRain);
      final y = h - barH;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barW, barH),
          const Radius.circular(2),
        ),
        rainPaint,
      );
    }

    // Draw Radiation curve (0 to 30 MJ/m²)
    if (records.length > 1) {
      final radPath = Path();
      const maxRad = 30.0;

      for (int i = 0; i < n; i++) {
        final r = records[i];
        final x = padL + (i * stepX) + stepX / 2;
        final y = h - (h * ((r.radiationMjM2 ?? 0.0) / maxRad).clamp(0.0, 1.0));

        if (i == 0) {
          radPath.moveTo(x, y);
        } else {
          radPath.lineTo(x, y);
        }
      }

      final radPaint = Paint()
        ..color = Colors.amber.shade700
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      canvas.drawPath(radPath, radPaint);
    }

    // Legend
    final tp = TextPainter(
      text: TextSpan(
        text: legend,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
          fontFamily: 'Ubuntu Sans Mono',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, const Offset(padL, 4));
  }

  @override
  bool shouldRepaint(covariant _WaterRadiationPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. DTR Thermal Amplitude Band Chart
// ─────────────────────────────────────────────────────────────────────────────

class DtrBandChart extends StatelessWidget {
  final List<DailyWeatherRecord> records;
  final bool isDark;
  final OryzaStrings s;

  const DtrBandChart({
    super.key,
    required this.records,
    required this.isDark,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...records]..sort((a, b) => a.date.compareTo(b.date));

    return CustomPaint(
      size: Size.infinite,
      painter: _DtrBandPainter(records: sorted, isDark: isDark, legend: s.chartLegendDtrBand),
    );
  }
}

class _DtrBandPainter extends CustomPainter {
  final List<DailyWeatherRecord> records;
  final bool isDark;
  final String legend;

  _DtrBandPainter({required this.records, required this.isDark, required this.legend});

  @override
  void paint(Canvas canvas, Size size) {
    const padL = 36.0;
    const padB = 24.0;
    final w = size.width - padL;
    final h = size.height - padB;

    if (records.length < 2) return;

    const minT = 15.0;
    const maxT = 42.0;

    final n = records.length;
    final stepX = w / (n - 1);

    final List<Offset> upperPoints = [];
    final List<Offset> lowerPoints = [];

    for (int i = 0; i < n; i++) {
      final r = records[i];
      final x = padL + (i * stepX);
      final yTop = h - (h * ((r.tMax! - minT) / (maxT - minT)).clamp(0.0, 1.0));
      final yBot = h - (h * ((r.tMin! - minT) / (maxT - minT)).clamp(0.0, 1.0));

      upperPoints.add(Offset(x, yTop));
      lowerPoints.add(Offset(x, yBot));
    }

    final bandPath = Path();
    bandPath.moveTo(upperPoints.first.dx, upperPoints.first.dy);
    for (final pt in upperPoints) {
      bandPath.lineTo(pt.dx, pt.dy);
    }
    for (int i = lowerPoints.length - 1; i >= 0; i--) {
      bandPath.lineTo(lowerPoints[i].dx, lowerPoints[i].dy);
    }
    bandPath.close();

    // Fill the thermal amplitude band
    final bandPaint = Paint()
      ..color = Colors.orange.withValues(alpha: isDark ? 0.25 : 0.18)
      ..style = PaintingStyle.fill;
    canvas.drawPath(bandPath, bandPaint);

    // Draw borders
    final topBorder = Paint()
      ..color = Colors.deepOrange
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    final botBorder = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final topPath = Path()..moveTo(upperPoints.first.dx, upperPoints.first.dy);
    for (final pt in upperPoints) {
      topPath.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(topPath, topBorder);

    final botPath = Path()..moveTo(lowerPoints.first.dx, lowerPoints.first.dy);
    for (final pt in lowerPoints) {
      botPath.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(botPath, botBorder);

    // Legend
    final tp = TextPainter(
      text: TextSpan(
        text: legend,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
          fontFamily: 'Ubuntu Sans Mono',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, const Offset(padL, 4));
  }

  @override
  bool shouldRepaint(covariant _DtrBandPainter oldDelegate) => true;
}
