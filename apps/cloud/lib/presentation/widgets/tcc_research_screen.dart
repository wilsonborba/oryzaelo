import 'package:flutter/material.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

class TccResearchScreen extends StatelessWidget {
  final bool isDark;

  const TccResearchScreen({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final textPrimary = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1080;

    final cards = [
      (
        img: 'assets/student/_0028.png',
        title: s.tccCard1Title,
        tag: s.tccCard1Tag,
        desc: s.tccHypothesisText,
      ),
      (
        img: 'assets/student/_0017.png',
        title: s.tccCard2Title,
        tag: s.tccCard2Tag,
        desc: s.tccCard2Desc,
      ),
      (
        img: 'assets/student/_0040.png',
        title: s.tccCard3Title,
        tag: s.tccCard3Tag,
        desc: s.tccCard3Desc,
      ),
      (
        img: 'assets/student/_0005.png',
        title: s.tccCard4Title,
        tag: s.tccCard4Tag,
        desc: s.tccAuthor,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      constraints: const BoxConstraints(maxWidth: 1600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
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
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // 4 Student 3D Illustration Cards Grid (Widescreen 4-column or 2-column)
          LayoutBuilder(
            builder: (context, constraints) {
              final isFourCols = constraints.maxWidth >= 1200;
              final isTwoCols = constraints.maxWidth >= 720;

              if (isFourCols) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(cards.length, (idx) {
                    final c = cards[idx];
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: idx < cards.length - 1 ? 16 : 0),
                        child: _buildStudentCard(c, textPrimary, textSecondary),
                      ),
                    );
                  }),
                );
              }

              if (isTwoCols) {
                final cardWidth = (constraints.maxWidth - 20) / 2;
                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: cards.map((c) {
                    return SizedBox(
                      width: cardWidth,
                      child: _buildStudentCard(c, textPrimary, textSecondary),
                    );
                  }).toList(),
                );
              }

              return Column(
                children: cards.map((c) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildStudentCard(c, textPrimary, textSecondary),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 32),

          // Monograph & Validation Banner (Full Width)
          ScrapbookCard(
            isDark: isDark,
            tag: s.tccPaperBannerTag,
            accentColor: OryzaColors.burntOrange,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isStacked = constraints.maxWidth < 780;
                return Flex(
                  direction: isStacked ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    SizedBox(width: isStacked ? 0 : 24, height: isStacked ? 16 : 0),
                    Expanded(
                      flex: isStacked ? 0 : 1,
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
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: isStacked ? 0 : 24, height: isStacked ? 18 : 0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(
    ({String desc, String img, String tag, String title}) c,
    Color textPrimary,
    Color textSecondary,
  ) {
    return ScrapbookCard(
      isDark: isDark,
      tag: c.tag,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF141914) : const Color(0xFFEBE7DC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    c.img,
                    fit: BoxFit.contain,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded || frame != null) return child;
                      return Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, _, _) => Icon(
                      Icons.school_outlined,
                      size: 32,
                      color: isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  c.title,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            c.desc,
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
    );
  }
}
