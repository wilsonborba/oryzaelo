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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1080;

    final steps = [
      (
        title: s.pipe01Title,
        desc: s.pipe01Desc,
        badge: s.pipe01Badge,
        equation: s.pipe01Eq,
        sensorIcon: Icons.tune,
      ),
      (
        title: s.pipe02Title,
        desc: s.pipe02Desc,
        badge: s.pipe02Badge,
        equation: s.pipe02Eq,
        sensorIcon: Icons.sensors,
      ),
      (
        title: s.pipe03Title,
        desc: s.pipe03Desc,
        badge: s.pipe03Badge,
        equation: s.pipe03Eq,
        sensorIcon: Icons.calculate_outlined,
      ),
      (
        title: s.pipe04Title,
        desc: s.pipe04Desc,
        badge: s.pipe04Badge,
        equation: s.pipe04Eq,
        sensorIcon: Icons.memory,
      ),
      (
        title: s.pipe05Title,
        desc: s.pipe05Desc,
        badge: s.pipe05Badge,
        equation: s.pipe05Eq,
        sensorIcon: Icons.eco_outlined,
      ),
    ];

    final current = steps[_selectedStep.clamp(0, steps.length - 1)];

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
                s.sysSectionTag,
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
              fontSize: isDesktop ? 34 : 26,
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

          // Dual Column Architecture (Full-width side by side on desktop)
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 840;
              return Flex(
                direction: isNarrow ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Column 1: Edge Station (Rust Engine)
                  Expanded(
                    flex: isNarrow ? 0 : 1,
                    child: ScrapbookCard(
                      isDark: widget.isDark,
                      tag: s.sysEdgeTag,
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
                  SizedBox(width: isNarrow ? 0 : 24, height: isNarrow ? 20 : 0),

                  // Column 2: Client Interface (Flutter Web)
                  Expanded(
                    flex: isNarrow ? 0 : 1,
                    child: ScrapbookCard(
                      isDark: widget.isDark,
                      tag: s.sysClientTag,
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
                                child: Icon(
                                  Icons.devices_outlined,
                                  color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                                  size: 20,
                                ),
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
          const SizedBox(height: 40),

          // 5-Stage Interactive Pipeline Header
          Text(
            s.sysPipelineHeading,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: isDesktop ? 22 : 18,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Desktop Widescreen Layout: Multi-Stage Horizontal Flow + Detailed Step Card
          if (isDesktop) ...[
            // Horizontal 5-Step Bar
            Row(
              children: List.generate(steps.length, (idx) {
                final isSelected = idx == _selectedStep;
                final step = steps[idx];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: idx < steps.length - 1 ? 12 : 0),
                    child: InkWell(
                      onTap: () => setState(() => _selectedStep = idx),
                      borderRadius: BorderRadius.circular(8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (widget.isDark ? const Color(0xFF261D15) : const Color(0xFFECE4D6))
                              : (widget.isDark ? const Color(0xFF131813) : const Color(0xFFEDE8DD)),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? OryzaColors.burntOrange
                                : (widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? OryzaColors.burntOrange
                                    : (widget.isDark ? const Color(0xFF1C241C) : const Color(0xFFDFDACB)),
                              ),
                              child: Icon(
                                step.sensorIcon,
                                size: 14,
                                color: isSelected ? Colors.white : textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                step.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: OryzaTypography.fontFamily,
                                  package: 'oryzaelo_ui',
                                  fontSize: 12.5,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? textPrimary : textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),
          ] else ...[
            // Mobile / Tablet Step Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(steps.length, (idx) {
                  final isSelected = idx == _selectedStep;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(steps[idx].title),
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
          ],

          // Active Step Card
          ScrapbookCard(
            isDark: widget.isDark,
            tag: current.badge,
            padding: const EdgeInsets.all(26),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: widget.isDark ? const Color(0xFF141914) : const Color(0xFFEBE7DC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                  ),
                  child: Icon(current.sensorIcon, size: 32, color: OryzaColors.burntOrange),
                ),
                const SizedBox(width: 22),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        current.title,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 19,
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
                          fontSize: 14.5,
                          height: 1.5,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            fontSize: 12.5,
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
