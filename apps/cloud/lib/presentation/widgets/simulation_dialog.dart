import 'package:flutter/material.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

class SimulationDialog extends StatefulWidget {
  final bool isDark;

  const SimulationDialog({super.key, required this.isDark});

  static Future<void> show(BuildContext context, {required bool isDark}) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SimulationDialog(isDark: isDark),
    );
  }

  @override
  State<SimulationDialog> createState() => _SimulationDialogState();
}

class _SimulationDialogState extends State<SimulationDialog> {
  String _cultivar = 'BRS Querência';
  double _daysAfterSeeding = 42;
  double _tempMin = 19.5;
  double _tempMax = 31.0;
  double _waterDepth = 7.5; // cm

  // Mathematical Biophysical Model
  double get _tMean => (_tempMax + _tempMin) / 2.0;
  double get _dailyGdd => (_tMean - 10.0) > 0 ? (_tMean - 10.0) : 0.0;
  double get _accumGdd => _dailyGdd * _daysAfterSeeding;

  // Phenological Phase determination
  ({String stageName, String bbchCode, String action}) get _phenology {
    if (_accumGdd < 180) {
      return (
        stageName: "Emergência & Estabelecimento de Plântulas",
        bbchCode: "BBCH 09 - 12",
        action: "Manter solo saturado sem lâmina profunda para favorecer o enraizamento inicial."
      );
    } else if (_accumGdd < 520) {
      return (
        stageName: "Perfilhamento Ativo & Desenvolvimento Foliar",
        bbchCode: "BBCH 21 - 29",
        action: "Manter lâmina constante de 5 a 8 cm. Momento ideal para adubação nitrogenada de cobertura."
      );
    } else if (_accumGdd < 950) {
      return (
        stageName: "Alongamento do Colmo & Iniciação da Panícula",
        bbchCode: "BBCH 30 - 39",
        action: "Fase crítica de sensibilidade hídrica e térmica. Manter lâmina d'água a 10 cm para proteger a panícula jovem contra baixas temperaturas noturnas."
      );
    } else if (_accumGdd < 1350) {
      return (
        stageName: "Emborrachamento, Floração & Antese",
        bbchCode: "BBCH 51 - 69",
        action: "Evitar estresse térmico extremo. Lâmina protetora indispensável para fertilidade das espiguetas."
      );
    } else {
      return (
        stageName: "Maturação dos Grãos (Grão Leitoso a Pastoso)",
        bbchCode: "BBCH 71 - 89",
        action: "Iniciar drenagem gradual do arrozal 15 dias antes da colheita para facilitar o trânsito das colheitadeiras."
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final surfaceColor = widget.isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final borderColor = widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final textPrimary = widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    final pheno = _phenology;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 680),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: widget.isDark ? 0.8 : 0.25),
              offset: const Offset(6, 6),
              blurRadius: 0,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, dialogConstraints) {
            final isNarrow = dialogConstraints.maxWidth < 520;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(isNarrow ? 18 : 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: OryzaColors.burntOrange,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.analytics_outlined, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  "SIMULADOR BIOFÍSICO DE CAMPO",
                                  style: TextStyle(
                                    fontFamily: OryzaTypography.monoFontFamily,
                                    package: 'oryzaelo_ui',
                                    fontSize: isNarrow ? 10.5 : 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: OryzaColors.burntOrange,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          color: textSecondary,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    Text(
                      "Calcule o Estádio Fenológico BBCH em Tempo Real",
                      style: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: isNarrow ? 17 : 20,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Ajuste os parâmetros microclimáticos para simular o motor Rust Tract ONNX de borda.",
                      style: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 13,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Cultivar selector & DAS (Responsive)
                    if (isNarrow) ...[
                      _buildCultivarSelector(surfaceColor, borderColor, textPrimary, textSecondary),
                      const SizedBox(height: 14),
                      _buildDasSlider(textPrimary, textSecondary),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(child: _buildCultivarSelector(surfaceColor, borderColor, textPrimary, textSecondary)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildDasSlider(textPrimary, textSecondary)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 14),

                    // Temperatures (Responsive)
                    if (isNarrow) ...[
                      _buildTMinSlider(textPrimary, textSecondary),
                      const SizedBox(height: 14),
                      _buildTMaxSlider(textPrimary, textSecondary),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(child: _buildTMinSlider(textPrimary, textSecondary)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTMaxSlider(textPrimary, textSecondary)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 14),

                    // Water Depth
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Lâmina d'Água (Sensor Hidrostático)",
                                style: TextStyle(fontSize: 12, color: textSecondary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${_waterDepth.toStringAsFixed(1)} cm",
                              style: TextStyle(
                                fontFamily: OryzaTypography.monoFontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: OryzaColors.mustardYellow,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _waterDepth,
                          min: 0,
                          max: 20,
                          divisions: 40,
                          activeColor: OryzaColors.mustardYellow,
                          onChanged: (val) => setState(() => _waterDepth = val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Result Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: widget.isDark ? const Color(0xFF141914) : const Color(0xFFF2F0E6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: OryzaColors.burntOrange.withValues(alpha: 0.6)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: OryzaColors.burntOrange,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  pheno.bbchCode,
                                  style: const TextStyle(
                                    fontFamily: OryzaTypography.monoFontFamily,
                                    package: 'oryzaelo_ui',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                "GDD Acumulado: ${_accumGdd.toStringAsFixed(1)} °C·dia",
                                style: TextStyle(
                                  fontFamily: OryzaTypography.monoFontFamily,
                                  package: 'oryzaelo_ui',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            pheno.stageName,
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
                            "Recomendação de Manejo: ${pheno.action}",
                            style: TextStyle(
                              fontFamily: OryzaTypography.fontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 13,
                              height: 1.4,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Cloud AI Enhancement CTA
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? const Color(0xFF1B201A)
                            : const Color(0xFFFAF7F0),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: OryzaColors.burntOrange.withValues(alpha: 0.4),
                        ),
                      ),
                      child: isNarrow
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: OryzaColors.burntOrange.withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.cloud_outlined,
                                        color: OryzaColors.burntOrange,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        s.simCloudCtaTitle,
                                        style: TextStyle(
                                          fontFamily: OryzaTypography.fontFamily,
                                          package: 'oryzaelo_ui',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  s.simCloudCtaBody,
                                  style: TextStyle(
                                    fontFamily: OryzaTypography.fontFamily,
                                    package: 'oryzaelo_ui',
                                    fontSize: 12,
                                    height: 1.4,
                                    color: textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: OryzaColors.burntOrange,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      s.simCloudCtaBtn,
                                      style: TextStyle(
                                        fontFamily: OryzaTypography.fontFamily,
                                        package: 'oryzaelo_ui',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: OryzaColors.burntOrange.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.cloud_outlined,
                                    color: OryzaColors.burntOrange,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s.simCloudCtaTitle,
                                        style: TextStyle(
                                          fontFamily: OryzaTypography.fontFamily,
                                          package: 'oryzaelo_ui',
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                          color: textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        s.simCloudCtaBody,
                                        style: TextStyle(
                                          fontFamily: OryzaTypography.fontFamily,
                                          package: 'oryzaelo_ui',
                                          fontSize: 12,
                                          height: 1.4,
                                          color: textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 14),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: OryzaColors.burntOrange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    s.simCloudCtaBtn,
                                    style: TextStyle(
                                      fontFamily: OryzaTypography.fontFamily,
                                      package: 'oryzaelo_ui',
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCultivarSelector(Color surfaceColor, Color borderColor, Color textPrimary, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Cultivar de Arroz",
          style: TextStyle(
            fontFamily: OryzaTypography.fontFamily,
            package: 'oryzaelo_ui',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.isDark ? const Color(0xFF141914) : const Color(0xFFF9F8F4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _cultivar,
              isExpanded: true,
              dropdownColor: surfaceColor,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
              items: const [
                DropdownMenuItem(value: 'BRS Querência', child: Text('BRS Querência (Brasil - 130d)')),
                DropdownMenuItem(value: 'IR64', child: Text('IR64 (Tailândia/IRRI - 115d)')),
                DropdownMenuItem(value: 'Hom Mali (Jasmine)', child: Text('KDML105 (Tailândia - 120d)')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _cultivar = val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDasSlider(Color textPrimary, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Dias Após Emergência",
                style: TextStyle(
                  fontFamily: OryzaTypography.fontFamily,
                  package: 'oryzaelo_ui',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "${_daysAfterSeeding.toInt()} dias",
              style: TextStyle(
                fontFamily: OryzaTypography.monoFontFamily,
                package: 'oryzaelo_ui',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: OryzaColors.burntOrange,
              ),
            ),
          ],
        ),
        Slider(
          value: _daysAfterSeeding,
          min: 5,
          max: 120,
          divisions: 115,
          activeColor: OryzaColors.burntOrange,
          onChanged: (val) => setState(() => _daysAfterSeeding = val),
        ),
      ],
    );
  }

  Widget _buildTMinSlider(Color textPrimary, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Temp. Mínima (T_min)",
                style: TextStyle(fontSize: 12, color: textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "${_tempMin.toStringAsFixed(1)} °C",
              style: TextStyle(
                fontFamily: OryzaTypography.monoFontFamily,
                package: 'oryzaelo_ui',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
          ],
        ),
        Slider(
          value: _tempMin,
          min: 10,
          max: 28,
          divisions: 36,
          activeColor: OryzaColors.militaryGreen,
          onChanged: (val) => setState(() => _tempMin = val),
        ),
      ],
    );
  }

  Widget _buildTMaxSlider(Color textPrimary, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Temp. Máxima (T_max)",
                style: TextStyle(fontSize: 12, color: textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "${_tempMax.toStringAsFixed(1)} °C",
              style: TextStyle(
                fontFamily: OryzaTypography.monoFontFamily,
                package: 'oryzaelo_ui',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
          ],
        ),
        Slider(
          value: _tempMax,
          min: 24,
          max: 42,
          divisions: 36,
          activeColor: OryzaColors.burntOrange,
          onChanged: (val) => setState(() => _tempMax = val),
        ),
      ],
    );
  }
}
