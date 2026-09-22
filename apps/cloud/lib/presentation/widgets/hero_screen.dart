import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';
import 'simulation_dialog.dart';

class HeroScreen extends StatefulWidget {
  final bool isDark;
  final void Function(String sectionKey)? onNavigateToSection;

  const HeroScreen({
    super.key,
    required this.isDark,
    this.onNavigateToSection,
  });

  @override
  State<HeroScreen> createState() => _HeroScreenState();
}

class _HeroScreenState extends State<HeroScreen> {
  bool _copied = false;
  static const String _installCmd = "curl -fsSL https://oryzaelo.asodya.com/install.sh | bash";

  void _copyCommand() {
    Clipboard.setData(const ClipboardData(text: _installCmd));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final textPrimary = widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1080;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      constraints: const BoxConstraints(maxWidth: 1600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tag Pill (With botanical green in light mode)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                    shape: BoxShape.circle,
                    color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  s.heroPill,
                  style: TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Main Headline
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Text(
              s.heroHeadline,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: isDesktop ? 46 : 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.2,
                height: 1.15,
                color: textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Subheadline
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Text(
              s.heroSubhead,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 17,
                fontWeight: FontWeight.w400,
                height: 1.55,
                color: textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // CTAs & Install Command Row
          Wrap(
            spacing: 16,
            runSpacing: 14,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => SimulationDialog.show(context, isDark: widget.isDark),
                icon: const Icon(Icons.play_circle_outline, size: 18),
                label: Text(
                  s.heroCtaSimulate,
                  style: const TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: OryzaColors.burntOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.code, size: 18),
                label: Text(
                  s.heroCtaGithub,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: textPrimary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              // Install Command Pill
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _copyCommand,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: widget.isDark ? OryzaColors.darkSurface : const Color(0xFFEBE8DE),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _copied
                            ? OryzaColors.mustardYellow
                            : (widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "\$",
                          style: TextStyle(
                            fontFamily: OryzaTypography.monoFontFamily,
                            package: 'oryzaelo_ui',
                            color: OryzaColors.burntOrange,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            _installCmd,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: OryzaTypography.monoFontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 12.5,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Icon(
                          _copied ? Icons.check : Icons.copy_outlined,
                          size: 15,
                          color: _copied ? OryzaColors.mustardYellow : textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 38),

          // 1. Scientific Manifesto Banner ("A Ciência Colhe")
          SizedBox(
            width: double.infinity,
            child: ScrapbookCard(
              isDark: widget.isDark,
              tag: s.heroManifestoTag,
              accentColor: OryzaColors.burntOrange,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: -10,
                    bottom: -20,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: widget.isDark ? 0.08 : 0.12,
                        child: Image.asset(
                          'assets/plants/Jungle_Plant_1.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.format_quote,
                            size: 28,
                            color: OryzaColors.burntOrange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            s.heroManifestoPrefix,
                            style: TextStyle(
                              fontFamily: OryzaTypography.monoFontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        s.heroManifestoLine1,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: isDesktop ? 22 : 18,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        s.heroManifestoLine2,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: isDesktop ? 24 : 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          height: 1.3,
                          color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: (widget.isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                          ),
                        ),
                        child: Text(
                          s.heroBridgeTag,
                          style: TextStyle(
                            fontFamily: OryzaTypography.monoFontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Dual Interactive Cultural Agronomic Cards (Brasil & Tailândia) - Fluid, Full-Width Desktop Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isStacked = constraints.maxWidth < 980;

              final brazilCard = _InteractiveCulturalCard(
                tag: s.heroBrazilCardTag,
                title: s.heroBrazilTitle,
                region: s.heroBrazilRegion,
                primaryQuote: s.heroBrazilQuote,
                secondaryQuote: s.heroBrazilPopular,
                overviewText: s.heroBrazilOverview,
                agronomyText: s.heroBrazilAgronomy,
                scienceText: s.heroBrazilScience,
                tabOverviewLabel: s.culturalTabOverview,
                tabAgronomyLabel: s.culturalTabAgronomy,
                tabScienceLabel: s.culturalTabScience,
                toggleExpandLabel: s.culturalToggleExpand,
                toggleCollapseLabel: s.culturalToggleCollapse,
                accentColor: widget.isDark ? OryzaColors.burntOrange : OryzaColors.botanicalGreen,
                plantAsset: 'assets/plants/Jungle_Plant_3.png',
                isDark: widget.isDark,
              );

              final thaiCard = _InteractiveCulturalCard(
                tag: s.heroThaiCardTag,
                title: s.heroThaiTitle,
                region: s.heroThaiRegion,
                primaryQuote: s.heroThaiScript,
                secondaryQuote: s.heroThaiTranslit,
                meaningQuote: s.heroThaiMeaning,
                overviewText: s.heroThaiOverview,
                agronomyText: s.heroThaiAgronomy,
                scienceText: s.heroThaiScience,
                tabOverviewLabel: s.culturalTabOverview,
                tabAgronomyLabel: s.culturalTabAgronomy,
                tabScienceLabel: s.culturalTabScience,
                toggleExpandLabel: s.culturalToggleExpand,
                toggleCollapseLabel: s.culturalToggleCollapse,
                accentColor: OryzaColors.mustardYellow,
                plantAsset: 'assets/plants/Jungle_Plant_2.png',
                isDark: widget.isDark,
              );

              if (isStacked) {
                return Column(
                  children: [
                    brazilCard,
                    const SizedBox(height: 20),
                    thaiCard,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: brazilCard),
                  const SizedBox(width: 24),
                  Expanded(child: thaiCard),
                ],
              );
            },
          ),
          const SizedBox(height: 36),

          // 3. 4 Key Telemetry Metrics Grid with 3D Icons (Full Width Desktop Row)
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 1080;
              final isMedium = constraints.maxWidth >= 640;

              final metric1 = _MetricCard(
                isDark: widget.isDark,
                imagePath: "assets/icons3d/clock-dynamic-color.png",
                value: "22.4 µs",
                label: s.metricLatencyTitle,
                sublabel: s.metricLatencySub,
              );
              final metric2 = _MetricCard(
                isDark: widget.isDark,
                imagePath: "assets/icons3d/target-dynamic-color.png",
                value: "87.2%",
                label: s.metricAccuracyTitle,
                sublabel: s.metricAccuracySub,
              );
              final metric3 = _MetricCard(
                isDark: widget.isDark,
                imagePath: "assets/icons3d/sun-dynamic-color.png",
                value: "10.0 °C",
                label: s.metricGddTitle,
                sublabel: s.metricGddSub,
              );
              final metric4 = _MetricCard(
                isDark: widget.isDark,
                imagePath: "assets/icons3d/wifi-dynamic-color.png",
                value: "100%",
                label: s.metricAirgappedTitle,
                sublabel: s.metricAirgappedSub,
              );

              if (isWide) {
                return Row(
                  children: [
                    Expanded(child: metric1),
                    const SizedBox(width: 16),
                    Expanded(child: metric2),
                    const SizedBox(width: 16),
                    Expanded(child: metric3),
                    const SizedBox(width: 16),
                    Expanded(child: metric4),
                  ],
                );
              }

              if (isMedium) {
                final cardWidth = (constraints.maxWidth - 16) / 2;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(width: cardWidth, child: metric1),
                    SizedBox(width: cardWidth, child: metric2),
                    SizedBox(width: cardWidth, child: metric3),
                    SizedBox(width: cardWidth, child: metric4),
                  ],
                );
              }

              return Column(
                children: [
                  metric1,
                  const SizedBox(height: 14),
                  metric2,
                  const SizedBox(height: 14),
                  metric3,
                  const SizedBox(height: 14),
                  metric4,
                ],
              );
            },
          ),
          const SizedBox(height: 48),

          // 4. Portais de Navegação para Telas Dedicadas
          _buildDedicatedPortals(s, textPrimary, textSecondary),
        ],
      ),
    );
  }

  Widget _buildDedicatedPortals(
    OryzaStrings s,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              s.exploreSectionHeading,
              style: TextStyle(
                fontFamily: OryzaTypography.monoFontFamily,
                package: 'oryzaelo_ui',
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final portalSystem = _PortalCard(
              isDark: widget.isDark,
              tag: s.portalSystemTag,
              icon: Icons.schema_outlined,
              accentColor: OryzaColors.burntOrange,
              title: s.exploreSectionSystem,
              desc: s.exploreSectionSystemDesc,
              btnLabel: s.exploreActionBtn,
              onTap: () => widget.onNavigateToSection?.call('system'),
            );

            final portalHardware = _PortalCard(
              isDark: widget.isDark,
              tag: s.portalHardwareTag,
              icon: Icons.developer_board_outlined,
              accentColor: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
              title: s.exploreSectionHardware,
              desc: s.exploreSectionHardwareDesc,
              btnLabel: s.exploreActionBtn,
              onTap: () => widget.onNavigateToSection?.call('hardware'),
            );

            final portalTcc = _PortalCard(
              isDark: widget.isDark,
              tag: s.portalTccTag,
              icon: Icons.school_outlined,
              accentColor: OryzaColors.burntOrange,
              title: s.exploreSectionTcc,
              desc: s.exploreSectionTccDesc,
              btnLabel: s.exploreActionBtn,
              onTap: () => widget.onNavigateToSection?.call('tcc'),
            );

            final portalBenchmark = _PortalCard(
              isDark: widget.isDark,
              tag: s.portalBenchmarkTag,
              icon: Icons.bar_chart_outlined,
              accentColor: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
              title: s.exploreSectionBenchmark,
              desc: s.exploreSectionBenchmarkDesc,
              btnLabel: s.exploreActionBtn,
              onTap: () => widget.onNavigateToSection?.call('benchmark'),
            );

            if (constraints.maxWidth >= 1180) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: portalSystem),
                  const SizedBox(width: 16),
                  Expanded(child: portalHardware),
                  const SizedBox(width: 16),
                  Expanded(child: portalTcc),
                  const SizedBox(width: 16),
                  Expanded(child: portalBenchmark),
                ],
              );
            }

            if (constraints.maxWidth >= 640) {
              final cardWidth = (constraints.maxWidth - 16) / 2;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(width: cardWidth, child: portalSystem),
                  SizedBox(width: cardWidth, child: portalHardware),
                  SizedBox(width: cardWidth, child: portalTcc),
                  SizedBox(width: cardWidth, child: portalBenchmark),
                ],
              );
            }

            return Column(
              children: [
                portalSystem,
                const SizedBox(height: 16),
                portalHardware,
                const SizedBox(height: 16),
                portalTcc,
                const SizedBox(height: 16),
                portalBenchmark,
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PortalCard extends StatelessWidget {
  final bool isDark;
  final String tag;
  final IconData icon;
  final Color accentColor;
  final String title;
  final String desc;
  final String btnLabel;
  final VoidCallback onTap;

  const _PortalCard({
    required this.isDark,
    required this.tag,
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.desc,
    required this.btnLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return ScrapbookCard(
      isDark: isDark,
      tag: tag,
      accentColor: accentColor,
      onTap: onTap,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isDark ? OryzaColors.darkCanvas : const Color(0xFFEFECE2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                  ),
                ),
                child: Icon(icon, size: 22, color: accentColor),
              ),
              Icon(Icons.arrow_forward, size: 18, color: accentColor),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 13,
              height: 1.45,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Flexible(
                child: Text(
                  btnLabel,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: accentColor,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.open_in_new, size: 13, color: accentColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final bool isDark;
  final String imagePath;
  final String value;
  final String label;
  final String sublabel;

  const _MetricCard({
    required this.isDark,
    required this.imagePath,
    required this.value,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return ScrapbookCard(
      isDark: isDark,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange,
                ),
              ),
              Image.asset(
                imagePath,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded || frame != null) return child;
                  return Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange,
                      ),
                    ),
                  );
                },
                errorBuilder: (_, _, _) => Icon(
                  Icons.speed,
                  size: 28,
                  color: isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sublabel,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 12,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractiveCulturalCard extends StatefulWidget {
  final String tag;
  final String title;
  final String region;
  final String primaryQuote;
  final String? secondaryQuote;
  final String? meaningQuote;
  final String overviewText;
  final String agronomyText;
  final String scienceText;
  final String tabOverviewLabel;
  final String tabAgronomyLabel;
  final String tabScienceLabel;
  final String toggleExpandLabel;
  final String toggleCollapseLabel;
  final Color accentColor;
  final String plantAsset;
  final bool isDark;

  const _InteractiveCulturalCard({
    required this.tag,
    required this.title,
    required this.region,
    required this.primaryQuote,
    this.secondaryQuote,
    this.meaningQuote,
    required this.overviewText,
    required this.agronomyText,
    required this.scienceText,
    required this.tabOverviewLabel,
    required this.tabAgronomyLabel,
    required this.tabScienceLabel,
    required this.toggleExpandLabel,
    required this.toggleCollapseLabel,
    required this.accentColor,
    required this.plantAsset,
    required this.isDark,
  });

  @override
  State<_InteractiveCulturalCard> createState() => _InteractiveCulturalCardState();
}

class _InteractiveCulturalCardState extends State<_InteractiveCulturalCard> {
  int _activeTab = 0; // 0 = Overview, 1 = Agronomy & Terroir, 2 = Edge Science
  bool _expanded = true; // Fluid interactive discovery

  @override
  Widget build(BuildContext context) {
    final textPrimary = widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    final tabs = [
      (label: widget.tabOverviewLabel, icon: Icons.auto_stories_outlined),
      (label: widget.tabAgronomyLabel, icon: Icons.eco_outlined),
      (label: widget.tabScienceLabel, icon: Icons.psychology_alt_outlined),
    ];

    String activeContent;
    switch (_activeTab) {
      case 1:
        activeContent = widget.agronomyText;
        break;
      case 2:
        activeContent = widget.scienceText;
        break;
      case 0:
      default:
        activeContent = widget.overviewText;
        break;
    }

    return ScrapbookCard(
      isDark: widget.isDark,
      tag: widget.tag,
      accentColor: widget.accentColor,
      padding: const EdgeInsets.all(24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: IgnorePointer(
              child: Opacity(
                opacity: widget.isDark ? 0.06 : 0.08,
                child: Image.asset(
                  widget.plantAsset,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title and Regional Terroir Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.accentColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontFamily: OryzaTypography.fontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.region,
                          style: TextStyle(
                            fontFamily: OryzaTypography.fontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Main Historical Script / Inscription
              Text(
                widget.primaryQuote,
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 16.5,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),

              // Transliteration or Popular Adage
              if (widget.secondaryQuote != null) ...[
                const SizedBox(height: 6),
                Text(
                  widget.secondaryQuote!,
                  style: TextStyle(
                    fontFamily: OryzaTypography.monoFontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: widget.accentColor,
                  ),
                ),
              ],

              // Meaning
              if (widget.meaningQuote != null) ...[
                const SizedBox(height: 6),
                Text(
                  "“${widget.meaningQuote!}”",
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 13.5,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                ),
              ],
              const SizedBox(height: 18),

              // Fluid Interactive Discovery Tabs (Visão Geral, Agronomia & Terroir, Ciência de Borda)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(tabs.length, (idx) {
                  final isSelected = _activeTab == idx && _expanded;
                  final tab = tabs[idx];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (_activeTab == idx && _expanded) {
                          _expanded = false;
                        } else {
                          _activeTab = idx;
                          _expanded = true;
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? widget.accentColor.withValues(alpha: widget.isDark ? 0.25 : 0.18)
                            : (widget.isDark ? OryzaColors.darkCanvas : const Color(0xFFEBE7DC)),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected
                              ? widget.accentColor
                              : (widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            tab.icon,
                            size: 14,
                            color: isSelected ? widget.accentColor : textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tab.label,
                            style: TextStyle(
                              fontFamily: OryzaTypography.fontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 11.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? textPrimary : textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Interactive Content Panel (Appears through fluid interaction)
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 220),
                crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: InkWell(
                  onTap: () => setState(() => _expanded = true),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.unfold_more, size: 14, color: widget.accentColor),
                        const SizedBox(width: 6),
                        Text(
                          widget.toggleExpandLabel,
                          style: TextStyle(
                            fontFamily: OryzaTypography.monoFontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: widget.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                secondChild: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? OryzaColors.darkSurface.withValues(alpha: 0.90)
                        : const Color(0xFFEDE9DC).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.accentColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tabs[_activeTab].label.toUpperCase(),
                            style: TextStyle(
                              fontFamily: OryzaTypography.monoFontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              color: widget.accentColor,
                            ),
                          ),
                          InkWell(
                            onTap: () => setState(() => _expanded = false),
                            child: Icon(Icons.close, size: 14, color: textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Text(
                          activeContent,
                          key: ValueKey<String>(activeContent),
                          style: TextStyle(
                            fontFamily: OryzaTypography.fontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 12.5,
                            height: 1.5,
                            color: textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
