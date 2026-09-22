import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class BenchmarkScreen extends StatefulWidget {
  final bool isDark;

  const BenchmarkScreen({
    super.key,
    required this.isDark,
  });

  @override
  State<BenchmarkScreen> createState() => _BenchmarkScreenState();
}

class _BenchmarkScreenState extends State<BenchmarkScreen> {
  int _selectedMapCountry = 0; // 0: Brazil, 1: Thailand
  int _selectedBarMetric = 0; // 0: Latency, 1: Power
  final ScrollController _tableScrollController = ScrollController();

  @override
  void dispose() {
    _tableScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final textPrimary = widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      constraints: const BoxConstraints(maxWidth: 1600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header & Tag
          _buildHeader(s, textPrimary, textSecondary),
          const SizedBox(height: 32),

          // 2. 4 Quick KPI Summary Badges
          _buildKpiGrid(s),
          const SizedBox(height: 48),

          // 3. Matriz Comparativa Completa (Comparison Table)
          _buildComparisonTableSection(s, textPrimary, textSecondary),
          const SizedBox(height: 56),

          // 4. Seção de Gráficos (GDD Line Chart & Efficiency Bar Chart)
          _buildChartsSection(s, textPrimary, textSecondary),
          const SizedBox(height: 56),

          // 5. Mapa Cartográfico Agnóstico da Produção Global de Arroz
          _buildAgnosticMapSection(s, textPrimary, textSecondary),
          const SizedBox(height: 56),

          // 6. Avaliações da Comunidade Científica e GitHub
          _buildCommunityQuotesSection(s, textPrimary, textSecondary),
        ],
      ),
    );
  }

  // --- HEADER & KPIS ---

  Widget _buildHeader(OryzaStrings s, Color textPrimary, Color textSecondary) {
    final tagColor = widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: widget.isDark ? OryzaColors.darkSurface : OryzaColors.botanicalGreenLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.botanicalGreenBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: tagColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  s.benchmarkSectionTag,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: tagColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          s.benchmarkTitle,
          style: TextStyle(
            fontFamily: OryzaTypography.fontFamily,
            package: 'oryzaelo_ui',
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Text(
            s.benchmarkSubtitle,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 15,
              height: 1.5,
              color: textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiGrid(OryzaStrings s) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 960;
        final isMedium = constraints.maxWidth >= 540;

        final kpi1 = _KpiBadge(
          value: s.benchmarkMetricLatencyVal,
          title: s.benchmarkMetricLatencyTitle,
          sub: s.benchmarkMetricLatencySub,
          icon: Icons.speed_outlined,
          accentColor: OryzaColors.burntOrange,
          isDark: widget.isDark,
        );
        final kpi2 = _KpiBadge(
          value: s.benchmarkMetricPowerVal,
          title: s.benchmarkMetricPowerTitle,
          sub: s.benchmarkMetricPowerSub,
          icon: Icons.bolt_outlined,
          accentColor: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
          isDark: widget.isDark,
        );
        final kpi3 = _KpiBadge(
          value: s.benchmarkMetricAccuracyVal,
          title: s.benchmarkMetricAccuracyTitle,
          sub: s.benchmarkMetricAccuracySub,
          icon: Icons.verified_outlined,
          accentColor: OryzaColors.burntOrange,
          isDark: widget.isDark,
        );
        final kpi4 = _KpiBadge(
          value: s.benchmarkMetricOfflineVal,
          title: s.benchmarkMetricOfflineTitle,
          sub: s.benchmarkMetricOfflineSub,
          icon: Icons.cloud_off_outlined,
          accentColor: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
          isDark: widget.isDark,
        );

        if (isWide) {
          return Row(
            children: [
              Expanded(child: kpi1),
              const SizedBox(width: 16),
              Expanded(child: kpi2),
              const SizedBox(width: 16),
              Expanded(child: kpi3),
              const SizedBox(width: 16),
              Expanded(child: kpi4),
            ],
          );
        }

        if (isMedium) {
          final width = (constraints.maxWidth - 16) / 2;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(width: width, child: kpi1),
              SizedBox(width: width, child: kpi2),
              SizedBox(width: width, child: kpi3),
              SizedBox(width: width, child: kpi4),
            ],
          );
        }

        return Column(
          children: [
            kpi1,
            const SizedBox(height: 12),
            kpi2,
            const SizedBox(height: 12),
            kpi3,
            const SizedBox(height: 12),
            kpi4,
          ],
        );
      },
    );
  }

  // --- MATRIZ COMPARATIVA ---

  Widget _buildComparisonTableSection(OryzaStrings s, Color textPrimary, Color textSecondary) {
    final borderColor = widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final surfaceColor = widget.isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final highlightHeaderColor = widget.isDark
        ? OryzaColors.burntOrange.withValues(alpha: 0.18)
        : OryzaColors.botanicalGreenLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.table_chart_outlined, size: 20, color: OryzaColors.burntOrange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                s.benchmarkTableHeading,
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          s.benchmarkTableSubheading,
          style: TextStyle(
            fontFamily: OryzaTypography.fontFamily,
            package: 'oryzaelo_ui',
            fontSize: 13.5,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 16),

        // Mobile swipe indicator cue
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: widget.isDark ? const Color(0xFF182218) : const Color(0xFFEBE6D6),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.swipe_outlined, size: 15, color: OryzaColors.burntOrange),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  s.benchmarkSwipeHint,
                  style: TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scrollable Table Container
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: LayoutBuilder(
            builder: (context, tableConstraints) {
              final availableWidth = tableConstraints.maxWidth;
              // Margins and internal padding:
              // horizontalMargin = 20 on each side (40px)
              // 4 column spacings of 24px (96px)
              // Total non-column width = 136px
              final netAvailable = math.max(844.0, availableWidth - 136.0);
              final col0Width = math.max(170.0, netAvailable * 0.21);
              final col1Width = math.max(200.0, netAvailable * 0.25);
              final col2Width = math.max(160.0, netAvailable * 0.18);
              final col3Width = math.max(160.0, netAvailable * 0.18);
              final col4Width = math.max(160.0, netAvailable * 0.18);
              final minTableWidth = col0Width + col1Width + col2Width + col3Width + col4Width + 136.0;

              return Scrollbar(
                controller: _tableScrollController,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: _tableScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: minTableWidth),
                    child: DataTable(
                      headingRowHeight: 52,
                      dataRowMinHeight: 56,
                      dataRowMaxHeight: 76,
                      columnSpacing: 24,
                      horizontalMargin: 20,
                      headingRowColor: WidgetStateProperty.all(
                        widget.isDark
                            ? const Color(0xFF1D1815)
                            : const Color(0xFFEBE6D6),
                      ),
                      columns: [
                        DataColumn(
                          label: SizedBox(
                            width: col0Width,
                            child: Text(
                              s.benchmarkColCriterion.toUpperCase(),
                              style: TextStyle(
                                fontFamily: OryzaTypography.monoFontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: col1Width,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: highlightHeaderColor,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: widget.isDark ? OryzaColors.burntOrange : OryzaColors.botanicalGreen,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 13,
                                      color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        s.benchmarkColOryza.toUpperCase(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: OryzaTypography.monoFontFamily,
                                          package: 'oryzaelo_ui',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: widget.isDark ? OryzaColors.burntOrange : OryzaColors.botanicalGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: col2Width,
                            child: Text(
                              s.benchmarkColSatellite.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: OryzaTypography.monoFontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: textSecondary,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: col3Width,
                            child: Text(
                              s.benchmarkColDrone.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: OryzaTypography.monoFontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: textSecondary,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: col4Width,
                            child: Text(
                              s.benchmarkColCloudWeather.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: OryzaTypography.monoFontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: [
                        _buildRow(s.benchmarkRowLatencyTitle, s.benchmarkRowLatencyOryza, s.benchmarkRowLatencySatellite, s.benchmarkRowLatencyDrone, s.benchmarkRowLatencyCloudWeather, textPrimary, textSecondary, true, col0Width, col1Width, col2Width, col3Width, col4Width),
                        _buildRow(s.benchmarkRowCloudTitle, s.benchmarkRowCloudOryza, s.benchmarkRowCloudSatellite, s.benchmarkRowCloudDrone, s.benchmarkRowCloudCloudWeather, textPrimary, textSecondary, false, col0Width, col1Width, col2Width, col3Width, col4Width),
                        _buildRow(s.benchmarkRowOcclusionTitle, s.benchmarkRowOcclusionOryza, s.benchmarkRowOcclusionSatellite, s.benchmarkRowOcclusionDrone, s.benchmarkRowOcclusionCloudWeather, textPrimary, textSecondary, true, col0Width, col1Width, col2Width, col3Width, col4Width),
                        _buildRow(s.benchmarkRowPowerTitle, s.benchmarkRowPowerOryza, s.benchmarkRowPowerSatellite, s.benchmarkRowPowerDrone, s.benchmarkRowPowerCloudWeather, textPrimary, textSecondary, false, col0Width, col1Width, col2Width, col3Width, col4Width),
                        _buildRow(s.benchmarkRowCostTitle, s.benchmarkRowCostOryza, s.benchmarkRowCostSatellite, s.benchmarkRowCostDrone, s.benchmarkRowCostCloudWeather, textPrimary, textSecondary, true, col0Width, col1Width, col2Width, col3Width, col4Width),
                        _buildRow(s.benchmarkRowTemporalTitle, s.benchmarkRowTemporalOryza, s.benchmarkRowTemporalSatellite, s.benchmarkRowTemporalDrone, s.benchmarkRowTemporalCloudWeather, textPrimary, textSecondary, false, col0Width, col1Width, col2Width, col3Width, col4Width),
                        _buildRow(s.benchmarkRowConnectivityTitle, s.benchmarkRowConnectivityOryza, s.benchmarkRowConnectivitySatellite, s.benchmarkRowConnectivityDrone, s.benchmarkRowConnectivityCloudWeather, textPrimary, textSecondary, true, col0Width, col1Width, col2Width, col3Width, col4Width),
                        _buildRow(s.benchmarkRowPrivacyTitle, s.benchmarkRowPrivacyOryza, s.benchmarkRowPrivacySatellite, s.benchmarkRowPrivacyDrone, s.benchmarkRowPrivacyCloudWeather, textPrimary, textSecondary, false, col0Width, col1Width, col2Width, col3Width, col4Width),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  DataRow _buildRow(
    String criterion,
    String oryzaVal,
    String satelliteVal,
    String droneVal,
    String cloudVal,
    Color textPrimary,
    Color textSecondary,
    bool isZebra,
    double col0Width,
    double col1Width,
    double col2Width,
    double col3Width,
    double col4Width,
  ) {
    final zebraColor = widget.isDark
        ? const Color(0xFF181411).withValues(alpha: 0.5)
        : const Color(0xFFF1EDE0).withValues(alpha: 0.4);

    return DataRow(
      color: WidgetStateProperty.all(isZebra ? zebraColor : Colors.transparent),
      cells: [
        DataCell(
          SizedBox(
            width: col0Width,
            child: Text(
              criterion,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: col1Width,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.isDark
                      ? OryzaColors.burntOrange.withValues(alpha: 0.12)
                      : OryzaColors.botanicalGreenLight.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  oryzaVal,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                  ),
                ),
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: col2Width,
            child: Text(
              satelliteVal,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 12,
                color: textSecondary,
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: col3Width,
            child: Text(
              droneVal,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 12,
                color: textSecondary,
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: col4Width,
            child: Text(
              cloudVal,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 12,
                color: textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- SEÇÃO DE GRÁFICOS ---

  Widget _buildChartsSection(OryzaStrings s, Color textPrimary, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.show_chart_outlined, size: 20, color: OryzaColors.burntOrange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                s.benchmarkChartsHeading,
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          s.benchmarkChartsSubheading,
          style: TextStyle(
            fontFamily: OryzaTypography.fontFamily,
            package: 'oryzaelo_ui',
            fontSize: 13.5,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 20),

        LayoutBuilder(
          builder: (context, constraints) {
            final isTwoCols = constraints.maxWidth >= 980;

            final lineChartCard = _buildLineChartCard(s, textPrimary, textSecondary);
            final barChartCard = _buildBarChartCard(s, textPrimary, textSecondary);

            if (isTwoCols) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: lineChartCard),
                  const SizedBox(width: 20),
                  Expanded(flex: 5, child: barChartCard),
                ],
              );
            }

            return Column(
              children: [
                lineChartCard,
                const SizedBox(height: 20),
                barChartCard,
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildLineChartCard(OryzaStrings s, Color textPrimary, Color textSecondary) {
    final borderColor = widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final surfaceColor = widget.isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  s.benchmarkLineChartTitle,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: widget.isDark ? const Color(0xFF28201A) : const Color(0xFFE4DFCF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "DAE 0 a 120 dias",
                  style: TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            s.benchmarkLineChartSub,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 12,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Custom Painted GDD Line Chart
          SizedBox(
            height: 240,
            width: double.infinity,
            child: CustomPaint(
              painter: _GddLineChartPainter(
                isDark: widget.isDark,
                textSecondaryColor: textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Chart Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem(
                label: s.benchmarkLineLegendBrazil,
                color: OryzaColors.burntOrange,
              ),
              _buildLegendItem(
                label: s.benchmarkLineLegendThai,
                color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
              ),
              _buildLegendItem(
                label: s.benchmarkLineLegendTheoretical,
                color: textSecondary.withValues(alpha: 0.6),
                isDashed: true,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // BBCH Event Milestones Row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF181411) : const Color(0xFFF3EFE4),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 440),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBbchBadge("BBCH 10", "DAE 12", s.benchmarkBbch10Stage),
                    _buildBbchBadge("BBCH 21", "DAE 32", s.benchmarkBbch21Stage),
                    _buildBbchBadge("BBCH 51", "DAE 65", s.benchmarkBbch51Stage),
                    _buildBbchBadge("BBCH 65", "DAE 80", s.benchmarkBbch65Stage),
                    _buildBbchBadge("BBCH 87", "DAE 110", s.benchmarkBbch87Stage),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBbchBadge(String stage, String dae, String desc) {
    return Column(
      children: [
        Text(
          stage,
          style: TextStyle(
            fontFamily: OryzaTypography.monoFontFamily,
            package: 'oryzaelo_ui',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: OryzaColors.burntOrange,
          ),
        ),
        Text(
          dae,
          style: TextStyle(
            fontFamily: OryzaTypography.monoFontFamily,
            package: 'oryzaelo_ui',
            fontSize: 9,
            color: widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required String label,
    required Color color,
    bool isDashed = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth.isFinite ? constraints.maxWidth : 280.0;
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxW),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 3,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 11,
                    color: widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBarChartCard(OryzaStrings s, Color textPrimary, Color textSecondary) {
    final borderColor = widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final surfaceColor = widget.isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  s.benchmarkBarChartTitle,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Metric Toggle
              Container(
                decoration: BoxDecoration(
                  color: widget.isDark ? const Color(0xFF28201A) : const Color(0xFFE4DFCF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToggleBtn(s.benchmarkBarTabLatency, _selectedBarMetric == 0, () {
                      setState(() => _selectedBarMetric = 0);
                    }),
                    _buildToggleBtn(s.benchmarkBarTabPower, _selectedBarMetric == 1, () {
                      setState(() => _selectedBarMetric = 1);
                    }),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            s.benchmarkBarChartSub,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 12,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // 4 Bars Comparison
          if (_selectedBarMetric == 0) ...[
            _buildBarRow(s.benchmarkBarArchOryza, "22.4 µs (0.022 ms)", 0.05, OryzaColors.burntOrange, isBest: true),
            const SizedBox(height: 14),
            _buildBarRow(s.benchmarkBarArchCoral, "180 µs (0.180 ms)", 0.18, widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen),
            const SizedBox(height: 14),
            _buildBarRow(s.benchmarkBarArchPython, "14.8 ms (14,800 µs)", 0.65, textSecondary.withValues(alpha: 0.7)),
            const SizedBox(height: 14),
            _buildBarRow(s.benchmarkBarArchCloud, "240.0 ms (240,000 µs)", 1.0, textSecondary.withValues(alpha: 0.4)),
          ] else ...[
            _buildBarRow(s.benchmarkBarPowerOryza, "0.45W (com deep sleep)", 0.08, OryzaColors.burntOrange, isBest: true),
            const SizedBox(height: 14),
            _buildBarRow(s.benchmarkBarPowerCoral, s.benchmarkBarPowerCoralDesc, 0.22, widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen),
            const SizedBox(height: 14),
            _buildBarRow(s.benchmarkBarPowerPython, s.benchmarkBarPowerPythonDesc, 0.55, textSecondary.withValues(alpha: 0.7)),
            const SizedBox(height: 14),
            _buildBarRow(s.benchmarkBarPowerCloud, s.benchmarkBarPowerCloudDesc, 1.0, textSecondary.withValues(alpha: 0.4)),
          ],

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF181411) : const Color(0xFFF3EFE4),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.bolt, size: 16, color: OryzaColors.burntOrange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.benchmarkBarFooterNote,
                    style: TextStyle(
                      fontFamily: OryzaTypography.fontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 11.5,
                      color: textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? OryzaColors.burntOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: OryzaTypography.monoFontFamily,
            package: 'oryzaelo_ui',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : (widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildBarRow(String label, String value, double fraction, Color color, {bool isBest = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (isBest) ...[
                    Icon(Icons.check_circle, size: 13, color: color),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 12,
                        fontWeight: isBest ? FontWeight.w700 : FontWeight.w500,
                        color: widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                fontFamily: OryzaTypography.monoFontFamily,
                package: 'oryzaelo_ui',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 7,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.isDark ? const Color(0xFF221C18) : const Color(0xFFE2DDD0),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: fraction.clamp(0.02, 1.0),
              child: Container(
                height: 7,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- MAPA CARTOGRÁFICO AGNÓSTICO ---

  Widget _buildAgnosticMapSection(OryzaStrings s, Color textPrimary, Color textSecondary) {
    final borderColor = widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final surfaceColor = widget.isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.public_outlined, size: 20, color: OryzaColors.burntOrange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                s.benchmarkMapHeading,
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          s.benchmarkMapSubheading,
          style: TextStyle(
            fontFamily: OryzaTypography.fontFamily,
            package: 'oryzaelo_ui',
            fontSize: 13.5,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 20),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              // Vector Open-Source Agnostic Map Canvas
              LayoutBuilder(
                builder: (context, mapBoxConstraints) {
                  final isNarrow = mapBoxConstraints.maxWidth < 620;
                  final mapHeight = isNarrow ? 350.0 : 320.0;

                  return SizedBox(
                    height: mapHeight,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      child: Stack(
                        children: [
                          // Cartographic Painter
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _AgnosticMapPainter(
                                isDark: widget.isDark,
                                selectedCountry: _selectedMapCountry,
                              ),
                            ),
                          ),
                          // Responsive Map Header: Badges & Country Switcher (No Mobile Overlap)
                          Positioned(
                            top: 12,
                            left: 14,
                            right: 14,
                            child: LayoutBuilder(
                              builder: (context, mapHeaderConstraints) {
                                final isMobile = mapHeaderConstraints.maxWidth < 620;

                                final tagWidget = Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (widget.isDark ? OryzaColors.darkCanvas : OryzaColors.lightCanvas).withValues(alpha: 0.88),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Text(
                                    s.benchmarkMapFooterTag,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: OryzaTypography.monoFontFamily,
                                      package: 'oryzaelo_ui',
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: textSecondary,
                                    ),
                                  ),
                                );

                                if (isMobile) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      tagWidget,
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 6,
                                        children: [
                                          _buildMapSelectPill(s.benchmarkMapLegendBrazil, _selectedMapCountry == 0, () {
                                            setState(() => _selectedMapCountry = 0);
                                          }),
                                          _buildMapSelectPill(s.benchmarkMapLegendThai, _selectedMapCountry == 1, () {
                                            setState(() => _selectedMapCountry = 1);
                                          }),
                                        ],
                                      ),
                                    ],
                                  );
                                }

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(child: tagWidget),
                                    const SizedBox(width: 12),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildMapSelectPill(s.benchmarkMapLegendBrazil, _selectedMapCountry == 0, () {
                                          setState(() => _selectedMapCountry = 0);
                                        }),
                                        const SizedBox(width: 8),
                                        _buildMapSelectPill(s.benchmarkMapLegendThai, _selectedMapCountry == 1, () {
                                          setState(() => _selectedMapCountry = 1);
                                        }),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Country Stats Breakdown Cards below Map
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: borderColor)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isTwoCols = constraints.maxWidth >= 760;

                    final brazilCard = _buildCountryStatsCard(
                      title: s.benchmarkMapBrazilTitle,
                      coords: s.benchmarkMapBrazilCoords,
                      production: s.benchmarkMapBrazilProduction,
                      yieldVal: s.benchmarkMapBrazilYield,
                      climate: s.benchmarkMapBrazilClimate,
                      tech: s.benchmarkMapBrazilTech,
                      sourceLabel: s.benchmarkGovSourceLabel,
                      source: s.benchmarkMapBrazilSource,
                      sourceUrl: s.benchmarkMapBrazilUrl,
                      accentColor: OryzaColors.burntOrange,
                      isSelected: _selectedMapCountry == 0,
                      onTap: () => setState(() => _selectedMapCountry = 0),
                    );

                    final thaiCard = _buildCountryStatsCard(
                      title: s.benchmarkMapThaiTitle,
                      coords: s.benchmarkMapThaiCoords,
                      production: s.benchmarkMapThaiProduction,
                      yieldVal: s.benchmarkMapThaiYield,
                      climate: s.benchmarkMapThaiClimate,
                      tech: s.benchmarkMapThaiTech,
                      sourceLabel: s.benchmarkGovSourceLabel,
                      source: s.benchmarkMapThaiSource,
                      sourceUrl: s.benchmarkMapThaiUrl,
                      accentColor: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                      isSelected: _selectedMapCountry == 1,
                      onTap: () => setState(() => _selectedMapCountry = 1),
                    );

                    if (isTwoCols) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: brazilCard),
                          const SizedBox(width: 20),
                          Expanded(child: thaiCard),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        brazilCard,
                        const SizedBox(height: 16),
                        thaiCard,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapSelectPill(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? OryzaColors.burntOrange
              : (widget.isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? OryzaColors.burntOrange : (widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: OryzaTypography.monoFontFamily,
            package: 'oryzaelo_ui',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : (widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary),
          ),
        ),
      ),
    );
  }

  Widget _buildCountryStatsCard({
    required String title,
    required String coords,
    required String production,
    required String yieldVal,
    required String climate,
    required String tech,
    required String sourceLabel,
    required String source,
    required String sourceUrl,
    required Color accentColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final textPrimary = widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (widget.isDark ? const Color(0xFF1D1815) : const Color(0xFFEBE6D6))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? accentColor : (widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                coords,
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildStatLine(Icons.agriculture_outlined, production, textSecondary),
            const SizedBox(height: 6),
            _buildStatLine(Icons.trending_up, yieldVal, textSecondary),
            const SizedBox(height: 6),
            _buildStatLine(Icons.wb_sunny_outlined, climate, textSecondary),
            const SizedBox(height: 6),
            _buildStatLine(Icons.science_outlined, tech, textSecondary),
            const SizedBox(height: 6),
            _buildStatLine(Icons.verified_outlined, "$sourceLabel $source", textSecondary),
            const SizedBox(height: 4),
            _buildStatLine(Icons.link_outlined, sourceUrl, accentColor, isUrl: true),
          ],
        ),
      ),
    );
  }

  Widget _buildStatLine(IconData icon, String text, Color color, {bool isUrl = false}) {
    final uri = isUrl ? Uri.tryParse(text) : null;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isUrl)
          InkWell(
            onTap: uri != null ? () => launchUrl(uri, mode: LaunchMode.externalApplication) : null,
            child: Icon(icon, size: 14, color: OryzaColors.burntOrange),
          )
        else
          Icon(icon, size: 14, color: OryzaColors.burntOrange),
        const SizedBox(width: 8),
        Expanded(
          child: isUrl
              ? SelectableText(
                  text,
                  onTap: uri != null ? () => launchUrl(uri, mode: LaunchMode.externalApplication) : null,
                  style: TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 12,
                    height: 1.4,
                    color: color,
                    decoration: TextDecoration.underline,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 12,
                    height: 1.4,
                    color: color,
                  ),
                ),
        ),
      ],
    );
  }

  // --- REPERCUSSÃO DA COMUNIDADE & QUOTES ---

  Widget _buildCommunityQuotesSection(OryzaStrings s, Color textPrimary, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.forum_outlined, size: 20, color: OryzaColors.burntOrange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                s.benchmarkQuotesHeading,
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          s.benchmarkQuotesSubheading,
          style: TextStyle(
            fontFamily: OryzaTypography.fontFamily,
            package: 'oryzaelo_ui',
            fontSize: 13.5,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 20),

        LayoutBuilder(
          builder: (context, constraints) {
            final isTwoCols = constraints.maxWidth >= 780;

            final card1 = _buildQuoteCard(
              author: s.benchmarkQuote1Author,
              role: s.benchmarkQuote1Role,
              tag: s.benchmarkQuote1Tag,
              text: s.benchmarkQuote1Text,
              sourceLabel: s.benchmarkSourceLabel,
              source: s.benchmarkQuote1Source,
              url: s.benchmarkQuote1Url,
              avatarAsset: "assets/student/_0040.png",
              accentColor: OryzaColors.burntOrange,
            );
            final card2 = _buildQuoteCard(
              author: s.benchmarkQuote2Author,
              role: s.benchmarkQuote2Role,
              tag: s.benchmarkQuote2Tag,
              text: s.benchmarkQuote2Text,
              sourceLabel: s.benchmarkSourceLabel,
              source: s.benchmarkQuote2Source,
              url: s.benchmarkQuote2Url,
              avatarAsset: "assets/student/_0017.png",
              accentColor: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
            );
            final card3 = _buildQuoteCard(
              author: s.benchmarkQuote3Author,
              role: s.benchmarkQuote3Role,
              tag: s.benchmarkQuote3Tag,
              text: s.benchmarkQuote3Text,
              sourceLabel: s.benchmarkSourceLabel,
              source: s.benchmarkQuote3Source,
              url: s.benchmarkQuote3Url,
              avatarAsset: "assets/student/_0028.png",
              accentColor: OryzaColors.burntOrange,
            );
            final card4 = _buildQuoteCard(
              author: s.benchmarkQuote4Author,
              role: s.benchmarkQuote4Role,
              tag: s.benchmarkQuote4Tag,
              text: s.benchmarkQuote4Text,
              sourceLabel: s.benchmarkSourceLabel,
              source: s.benchmarkQuote4Source,
              url: s.benchmarkQuote4Url,
              avatarAsset: "assets/student/_0005.png",
              accentColor: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
            );

            if (isTwoCols) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: card1),
                      const SizedBox(width: 20),
                      Expanded(child: card2),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: card3),
                      const SizedBox(width: 20),
                      Expanded(child: card4),
                    ],
                  ),
                ],
              );
            }

            return Column(
              children: [
                card1,
                const SizedBox(height: 16),
                card2,
                const SizedBox(height: 16),
                card3,
                const SizedBox(height: 16),
                card4,
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuoteCard({
    required String author,
    required String role,
    required String tag,
    required String text,
    required String sourceLabel,
    required String source,
    required String url,
    required String avatarAsset,
    required Color accentColor,
  }) {
    final borderColor = widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final surfaceColor = widget.isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final textPrimary = widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: OryzaTypography.monoFontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: accentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => Icon(Icons.star, size: 12, color: OryzaColors.mustardYellow),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "« $text »",
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.5,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  avatarAsset,
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => CircleAvatar(
                    radius: 19,
                    backgroundColor: accentColor.withValues(alpha: 0.2),
                    child: Text(
                      author.isNotEmpty ? author[0] : '?',
                      style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      role,
                      style: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 11,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: (widget.isDark ? Colors.black : Colors.white).withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor.withValues(alpha: 0.7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.verified_outlined, size: 13, color: accentColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "$sourceLabel $source",
                        style: TextStyle(
                          fontFamily: OryzaTypography.monoFontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        final uri = Uri.tryParse(url);
                        if (uri != null) {
                          launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Icon(Icons.link_outlined, size: 13, color: accentColor),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: SelectableText(
                        url,
                        onTap: () {
                          final uri = Uri.tryParse(url);
                          if (uri != null) {
                            launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                        style: TextStyle(
                          fontFamily: OryzaTypography.monoFontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- KPI BADGE WIDGET ---

class _KpiBadge extends StatelessWidget {
  final String value;
  final String title;
  final String sub;
  final IconData icon;
  final Color accentColor;
  final bool isDark;

  const _KpiBadge({
    required this.value,
    required this.title,
    required this.sub,
    required this.icon,
    required this.accentColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final surfaceColor = isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final textPrimary = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: textPrimary,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 10.5,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- CUSTOM PAINTER: GDD LINE CHART ---

class _GddLineChartPainter extends CustomPainter {
  final bool isDark;
  final Color textSecondaryColor;

  _GddLineChartPainter({
    required this.isDark,
    required this.textSecondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paddingLeft = 45.0;
    final paddingBottom = 28.0;
    final chartWidth = size.width - paddingLeft - 10;
    final chartHeight = size.height - paddingBottom - 10;

    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)
      ..strokeWidth = 1;

    final axisPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.2)
      ..strokeWidth = 1.5;

    // Draw horizontal grid lines (GDD: 0, 400, 800, 1200, 1600)
    final textStyle = TextStyle(
      fontFamily: OryzaTypography.monoFontFamily,
      package: 'oryzaelo_ui',
      fontSize: 9,
      color: textSecondaryColor,
    );

    for (int i = 0; i <= 4; i++) {
      final y = 10 + chartHeight - (i * chartHeight / 4);
      canvas.drawLine(Offset(paddingLeft, y), Offset(paddingLeft + chartWidth, y), gridPaint);

      final gddVal = (i * 400).toString();
      final textSpan = TextSpan(text: gddVal, style: textStyle);
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(paddingLeft - tp.width - 6, y - tp.height / 2));
    }

    // Draw vertical grid lines (DAE: 0, 20, 40, 60, 80, 100, 120)
    for (int i = 0; i <= 6; i++) {
      final x = paddingLeft + (i * chartWidth / 6);
      canvas.drawLine(Offset(x, 10), Offset(x, 10 + chartHeight), gridPaint);

      final daeVal = "${i * 20}d";
      final textSpan = TextSpan(text: daeVal, style: textStyle);
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, 10 + chartHeight + 6));
    }

    // Axes
    canvas.drawLine(Offset(paddingLeft, 10), Offset(paddingLeft, 10 + chartHeight), axisPaint);
    canvas.drawLine(Offset(paddingLeft, 10 + chartHeight), Offset(paddingLeft + chartWidth, 10 + chartHeight), axisPaint);

    // Sigmoid Curve Function Helper
    double getSigmoidGdd(double dae, double maxGdd, double k, double x0) {
      return maxGdd / (1.0 + math.exp(-k * (dae - x0)));
    }

    // 1. Theoretical Reference Curve (Dashed line)
    final theoreticalPath = Path();
    for (int dae = 0; dae <= 120; dae += 2) {
      final gdd = getSigmoidGdd(dae.toDouble(), 1450, 0.055, 60);
      final x = paddingLeft + (dae / 120.0) * chartWidth;
      final y = 10 + chartHeight - (gdd / 1600.0) * chartHeight;
      if (dae == 0) {
        theoreticalPath.moveTo(x, y);
      } else {
        theoreticalPath.lineTo(x, y);
      }
    }
    final theoreticalPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.35)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(theoreticalPath, theoreticalPaint);

    // 2. Thailand Curve (Sukhothai - Tropical Monsoon - Faster heat accumulation)
    final thaiPath = Path();
    for (int dae = 0; dae <= 120; dae += 2) {
      final gdd = getSigmoidGdd(dae.toDouble(), 1580, 0.060, 52);
      final x = paddingLeft + (dae / 120.0) * chartWidth;
      final y = 10 + chartHeight - (gdd / 1600.0) * chartHeight;
      if (dae == 0) {
        thaiPath.moveTo(x, y);
      } else {
        thaiPath.lineTo(x, y);
      }
    }
    final thaiColor = isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen;
    final thaiPaint = Paint()
      ..color = thaiColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(thaiPath, thaiPaint);

    // 3. Brazil Curve (Piracicaba - Subtropical - Moderate heat accumulation)
    final brazilPath = Path();
    for (int dae = 0; dae <= 120; dae += 2) {
      final gdd = getSigmoidGdd(dae.toDouble(), 1420, 0.052, 64);
      final x = paddingLeft + (dae / 120.0) * chartWidth;
      final y = 10 + chartHeight - (gdd / 1600.0) * chartHeight;
      if (dae == 0) {
        brazilPath.moveTo(x, y);
      } else {
        brazilPath.lineTo(x, y);
      }
    }
    final brazilPaint = Paint()
      ..color = OryzaColors.burntOrange
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(brazilPath, brazilPaint);

    // Draw Key Phenology Milestone Points on Brazil Curve
    final milestones = [
      {'dae': 12.0, 'label': 'BBCH 10'},
      {'dae': 32.0, 'label': 'BBCH 21'},
      {'dae': 65.0, 'label': 'BBCH 51'},
      {'dae': 80.0, 'label': 'BBCH 65'},
      {'dae': 110.0, 'label': 'BBCH 87'},
    ];

    final dotPaint = Paint()..color = OryzaColors.burntOrange;
    final dotInnerPaint = Paint()..color = isDark ? const Color(0xFF14110E) : Colors.white;

    for (final m in milestones) {
      final dae = m['dae'] as double;
      final gdd = getSigmoidGdd(dae, 1420, 0.052, 64);
      final x = paddingLeft + (dae / 120.0) * chartWidth;
      final y = 10 + chartHeight - (gdd / 1600.0) * chartHeight;

      canvas.drawCircle(Offset(x, y), 5, dotPaint);
      canvas.drawCircle(Offset(x, y), 2.5, dotInnerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GddLineChartPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

// --- CUSTOM PAINTER: AGNOSTIC MAP PROJECTION ---

class _AgnosticMapPainter extends CustomPainter {
  final bool isDark;
  final int selectedCountry;

  _AgnosticMapPainter({
    required this.isDark,
    required this.selectedCountry,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF110E0C) : const Color(0xFFECE7D8);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Grid Lines (Equator, Tropics, Prime Meridian)
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06)
      ..strokeWidth = 1;

    final equatorY = size.height * 0.50;
    final tropicCancerY = size.height * 0.35; // 23.5° N
    final tropicCapriY = size.height * 0.65;  // 23.5° S

    canvas.drawLine(Offset(0, equatorY), Offset(size.width, equatorY), gridPaint);
    canvas.drawLine(Offset(0, tropicCancerY), Offset(size.width, tropicCancerY), gridPaint);
    canvas.drawLine(Offset(0, tropicCapriY), Offset(size.width, tropicCapriY), gridPaint);

    // Simplified Continental Geometry Shapes
    final landPaint = Paint()
      ..color = (isDark ? const Color(0xFF221C18) : const Color(0xFFDED8C6))
      ..style = PaintingStyle.fill;

    // South America (Simplified Polygon)
    final saPath = Path()
      ..moveTo(size.width * 0.22, size.height * 0.44)
      ..lineTo(size.width * 0.33, size.height * 0.47)
      ..lineTo(size.width * 0.35, size.height * 0.58)
      ..lineTo(size.width * 0.31, size.height * 0.72)
      ..lineTo(size.width * 0.27, size.height * 0.88)
      ..lineTo(size.width * 0.24, size.height * 0.75)
      ..lineTo(size.width * 0.21, size.height * 0.55)
      ..close();
    canvas.drawPath(saPath, landPaint);

    // North America (Simplified Polygon)
    final naPath = Path()
      ..moveTo(size.width * 0.12, size.height * 0.18)
      ..lineTo(size.width * 0.28, size.height * 0.16)
      ..lineTo(size.width * 0.27, size.height * 0.35)
      ..lineTo(size.width * 0.20, size.height * 0.42)
      ..lineTo(size.width * 0.14, size.height * 0.34)
      ..close();
    canvas.drawPath(naPath, landPaint);

    // Eurasia (Simplified Polygon)
    final eurasiaPath = Path()
      ..moveTo(size.width * 0.42, size.height * 0.16)
      ..lineTo(size.width * 0.86, size.height * 0.14)
      ..lineTo(size.width * 0.88, size.height * 0.38)
      ..lineTo(size.width * 0.80, size.height * 0.52)
      ..lineTo(size.width * 0.72, size.height * 0.55)
      ..lineTo(size.width * 0.65, size.height * 0.48)
      ..lineTo(size.width * 0.54, size.height * 0.38)
      ..lineTo(size.width * 0.44, size.height * 0.28)
      ..close();
    canvas.drawPath(eurasiaPath, landPaint);

    // Africa (Simplified Polygon)
    final africaPath = Path()
      ..moveTo(size.width * 0.45, size.height * 0.36)
      ..lineTo(size.width * 0.58, size.height * 0.38)
      ..lineTo(size.width * 0.61, size.height * 0.52)
      ..lineTo(size.width * 0.56, size.height * 0.74)
      ..lineTo(size.width * 0.48, size.height * 0.58)
      ..lineTo(size.width * 0.44, size.height * 0.42)
      ..close();
    canvas.drawPath(africaPath, landPaint);

    // Southeast Asia & Thailand Archipelago
    final seAsiaPath = Path()
      ..moveTo(size.width * 0.72, size.height * 0.42)
      ..lineTo(size.width * 0.77, size.height * 0.44)
      ..lineTo(size.width * 0.76, size.height * 0.58)
      ..lineTo(size.width * 0.73, size.height * 0.55)
      ..close();
    canvas.drawPath(seAsiaPath, landPaint);

    // Focal Points Coordinates on Map:
    // Piracicaba, Brazil: ~22.7° S, 47.7° W -> (width * 0.29, height * 0.66)
    final piraPoint = Offset(size.width * 0.29, size.height * 0.66);

    // Sukhothai, Thailand: ~17.0° N, 99.8° E -> (width * 0.74, height * 0.44)
    final sukPoint = Offset(size.width * 0.74, size.height * 0.44);

    // Transcontinental Geodetic Bridge Arc
    final bridgePath = Path()
      ..moveTo(piraPoint.dx, piraPoint.dy)
      ..quadraticBezierTo(
        size.width * 0.51,
        size.height * 0.18,
        sukPoint.dx,
        sukPoint.dy,
      );

    final bridgePaint = Paint()
      ..color = (isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen).withValues(alpha: 0.5)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    canvas.drawPath(bridgePath, bridgePaint);

    // Hub Markers
    _drawHubMarker(canvas, piraPoint, "Piracicaba (22.7° S)", OryzaColors.burntOrange, selectedCountry == 0);
    _drawHubMarker(canvas, sukPoint, "Sukhothai (17.0° N)", isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen, selectedCountry == 1);
  }

  void _drawHubMarker(Canvas canvas, Offset point, String label, Color color, bool isSelected) {
    final ringPaint = Paint()
      ..color = color.withValues(alpha: isSelected ? 0.35 : 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(point, isSelected ? 16 : 10, ringPaint);

    final corePaint = Paint()..color = color;
    canvas.drawCircle(point, isSelected ? 6 : 4.5, corePaint);

    final innerPaint = Paint()..color = isDark ? const Color(0xFF14110E) : Colors.white;
    canvas.drawCircle(point, 2.5, innerPaint);

    // Hub Label
    final labelStyle = TextStyle(
      fontFamily: OryzaTypography.monoFontFamily,
      package: 'oryzaelo_ui',
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: color,
    );
    final textSpan = TextSpan(text: label, style: labelStyle);
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(point.dx - tp.width / 2, point.dy + (isSelected ? 18 : 12)));
  }

  @override
  bool shouldRepaint(covariant _AgnosticMapPainter oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.selectedCountry != selectedCountry;
  }
}
