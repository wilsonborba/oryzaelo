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
  final ScrollController _stepScrollController = ScrollController();

  @override
  void dispose() {
    _stepScrollController.dispose();
    super.dispose();
  }

  void _selectStep(int idx) {
    if (idx < 0 || idx > 4) return;
    setState(() => _selectedStep = idx);
    if (_stepScrollController.hasClients) {
      final targetOffset = (idx * 252.0).clamp(0.0, _stepScrollController.position.maxScrollExtent);
      _stepScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildStepCard(
    int idx,
    ({String badge, String desc, String equation, IconData sensorIcon, String title}) step,
    bool isSelected, {
    required OryzaStrings s,
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
    double? width,
  }) {
    final borderColor = isSelected
        ? OryzaColors.burntOrange
        : (isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder);
    final cardBg = isSelected
        ? (isDark ? const Color(0xFF261D15) : const Color(0xFFECE4D6))
        : (isDark ? const Color(0xFF131813) : const Color(0xFFEDE8DD));

    return InkWell(
      onTap: () => _selectStep(idx),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: OryzaColors.burntOrange.withValues(alpha: isDark ? 0.25 : 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Step Index & Sensor Icon & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? OryzaColors.burntOrange
                            : (isDark ? const Color(0xFF1E281E) : const Color(0xFFDFDACB)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "0${idx + 1}",
                        style: TextStyle(
                          fontFamily: OryzaTypography.monoFontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? OryzaColors.burntOrange.withValues(alpha: 0.2)
                            : (isDark ? const Color(0xFF1C241C) : const Color(0xFFDFDACB)),
                      ),
                      child: Icon(
                        step.sensorIcon,
                        size: 14,
                        color: isSelected ? OryzaColors.burntOrange : textSecondary,
                      ),
                    ),
                  ],
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: OryzaColors.burntOrange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: OryzaColors.burntOrange.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      s.pipeActiveTag,
                      style: TextStyle(
                        fontFamily: OryzaTypography.monoFontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: OryzaColors.burntOrange,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            // Step Title
            Text(
              step.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: OryzaTypography.fontFamily,
                package: 'oryzaelo_ui',
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? textPrimary : textSecondary,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 6),
            // Category Badge
            Text(
              step.badge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: OryzaTypography.monoFontFamily,
                package: 'oryzaelo_ui',
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? (isDark ? OryzaColors.mustardYellow : OryzaColors.burntOrange)
                    : textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = OryzaI18n.of(context);
    final textPrimary = widget.isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;
    final textSecondary = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1180;

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

    final edgeCard = ScrapbookCard(
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
    );

    final clientCard = ScrapbookCard(
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
                color: OryzaColors.burntOrange,
              ),
            ),
          ),
        ],
      ),
    );

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

          // Dual Column Architecture (Responsive side-by-side or stacked)
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 840;
              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    edgeCard,
                    const SizedBox(height: 20),
                    clientCard,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: edgeCard),
                  const SizedBox(width: 24),
                  Expanded(child: clientCard),
                ],
              );
            },
          ),
          const SizedBox(height: 40),

          // 5-Stage Interactive Pipeline Header with Mobile Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  s.sysPipelineHeading,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: isDesktop ? 22 : 18,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
              // Mobile / Tablet Navigation Controls
              if (!isDesktop) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.isDark ? const Color(0xFF1A221A) : const Color(0xFFEDE9DC),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                    ),
                  ),
                  child: Text(
                    "${s.pipeStepPrefix} ${_selectedStep + 1} ${s.pipeOfPrefix} ${steps.length}",
                    style: TextStyle(
                      fontFamily: OryzaTypography.monoFontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: OryzaColors.burntOrange,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded, size: 22),
                  onPressed: _selectedStep > 0 ? () => _selectStep(_selectedStep - 1) : null,
                  tooltip: s.navPrevStep,
                  style: IconButton.styleFrom(
                    backgroundColor: widget.isDark ? const Color(0xFF141914) : const Color(0xFFEDEAE0),
                    foregroundColor: textPrimary,
                    padding: const EdgeInsets.all(6),
                    minimumSize: const Size(34, 34),
                    side: BorderSide(
                      color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded, size: 22),
                  onPressed: _selectedStep < steps.length - 1 ? () => _selectStep(_selectedStep + 1) : null,
                  tooltip: s.navNextStep,
                  style: IconButton.styleFrom(
                    backgroundColor: widget.isDark ? const Color(0xFF141914) : const Color(0xFFEDEAE0),
                    foregroundColor: textPrimary,
                    padding: const EdgeInsets.all(6),
                    minimumSize: const Size(34, 34),
                    side: BorderSide(
                      color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // 5-Step Cards Presentation
          if (isDesktop) ...[
            // Horizontal 5-Step Bar (Desktop Widescreen)
            Row(
              children: List.generate(steps.length, (idx) {
                final isSelected = idx == _selectedStep;
                final step = steps[idx];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: idx < steps.length - 1 ? 12 : 0),
                    child: _buildStepCard(
                      idx,
                      step,
                      isSelected,
                      s: s,
                      isDark: widget.isDark,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),
          ] else ...[
            // Horizontal Scrollable Cards Strip with Visible Scrollbar (Mobile & Tablet)
            Scrollbar(
              controller: _stepScrollController,
              thumbVisibility: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                controller: _stepScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: List.generate(steps.length, (idx) {
                    final isSelected = idx == _selectedStep;
                    final step = steps[idx];
                    return Padding(
                      padding: EdgeInsets.only(right: idx < steps.length - 1 ? 12 : 0),
                      child: _buildStepCard(
                        idx,
                        step,
                        isSelected,
                        s: s,
                        isDark: widget.isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        width: 240,
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Mobile Swipe Indicator
            Row(
              children: [
                Icon(
                  Icons.swipe_outlined,
                  size: 14,
                  color: OryzaColors.burntOrange,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    s.pipeSwipeHint,
                    style: TextStyle(
                      fontFamily: OryzaTypography.monoFontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 10.5,
                      color: textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Active Step Card
          ScrapbookCard(
            isDark: widget.isDark,
            tag: current.badge,
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, cardConstraints) {
                final isCompactCard = cardConstraints.maxWidth < 620;
                final iconWidget = Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: widget.isDark ? const Color(0xFF141914) : const Color(0xFFEBE7DC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                  ),
                  child: Icon(current.sensorIcon, size: 30, color: OryzaColors.burntOrange),
                );

                final contentWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      current.title,
                      style: TextStyle(
                        fontFamily: OryzaTypography.fontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: isCompactCard ? 17 : 19,
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
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: widget.isDark ? const Color(0xFF0F140F) : const Color(0xFFF3F1E8),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                    ),
                  ],
                );

                if (isCompactCard) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      iconWidget,
                      const SizedBox(height: 16),
                      contentWidget,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    iconWidget,
                    const SizedBox(width: 20),
                    Expanded(child: contentWidget),
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
