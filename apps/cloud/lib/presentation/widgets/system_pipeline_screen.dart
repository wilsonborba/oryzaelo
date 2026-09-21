import 'package:flutter/material.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

class SystemPipelineScreen extends StatefulWidget {
  final bool isDark;

  const SystemPipelineScreen({super.key, required this.isDark});

  @override
  State<SystemPipelineScreen> createState() => _SystemPipelineScreenState();
}

class _SystemPipelineScreenState extends State<SystemPipelineScreen> {
  int _selectedStep = 0;

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final textPrimary = widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;

    final steps = [
      (
        title: s.pipe01Title,
        desc: s.pipe01Desc,
        badge: "PARAMETRIZAÇÃO GENÉTICA",
        equation: "T_base = 10.0 °C  |  T_opt = 30.0 °C  |  T_ceil = 40.0 °C",
        sensorIcon: Icons.tune,
      ),
      (
        title: s.pipe02Title,
        desc: s.pipe02Desc,
        badge: "MODBUS RTU & NASA POWER",
        equation: "RS-485 7-in-1 Soil + Hydrostatic Pressure Transducer (Vented PUR)",
        sensorIcon: Icons.sensors,
      ),
      (
        title: s.pipe03Title,
        desc: s.pipe03Desc,
        badge: "INTEGRAÇÃO TÉRMICA DIÁRIA",
        equation: "GDD = max( 0, (T_max + T_min)/2 - T_base )",
        sensorIcon: Icons.calculate_outlined,
      ),
      (
        title: s.pipe04Title,
        desc: s.pipe04Desc,
        badge: "TRACT ONNX RUNTIME",
        equation: "Tensor Input: Float32[1, 5] -> Output: Softmax(BBCH_00..99) in 22.4 µs",
        sensorIcon: Icons.memory,
      ),
      (
        title: s.pipe05Title,
        desc: s.pipe05Desc,
        badge: "MANEJO DE CAMPO OFFLINE",
        equation: "Lâmina: 5–10 cm  |  Adubação N: BBCH 25 & 32  |  Drenagem: BBCH 87",
        sensorIcon: Icons.eco_outlined,
      ),
    ];

    final current = steps[_selectedStep];

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
                "ARQUITETURA DE SISTEMAS",
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
            s.sysTitle,
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
            s.sysSubtitle,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 15,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Dual Column Architecture
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 780;
              return Flex(
                direction: isNarrow ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Column 1: Edge Station (Rust Engine)
                  Expanded(
                    flex: isNarrow ? 0 : 1,
                    child: ScrapbookCard(
                      isDark: widget.isDark,
                      tag: "BORDA LOCAL • RUST DDD",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: OryzaColors.burntOrange.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.dns_outlined, color: OryzaColors.burntOrange, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.sysEdgeTitle,
                                      style: TextStyle(
                                        fontFamily: OryzaTypography.fontFamily,
                                        package: 'oryzaelo_ui',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: textPrimary,
                                      ),
                                    ),
                                    Text(
                                      s.sysEdgeSubtitle,
                                      style: TextStyle(
                                        fontFamily: OryzaTypography.monoFontFamily,
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
                          Text(
                            s.sysEdgeDesc,
                            style: TextStyle(
                              fontFamily: OryzaTypography.fontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 13.5,
                              height: 1.5,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.isDark ? const Color(0xFF141914) : const Color(0xFFEDEAE0),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                            ),
                            child: Text(
                              s.sysEdgePill,
                              style: TextStyle(
                                fontFamily: OryzaTypography.monoFontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: isNarrow ? 0 : 20, height: isNarrow ? 20 : 0),

                  // Column 2: Client Interface (Flutter Web)
                  Expanded(
                    flex: isNarrow ? 0 : 1,
                    child: ScrapbookCard(
                      isDark: widget.isDark,
                      tag: "INTERFACE PWA • FLUTTER",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: OryzaColors.militaryGreen.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.devices_outlined, color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.sysClientTitle,
                                      style: TextStyle(
                                        fontFamily: OryzaTypography.fontFamily,
                                        package: 'oryzaelo_ui',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: textPrimary,
                                      ),
                                    ),
                                    Text(
                                      s.sysClientSubtitle,
                                      style: TextStyle(
                                        fontFamily: OryzaTypography.monoFontFamily,
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
                          Text(
                            s.sysClientDesc,
                            style: TextStyle(
                              fontFamily: OryzaTypography.fontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 13.5,
                              height: 1.5,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.isDark ? const Color(0xFF141914) : const Color(0xFFEDEAE0),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                            ),
                            child: Text(
                              s.sysClientPill,
                              style: TextStyle(
                                fontFamily: OryzaTypography.monoFontFamily,
                                package: 'oryzaelo_ui',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 36),

          // 5-Stage Interactive Pipeline Header
          Text(
            "Pipeline Biofísico em 5 Etapas (Da Terra à Decisão)",
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Step Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(steps.length, (idx) {
                final isSelected = idx == _selectedStep;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text("${steps[idx].title.split('.')[0]} ${steps[idx].title.split('.')[1].trim().split(' ')[0]}"),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedStep = idx),
                    selectedColor: OryzaColors.burntOrange,
                    backgroundColor: widget.isDark ? const Color(0xFF1B231B) : const Color(0xFFEDEAE0),
                    labelStyle: TextStyle(
                      fontFamily: OryzaTypography.monoFontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : textPrimary,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? OryzaColors.burntOrange
                          : (widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Active Step Card
          ScrapbookCard(
            isDark: widget.isDark,
            tag: current.badge,
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.isDark ? const Color(0xFF141914) : const Color(0xFFEBE7DC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                  ),
                  child: Icon(current.sensorIcon, size: 28, color: OryzaColors.burntOrange),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        current.title,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        current.desc,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 14,
                          height: 1.5,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: widget.isDark ? const Color(0xFF0F140F) : const Color(0xFFF3F1E8),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                        ),
                        child: Text(
                          current.equation,
                          style: TextStyle(
                            fontFamily: OryzaTypography.monoFontFamily,
                            package: 'oryzaelo_ui',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                          ),
                        ),
                      ),
                    ],
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
