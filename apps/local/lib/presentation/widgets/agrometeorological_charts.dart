import 'package:flutter/material.dart';
import 'package:local/domain/models/weather_record.dart';

/// Senior agrometeorological charts: GDD curve, dual thermal trend, water balance & DTR band.
class AgrometeorologicalCharts extends StatelessWidget {
  final List<DailyWeatherRecord> records;

  const AgrometeorologicalCharts({
    super.key,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (records.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.show_chart, size: 48, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
              const SizedBox(height: 12),
              const Text(
                'Série meteorológica insuficiente para renderização gráfica.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              const Text(
                'Importe um arquivo CSV ou conecte um sensor na seção de ingestão abaixo.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row 1: GDD Curve + Dual Thermal Trend
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildChartBox(
                      context,
                      title: 'CURVA DE GRAUS-DIA ACUMULADOS (GDD BASE 10°C)',
                      subtitle: 'Soma térmica acumulada (°C-dia) e marcos fenológicos',
                      icon: Icons.trending_up,
                      child: GddAccumulationChart(records: records, isDark: isDark),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildChartBox(
                      context,
                      title: 'DINÂMICA TÉRMICA E UMIDADE RELATIVA',
                      subtitle: 'T_max, T_min (°C) e Umidade Relativa do Ar (%)',
                      icon: Icons.thermostat_outlined,
                      child: ThermalHumidityChart(records: records, isDark: isDark),
                    ),
                  ),
                ],
              )
            else ...[
              _buildChartBox(
                context,
                title: 'CURVA DE GRAUS-DIA ACUMULADOS (GDD BASE 10°C)',
                subtitle: 'Soma térmica acumulada (°C-dia) e marcos fenológicos',
                icon: Icons.trending_up,
                child: GddAccumulationChart(records: records, isDark: isDark),
              ),
              const SizedBox(height: 16),
              _buildChartBox(
                context,
                title: 'DINÂMICA TÉRMICA E UMIDADE RELATIVA',
                subtitle: 'T_max, T_min (°C) e Umidade Relativa do Ar (%)',
                icon: Icons.thermostat_outlined,
                child: ThermalHumidityChart(records: records, isDark: isDark),
              ),
            ],

            const SizedBox(height: 16),

            // Row 2: Water Balance + DTR Thermal Amplitude Band
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildChartBox(
                      context,
                      title: 'BALANÇO HÍDRICO E RADIAÇÃO SOLAR',
                      subtitle: 'Precipitação diária (barras mm) vs Radiação Global (linha MJ/m²)',
                      icon: Icons.water_drop,
                      child: WaterRadiationChart(records: records, isDark: isDark),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildChartBox(
                      context,
                      title: 'AMPLITUDE TÉRMICA DIURNA (FAIXA DTR)',
                      subtitle: 'Gradiente diurno T_max - T_min e pulso térmico foliar',
                      icon: Icons.waves,
                      child: DtrBandChart(records: records, isDark: isDark),
                    ),
                  ),
                ],
              )
            else ...[
              _buildChartBox(
                context,
                title: 'BALANÇO HÍDRICO E RADIAÇÃO SOLAR',
                subtitle: 'Precipitação diária (barras mm) vs Radiação Global (linha MJ/m²)',
                icon: Icons.water_drop,
                child: WaterRadiationChart(records: records, isDark: isDark),
              ),
              const SizedBox(height: 16),
              _buildChartBox(
                context,
                title: 'AMPLITUDE TÉRMICA DIURNA (FAIXA DTR)',
                subtitle: 'Gradiente diurno T_max - T_min e pulso térmico foliar',
                icon: Icons.waves,
                child: DtrBandChart(records: records, isDark: isDark),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildChartBox(
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
          SizedBox(height: 220, child: child),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. GDD Accumulation Curve (Line + Gradient Area)
// ─────────────────────────────────────────────────────────────────────────────

class GddAccumulationChart extends StatelessWidget {
  final List<DailyWeatherRecord> records;
  final bool isDark;

  const GddAccumulationChart({
    super.key,
    required this.records,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Sort chronologically ascending
    final sorted = [...records]..sort((a, b) => a.date.compareTo(b.date));

    // Calculate cumulative GDD
    double cumGdd = 0.0;
    final List<double> cumSeries = [];
    for (final r in sorted) {
      cumGdd += r.dailyGdd(10.0);
      cumSeries.add(cumGdd);
    }

    final maxVal = cumGdd > 0 ? cumGdd * 1.15 : 100.0;

    return CustomPaint(
      size: Size.infinite,
      painter: _GddPainter(
        cumSeries: cumSeries,
        maxVal: maxVal,
        isDark: isDark,
      ),
    );
  }
}

class _GddPainter extends CustomPainter {
  final List<double> cumSeries;
  final double maxVal;
  final bool isDark;

  _GddPainter({
    required this.cumSeries,
    required this.maxVal,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const padL = 40.0;
    const padB = 24.0;
    final w = size.width - padL;
    final h = size.height - padB;

    final gridPaint = Paint()
      ..color = isDark ? Colors.white10 : Colors.black12
      ..strokeWidth = 1.0;

    final textStyle = TextStyle(
      fontSize: 9,
      fontFamily: 'Ubuntu Sans Mono',
      color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
    );

    // Draw horizontal grid lines (4 levels)
    for (int i = 0; i <= 4; i++) {
      final y = h - (h * (i / 4.0));
      canvas.drawLine(Offset(padL, y), Offset(size.width, y), gridPaint);
      final label = ((maxVal * (i / 4.0))).toStringAsFixed(0);
      final tp = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(padL - tp.width - 4, y - tp.height / 2));
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
        text: 'Total: ${lastVal.toStringAsFixed(1)} °C-d',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.greenAccent : Colors.green.shade900,
          fontFamily: 'Ubuntu Sans Mono',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    totalTp.paint(canvas, Offset(lastX - totalTp.width - 8, lastY - 14));
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

  const ThermalHumidityChart({
    super.key,
    required this.records,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...records]..sort((a, b) => a.date.compareTo(b.date));

    return CustomPaint(
      size: Size.infinite,
      painter: _ThermalHumidityPainter(
        records: sorted,
        isDark: isDark,
      ),
    );
  }
}

class _ThermalHumidityPainter extends CustomPainter {
  final List<DailyWeatherRecord> records;
  final bool isDark;

  _ThermalHumidityPainter({required this.records, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
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

      final yMax = h - (h * ((r.tMax - minT) / (maxT - minT)).clamp(0.0, 1.0));
      final yMin = h - (h * ((r.tMin - minT) / (maxT - minT)).clamp(0.0, 1.0));
      final yRh = h - (h * ((r.relativeHumidityPct - minRh) / (maxRh - minRh)).clamp(0.0, 1.0));

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

    // Legends at top
    _drawLegend(canvas, padL, 4, 'T_max (°C)', Colors.deepOrangeAccent);
    _drawLegend(canvas, padL + 80, 4, 'T_min (°C)', Colors.lightBlue);
    _drawLegend(canvas, padL + 160, 4, 'Umidade (%)', Colors.cyan);
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

  const WaterRadiationChart({
    super.key,
    required this.records,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...records]..sort((a, b) => a.date.compareTo(b.date));

    return CustomPaint(
      size: Size.infinite,
      painter: _WaterRadiationPainter(records: sorted, isDark: isDark),
    );
  }
}

class _WaterRadiationPainter extends CustomPainter {
  final List<DailyWeatherRecord> records;
  final bool isDark;

  _WaterRadiationPainter({required this.records, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    const padL = 36.0;
    const padB = 24.0;
    final w = size.width - padL;
    final h = size.height - padB;

    if (records.isEmpty) return;

    double maxRain = 20.0;
    for (final r in records) {
      if (r.precipitationMm > maxRain) maxRain = r.precipitationMm;
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
      final barH = h * (r.precipitationMm / maxRain);
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
        final y = h - (h * (r.radiationMjM2 / maxRad).clamp(0.0, 1.0));

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
        text: 'Barras: Chuva (mm) | Linha: Radiação Solar (MJ/m²)',
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

  const DtrBandChart({
    super.key,
    required this.records,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...records]..sort((a, b) => a.date.compareTo(b.date));

    return CustomPaint(
      size: Size.infinite,
      painter: _DtrBandPainter(records: sorted, isDark: isDark),
    );
  }
}

class _DtrBandPainter extends CustomPainter {
  final List<DailyWeatherRecord> records;
  final bool isDark;

  _DtrBandPainter({required this.records, required this.isDark});

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
      final yTop = h - (h * ((r.tMax - minT) / (maxT - minT)).clamp(0.0, 1.0));
      final yBot = h - (h * ((r.tMin - minT) / (maxT - minT)).clamp(0.0, 1.0));

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
        text: 'Faixa Sombreada: Amplitude DTR (T_max - T_min)',
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
