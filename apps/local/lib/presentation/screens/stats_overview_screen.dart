import 'package:flutter/material.dart';
import 'package:local/presentation/handlers/dashboard_handler.dart';
import 'package:local/presentation/widgets/agrometeorological_charts.dart';
import 'package:local/presentation/widgets/edge_telemetry_hud.dart';
import 'package:local/presentation/widgets/multidimensional_visualizations.dart';
import 'package:local/presentation/widgets/parcel_selector_bar.dart';
import 'package:local/presentation/widgets/phenology_monitor_card.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

enum StatsSection {
  all,
  phenology,
  climate,
  radar,
  hardware,
}

class StatsOverviewScreen extends StatefulWidget {
  final DashboardHandler handler;

  const StatsOverviewScreen({
    super.key,
    required this.handler,
  });

  @override
  State<StatsOverviewScreen> createState() => _StatsOverviewScreenState();
}

class _StatsOverviewScreenState extends State<StatsOverviewScreen> {
  StatsSection _activeSection = StatsSection.all;

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Parcel Selector Toolbar
              ParcelSelectorBar(handler: widget.handler),
              const SizedBox(height: 12),

              // Visual Stats Navigator Carousel / Card Selector
              _buildStatsCardNavigator(context, isDark, s),
              const SizedBox(height: 20),

              // ── 1. Phenology Monitor Section ──
              if (_activeSection == StatsSection.all || _activeSection == StatsSection.phenology) ...[
                _buildSectionContainer(
                  title: s.statsSectionPhenoTitle.toUpperCase(),
                  subtitle: s.statsSectionPhenoSubtitle,
                  tag: s.statsSectionPhenoTag.toUpperCase(),
                  isDark: isDark,
                  child: PhenologyMonitorCard(handler: widget.handler),
                ),
                const SizedBox(height: 20),
              ],

              // ── 2. Climate Dynamics & GDD Section ──
              if (_activeSection == StatsSection.all || _activeSection == StatsSection.climate) ...[
                _buildSectionContainer(
                  title: s.statsSectionClimateTitle.toUpperCase(),
                  subtitle: s.statsSectionClimateSubtitle,
                  tag: s.statsSectionClimateTag.toUpperCase(),
                  isDark: isDark,
                  child: AgrometeorologicalCharts(records: widget.handler.weatherRecords),
                ),
                const SizedBox(height: 20),
              ],

              // ── 3. Radar & Multidimensional Biometrics Section ──
              if (_activeSection == StatsSection.all || _activeSection == StatsSection.radar) ...[
                _buildSectionContainer(
                  title: s.statsSectionRadarTitle.toUpperCase(),
                  subtitle: s.statsSectionRadarSubtitle,
                  tag: s.statsSectionRadarTag.toUpperCase(),
                  isDark: isDark,
                  child: MultidimensionalVisualizations(
                    prediction: widget.handler.latestPrediction,
                    analytics: widget.handler.analyticsReport,
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // ── 4. Edge Hardware & Benchmarks Telemetry HUD Section ──
              if (_activeSection == StatsSection.all || _activeSection == StatsSection.hardware) ...[
                _buildSectionContainer(
                  title: s.statsSectionHardwareTitle.toUpperCase(),
                  subtitle: s.statsSectionHardwareSubtitle,
                  tag: s.statsSectionHardwareTag.toUpperCase(),
                  isDark: isDark,
                  child: EdgeTelemetryHud(handler: widget.handler),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCardNavigator(BuildContext context, bool isDark, OryzaStrings s) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = [
          _StatsNavItem(
            section: StatsSection.all,
            label: s.dashFilterAll,
            badge: s.statsNavAllBadge,
            assetPath: "assets/icons3d/target-dynamic-color.png",
            isSelected: _activeSection == StatsSection.all,
            onTap: () => setState(() => _activeSection = StatsSection.all),
          ),
          _StatsNavItem(
            section: StatsSection.phenology,
            label: s.dashFilterPheno,
            badge: s.statsNavPhenoBadge,
            assetPath: "assets/icons3d/target-dynamic-color.png",
            isSelected: _activeSection == StatsSection.phenology,
            onTap: () => setState(() => _activeSection = StatsSection.phenology),
          ),
          _StatsNavItem(
            section: StatsSection.climate,
            label: s.dashFilterClimate,
            badge: s.chartUnitGdd,
            assetPath: "assets/icons3d/sun-dynamic-color.png",
            isSelected: _activeSection == StatsSection.climate,
            onTap: () => setState(() => _activeSection = StatsSection.climate),
          ),
          _StatsNavItem(
            section: StatsSection.radar,
            label: s.dashFilterBiomet,
            badge: s.statsNavRadarBadge,
            assetPath: "assets/icons3d/calculator-dynamic-color.png",
            isSelected: _activeSection == StatsSection.radar,
            onTap: () => setState(() => _activeSection = StatsSection.radar),
          ),
          _StatsNavItem(
            section: StatsSection.hardware,
            label: s.dashNavHud,
            badge: "< 22 µs ONNX",
            assetPath: "assets/icons3d/wifi-dynamic-color.png",
            isSelected: _activeSection == StatsSection.hardware,
            onTap: () => setState(() => _activeSection = StatsSection.hardware),
          ),
        ];

        return OryzaHorizontalScroller(
          isDark: isDark,
          step: 210,
          child: Row(
            children: cards
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: _buildNavCard(item, isDark),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildNavCard(_StatsNavItem item, bool isDark) {
    final borderColor = item.isSelected
        ? OryzaColors.burntOrange
        : (isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder);
    final surfaceColor = item.isSelected
        ? (isDark ? const Color(0xFF241C16) : const Color(0xFFFBF4ED))
        : (isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface);
    final textColor = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 225,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: item.isSelected ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
              offset: const Offset(2, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  item.assetPath,
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: item.isSelected
                          ? OryzaColors.burntOrange
                          : (isDark ? OryzaColors.darkCanvas : OryzaColors.botanicalGreenLight),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.badge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        fontFamily: OryzaTypography.monoFontFamily,
                        package: 'oryzaelo_ui',
                        color: item.isSelected
                            ? Colors.white
                            : (isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.label,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 12.5,
                fontWeight: item.isSelected ? FontWeight.w800 : FontWeight.w600,
                color: item.isSelected ? OryzaColors.burntOrange : textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Plain section heading (icon + title + subtitle + tag), no card box of its
  /// own — [child] already renders its own bordered card(s) (chart tiles,
  /// the phenology card, the telemetry HUD), so wrapping it in a second
  /// bordered/shadowed container just produced cards nested inside cards.
  Widget _buildSectionContainer({
    required String title,
    required String subtitle,
    required String tag,
    required bool isDark,
    required Widget child,
  }) {
    final textColor = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: OryzaTypography.monoFontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                tag,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

class _StatsNavItem {
  final StatsSection section;
  final String label;
  final String badge;
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  _StatsNavItem({
    required this.section,
    required this.label,
    required this.badge,
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });
}
