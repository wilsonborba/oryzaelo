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

    final cards = [
      (
        img: 'assets/student/_0028.png',
        title: 'Hipótese Central da Tese',
        tag: 'PERGUNTA DE PESQUISA',
        desc: s.tccHypothesisText,
      ),
      (
        img: 'assets/student/_0017.png',
        title: 'Modelagem Agrometeorológica',
        tag: 'METODOLOGIA BIOFÍSICA',
        desc: 'Integração de variáveis microclimáticas in situ com tempo térmico cumulativo (GDD base 10°C) e modelo agrometeorológico calibrado contra 2.398 observações forenses de arroz.',
      ),
      (
        img: 'assets/student/_0040.png',
        title: 'Validação no Campo com Produtores',
        tag: 'APLICAÇÃO DE BORDA',
        desc: 'Avaliação da interface offline (apps/local) em condições reais de lavoura no sul do Brasil e Tailândia, garantindo usabilidade intuitiva sem sinal de celular.',
      ),
      (
        img: 'assets/student/_0005.png',
        title: 'Autoria & Orientação Acadêmica',
        tag: 'CRÉDITOS ESALQ/USP',
        desc: s.tccAuthor,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      constraints: const BoxConstraints(maxWidth: 1120),
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
                "RIGOR ACADÊMICO & CIENTÍFICO",
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
              fontSize: 32,
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

          // 4 Student 3D Illustration Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 840;
              final cardWidth = isNarrow
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 20) / 2;

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: cards.map((c) {
                  return SizedBox(
                    width: cardWidth,
                    child: ScrapbookCard(
                      isDark: isDark,
                      tag: c.tag,
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
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
                                  size: 36,
                                  color: isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.title,
                                  style: TextStyle(
                                    fontFamily: OryzaTypography.fontFamily,
                                    package: 'oryzaelo_ui',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
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
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 28),

          // Monograph & Validation Banner
          ScrapbookCard(
            isDark: isDark,
            tag: "DOCUMENTO ACADÊMICO",
            accentColor: OryzaColors.burntOrange,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isStacked = constraints.maxWidth < 700;
                return Flex(
                  direction: isStacked ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons3d/file-text-dynamic-color.png',
                      width: 48,
                      height: 48,
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
                        size: 40,
                        color: isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange,
                      ),
                    ),
                    SizedBox(width: isStacked ? 0 : 20, height: isStacked ? 14 : 0),
                    Expanded(
                      flex: isStacked ? 0 : 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Monografia & Artigo Científico Completo do TCC",
                            style: TextStyle(
                              fontFamily: OryzaTypography.fontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Acesse a formulação agrometeorológica detalhada, matriz de confusão dos estádios BBCH e o código fonte auditado do motor de borda.",
                            style: TextStyle(
                              fontFamily: OryzaTypography.fontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 13,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: isStacked ? 0 : 20, height: isStacked ? 16 : 0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
}
