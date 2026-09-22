import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

class TccResearchScreen extends StatelessWidget {
  final bool isDark;

  const TccResearchScreen({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final textPrimary = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;
    final mathColor = isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1080;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      constraints: const BoxConstraints(maxWidth: 1600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Tag & Header
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: OryzaColors.burntOrange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                s.tccSectionTag,
                style: TextStyle(
                  fontFamily: OryzaTypography.monoFontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: OryzaColors.burntOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            s.tccTitle,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: isDesktop ? 34 : 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            s.tccSubtitle,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 15,
              height: 1.5,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // 1. Language Notice Banner (Clear disclosure that official monograph is in PT-BR)
          ScrapbookCard(
            isDark: isDark,
            tag: s.tccLanguageNoticeTag,
            accentColor: OryzaColors.mustardYellow,
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? OryzaColors.darkCanvas : OryzaColors.botanicalGreenLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? OryzaColors.darkBorder : OryzaColors.botanicalGreenBorder,
                    ),
                  ),
                  child: Icon(
                    Icons.language_outlined,
                    size: 24,
                    color: isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.tccLanguageNoticeTag,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        s.tccLanguageNoticeDesc,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 13,
                          height: 1.45,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 2. Empirical Validation Badges Row
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _buildEmpiricalBadge(
                label: s.tccMetricsLatency,
                icon: Icons.timer_outlined,
                color: OryzaColors.burntOrange,
              ),
              _buildEmpiricalBadge(
                label: s.tccMetricsAccuracy,
                icon: Icons.verified_outlined,
                color: isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
              ),
              _buildEmpiricalBadge(
                label: s.tccMetricsGdd,
                icon: Icons.thermostat_outlined,
                color: OryzaColors.mustardYellow,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 3. 4 Detailed Scientific Cards with LaTeX Formula Rendering
          LayoutBuilder(
            builder: (context, constraints) {
              final isTwoCols = constraints.maxWidth >= 900;

              final card1 = _ScientificCard(
                isDark: isDark,
                tag: s.tccCard1Tag,
                title: s.tccCard1Title,
                desc: s.tccCard1Desc,
                targetLabel: s.tccCard1TargetLabel,
                avatarAsset: 'assets/student/_0028.png',
                accentColor: OryzaColors.burntOrange,
                mathWidgets: [
                  Math.tex(
                    r'P(Y = c \mid \mathbf{x}) = \frac{\exp(\mathbf{w}_c^\top \mathbf{x})}{\sum_{k=1}^K \exp(\mathbf{w}_k^\top \mathbf{x})}',
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: mathColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Math.tex(
                    r'c \in \text{BBCH } \{00, 10, \dots, 99\} \quad (\text{10 Macroestádios})',
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                ],
              );

              final card2 = _ScientificCard(
                isDark: isDark,
                tag: s.tccCard2Tag,
                title: s.tccCard2Title,
                desc: s.tccCard2Desc,
                targetLabel: s.tccCard2TargetLabel,
                avatarAsset: 'assets/student/_0017.png',
                accentColor: isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                mathWidgets: [
                  Math.tex(
                    r'\text{GDD}_t = \max\left(0, \frac{T_{\max, t} + T_{\min, t}}{2} - 10.0^\circ\text{C}\right)',
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: mathColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Math.tex(
                    r'\text{DTR}_t = T_{\max, t} - T_{\min, t}, \quad \text{GDD}_{\text{cum}} = \sum_{\tau=1}^t \text{GDD}_\tau',
                    textStyle: TextStyle(
                      fontSize: 12.5,
                      color: textSecondary,
                    ),
                  ),
                ],
              );

              final card3 = _ScientificCard(
                isDark: isDark,
                tag: s.tccCard3Tag,
                title: s.tccCard3Title,
                desc: s.tccCard3Desc,
                targetLabel: s.tccCard3TargetLabel,
                avatarAsset: 'assets/student/_0040.png',
                accentColor: OryzaColors.burntOrange,
                mathWidgets: [
                  Math.tex(
                    r'\text{Macro-F1} = \frac{1}{K}\sum_{k=1}^K \frac{2 \cdot P_k \cdot R_k}{P_k + R_k} \ge 0.75',
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: mathColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Math.tex(
                    r'w = \frac{\hat{p} + \frac{z^2}{2n} \pm z\sqrt{\frac{\hat{p}(1-\hat{p})}{n} + \frac{z^2}{4n^2}}}{1 + \frac{z^2}{n}} \quad (\text{Wilson } 95\%)',
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                ],
              );

              final card4 = _ScientificCard(
                isDark: isDark,
                tag: s.tccCard4Tag,
                title: s.tccCard4Title,
                desc: s.tccCard4Desc,
                targetLabel: s.tccCard4TargetLabel,
                avatarAsset: 'assets/student/_0005.png',
                accentColor: isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                mathWidgets: [
                  Math.tex(
                    r't_{\text{infer}}(\text{Tract ONNX}) = 22.4\text{ }\mu\text{s} \ll 200\text{ ms (SLA)}',
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: mathColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Math.tex(
                    r'\Delta \text{Custo}(\text{Hardware Edge vs. Câmeras}) \approx -84\%',
                    textStyle: TextStyle(
                      fontSize: 12.5,
                      color: textSecondary,
                    ),
                  ),
                ],
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
          const SizedBox(height: 32),

          // 4. Institutional Ficha Catalográfica & Research Team Card
          ScrapbookCard(
            isDark: isDark,
            tag: s.tccCardTeamTag,
            accentColor: OryzaColors.burntOrange,
            padding: const EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_outlined,
                      size: 22,
                      color: OryzaColors.burntOrange,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.tccCardTeamTitle,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  s.tccCardTeamDesc,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 13.5,
                    height: 1.5,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                Column(
                  children: [
                    _buildTeamChip(
                      icon: Icons.person_outline,
                      label: s.tccAuthorLabel,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildTeamChip(
                      icon: Icons.school_outlined,
                      label: s.tccAdvisorLabel,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildTeamChip(
                      icon: Icons.hub_outlined,
                      label: s.tccInstitutionLabel,
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 5. Download Monograph & Scientific Repository Banner (Full Width)
          ScrapbookCard(
            isDark: isDark,
            tag: s.tccPaperBannerTag,
            accentColor: OryzaColors.burntOrange,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/icons3d/file-text-dynamic-color.png',
                      width: 52,
                      height: 52,
                      fit: BoxFit.contain,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: OryzaColors.burntOrange,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, _, _) => Icon(
                        Icons.description_outlined,
                        size: 44,
                        color: isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.tccPaperBannerTitle,
                            style: TextStyle(
                              fontFamily: OryzaTypography.fontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            s.tccPaperBannerDesc,
                            style: TextStyle(
                              fontFamily: OryzaTypography.fontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 13.5,
                              height: 1.45,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                      label: Text(
                        s.tccReadPaper,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.code, size: 18),
                      label: Text(
                        s.tccGithubBtn,
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
                          color: isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _buildEmpiricalBadge({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? OryzaColors.darkSurface : const Color(0xFFEDE9DC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: OryzaTypography.monoFontFamily,
              package: 'oryzaelo_ui',
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamChip({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? OryzaColors.darkCanvas : const Color(0xFFF2EFE6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              size: 15,
              color: isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: OryzaTypography.monoFontFamily,
                package: 'oryzaelo_ui',
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScientificCard extends StatelessWidget {
  final bool isDark;
  final String tag;
  final String title;
  final String desc;
  final String targetLabel;
  final String avatarAsset;
  final Color accentColor;
  final List<Widget> mathWidgets;

  const _ScientificCard({
    required this.isDark,
    required this.tag,
    required this.title,
    required this.desc,
    required this.targetLabel,
    required this.avatarAsset,
    required this.accentColor,
    required this.mathWidgets,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    return ScrapbookCard(
      isDark: isDark,
      tag: tag,
      accentColor: accentColor,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Student/Scientist avatar & Title
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: isDark ? OryzaColors.darkCanvas : const Color(0xFFEBE7DC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    avatarAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.school_outlined,
                      size: 28,
                      color: accentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Narrative
          Text(
            desc,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 13,
              height: 1.5,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // LaTeX Mathematical Formulation Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? OryzaColors.darkCanvas : const Color(0xFFEFECE2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: mathWidgets,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Target Label Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: isDark ? 0.15 : 0.10),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.35),
              ),
            ),
            child: Text(
              targetLabel,
              style: TextStyle(
                fontFamily: OryzaTypography.monoFontFamily,
                package: 'oryzaelo_ui',
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
