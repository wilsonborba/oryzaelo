import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';
import 'simulation_dialog.dart';

class HeroScreen extends StatefulWidget {
  final bool isDark;

  const HeroScreen({super.key, required this.isDark});

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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      constraints: const BoxConstraints(maxWidth: 1120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tag Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF1B231B) : const Color(0xFFEBE8DC),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: OryzaColors.burntOrange,
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
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Main Headline
          Text(
            s.heroHeadline,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 44,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
              height: 1.15,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Subheadline
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
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

          // 1. Scientific Manifesto Banner ("A Ciência Colhe")
          ScrapbookCard(
            isDark: widget.isDark,
            tag: "MANIFESTO CIENTÍFICO • A CIÊNCIA COLHE",
            accentColor: OryzaColors.burntOrange,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: -16,
                    bottom: -20,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: widget.isDark ? 0.08 : 0.12,
                        child: Image.asset(
                          'assets/plants/Jungle_Plant_1.png',
                          width: 140,
                          height: 140,
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
                            size: 26,
                            color: OryzaColors.burntOrange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            s.heroManifestoPrefix,
                            style: TextStyle(
                              fontFamily: OryzaTypography.monoFontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
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
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.heroManifestoLine2,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          height: 1.3,
                          color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                            fontSize: 10,
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
          const SizedBox(height: 18),

          // 2. Dual Historical Story Cards (Sukhothai 1292 ⇋ Caminha 1500)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isStacked = constraints.maxWidth < 750;
                final thaiCard = _HistoricalStoryCard(
                  tag: s.heroThaiCardTag,
                  country: s.heroThaiTitle,
                  coords: "17.0055° N",
                  mainQuote: s.heroThaiScript,
                  secondaryQuote: s.heroThaiTranslit,
                  meaning: s.heroThaiMeaning,
                  contextText: s.heroThaiContext,
                  accentColor: OryzaColors.mustardYellow,
                  plantAsset: 'assets/plants/Jungle_Plant_2.png',
                  isDark: widget.isDark,
                );
                final brazilCard = _HistoricalStoryCard(
                  tag: s.heroBrazilCardTag,
                  country: s.heroBrazilTitle,
                  coords: "22.7136° S",
                  mainQuote: s.heroBrazilQuote,
                  secondaryQuote: s.heroBrazilPopular,
                  contextText: s.heroBrazilContext,
                  accentColor: OryzaColors.militaryGreen,
                  plantAsset: 'assets/plants/Jungle_Plant_3.png',
                  isDark: widget.isDark,
                );

                if (isStacked) {
                  return Column(
                    children: [
                      thaiCard,
                      const SizedBox(height: 14),
                      brazilCard,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: thaiCard),
                    const SizedBox(width: 16),
                    Expanded(child: brazilCard),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 32),

          // CTAs Row
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
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
            ],
          ),
          const SizedBox(height: 24),

          // Install Command Pill
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _copyCommand,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: widget.isDark ? const Color(0xFF101510) : const Color(0xFFEBE8DE),
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
          const SizedBox(height: 48),

          // 4 Key Telemetry Metrics with 3D Icons
          Wrap(
            spacing: 20,
            runSpacing: 18,
            alignment: WrapAlignment.center,
            children: [
              _MetricCard(
                isDark: widget.isDark,
                imagePath: "assets/icons3d/clock-dynamic-color.png",
                value: "22.4 µs",
                label: "Latência Neural ONNX",
                sublabel: "Inferência em CPU ARM sem GPU",
              ),
              _MetricCard(
                isDark: widget.isDark,
                imagePath: "assets/icons3d/target-dynamic-color.png",
                value: "87.2%",
                label: "Acurácia Estádio BBCH",
                sublabel: "Validado em 2.398 parcelas",
              ),
              _MetricCard(
                isDark: widget.isDark,
                imagePath: "assets/icons3d/sun-dynamic-color.png",
                value: "10.0 °C",
                label: "Temperatura Base GDD",
                sublabel: "Calibração agronômica Oryza",
              ),
              _MetricCard(
                isDark: widget.isDark,
                imagePath: "assets/icons3d/wifi-dynamic-color.png",
                value: "100%",
                label: "Operação Air-Gapped",
                sublabel: "Zero dependência de nuvem",
              ),
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

    return SizedBox(
      width: 240,
      child: ScrapbookCard(
        isDark: isDark,
        padding: const EdgeInsets.all(18),
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
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange,
                  ),
                ),
                Image.asset(
                  imagePath,
                  width: 32,
                  height: 32,
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
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 14,
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
      ),
    );
  }
}

class _HistoricalStoryCard extends StatefulWidget {
  final String tag;
  final String country;
  final String coords;
  final String mainQuote;
  final String? secondaryQuote;
  final String? meaning;
  final String contextText;
  final Color accentColor;
  final String plantAsset;
  final bool isDark;

  const _HistoricalStoryCard({
    required this.tag,
    required this.country,
    required this.coords,
    required this.mainQuote,
    this.secondaryQuote,
    this.meaning,
    required this.contextText,
    required this.accentColor,
    required this.plantAsset,
    required this.isDark,
  });

  @override
  State<_HistoricalStoryCard> createState() => _HistoricalStoryCardState();
}

class _HistoricalStoryCardState extends State<_HistoricalStoryCard> {
  bool _showContext = false;

  @override
  Widget build(BuildContext context) {
    final textPrimary = widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return ScrapbookCard(
      isDark: widget.isDark,
      tag: widget.tag,
      accentColor: widget.accentColor,
      padding: const EdgeInsets.all(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -24,
            bottom: -24,
            child: IgnorePointer(
              child: Opacity(
                opacity: widget.isDark ? 0.06 : 0.08,
                child: Image.asset(
                  widget.plantAsset,
                  width: 105,
                  height: 105,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Country & Geocoordinates
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
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
                        widget.country,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: widget.accentColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      widget.coords,
                      style: TextStyle(
                        fontFamily: OryzaTypography.monoFontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: widget.accentColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Main Historical Script / Inscription
              Text(
                widget.mainQuote,
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 15.5,
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
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: widget.accentColor,
                  ),
                ),
              ],

              // Meaning
              if (widget.meaning != null) ...[
                const SizedBox(height: 6),
                Text(
                  "“${widget.meaning!}”",
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // Interactive Context Expander
              InkWell(
                onTap: () => setState(() => _showContext = !_showContext),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showContext ? Icons.unfold_less : Icons.history_edu,
                        size: 14,
                        color: widget.accentColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _showContext ? "Ocultar contexto" : "Ver contexto histórico",
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

              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? const Color(0xFF141914).withValues(alpha: 0.8)
                          : const Color(0xFFEDE9DC).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                      ),
                    ),
                    child: Text(
                      widget.contextText,
                      style: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 11.5,
                        height: 1.45,
                        color: textSecondary,
                      ),
                    ),
                  ),
                ),
                crossFadeState: _showContext ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
