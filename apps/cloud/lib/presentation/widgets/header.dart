import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

class OryzaHeader extends StatelessWidget {
  final void Function(String sectionKey)? onNavigateToSection;
  final String activeSection;

  const OryzaHeader({
    super.key,
    this.onNavigateToSection,
    this.activeSection = 'hero',
  });

  @override
  Widget build(BuildContext context) {
    final controller = OryzaScope.of(context);
    final isDark = controller.isDark;
    final s = OryzaI18n.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1040;
    final showCoords = screenWidth >= 1400;
    final isCompact = screenWidth < 680;

    final bgColor = (isDark ? OryzaColors.darkCanvas : OryzaColors.lightCanvas)
        .withValues(alpha: 0.92);
    final borderColor = isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder;
    final textColor = isDark ? OryzaColors.darkTextPrimary : OryzaColors.lightTextPrimary;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              bottom: BorderSide(color: borderColor, width: 1),
            ),
          ),
          child: Row(
            children: [
              // Logo & Brand (Clicks go back to hero)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => onNavigateToSection?.call('hero'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/img/logo.png",
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        s.navBrand,
                        style: TextStyle(
                          fontFamily: OryzaTypography.fontFamily,
                          package: 'oryzaelo_ui',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: textColor,
                        ),
                      ),
                      if (showCoords) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? OryzaColors.darkSurface : OryzaColors.botanicalGreenLight,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isDark ? OryzaColors.darkBorder : OryzaColors.botanicalGreenBorder,
                            ),
                          ),
                          child: Text(
                            s.navCoords,
                            style: TextStyle(
                              fontFamily: OryzaTypography.monoFontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Nav links (Desktop)
              if (isDesktop) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _NavLink(
                            label: s.navSystem,
                            isActive: activeSection == 'system',
                            onTap: () => onNavigateToSection?.call('system'),
                            isDark: isDark,
                          ),
                          _NavLink(
                            label: s.navHardware,
                            isActive: activeSection == 'hardware',
                            onTap: () => onNavigateToSection?.call('hardware'),
                            isDark: isDark,
                          ),
                          _NavLink(
                            label: s.navTcc,
                            isActive: activeSection == 'tcc',
                            onTap: () => onNavigateToSection?.call('tcc'),
                            isDark: isDark,
                          ),
                          _NavLink(
                            label: s.navBenchmark,
                            isActive: activeSection == 'benchmark',
                            onTap: () => onNavigateToSection?.call('benchmark'),
                            isDark: isDark,
                          ),
                          _NavLink(
                            label: s.navHowToUse,
                            isActive: activeSection == 'howToUse',
                            onTap: () => onNavigateToSection?.call('howToUse'),
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Mobile Menu Button
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Icon(Icons.menu_rounded, color: textColor, size: 22),
                  tooltip: 'Navegação',
                  color: isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: borderColor),
                  ),
                  onSelected: (val) => onNavigateToSection?.call(val),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'hero',
                      child: Text(
                        s.navHome,
                        style: TextStyle(
                          color: activeSection == 'hero' ? OryzaColors.burntOrange : textColor,
                          fontWeight: activeSection == 'hero' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'system',
                      child: Text(
                        s.navSystem,
                        style: TextStyle(
                          color: activeSection == 'system' ? OryzaColors.burntOrange : textColor,
                          fontWeight: activeSection == 'system' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'hardware',
                      child: Text(
                        s.navHardware,
                        style: TextStyle(
                          color: activeSection == 'hardware' ? OryzaColors.burntOrange : textColor,
                          fontWeight: activeSection == 'hardware' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'tcc',
                      child: Text(
                        s.navTcc,
                        style: TextStyle(
                          color: activeSection == 'tcc' ? OryzaColors.burntOrange : textColor,
                          fontWeight: activeSection == 'tcc' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'benchmark',
                      child: Text(
                        s.navBenchmark,
                        style: TextStyle(
                          color: activeSection == 'benchmark' ? OryzaColors.burntOrange : textColor,
                          fontWeight: activeSection == 'benchmark' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'howToUse',
                      child: Text(
                        s.navHowToUse,
                        style: TextStyle(
                          color: activeSection == 'howToUse' ? OryzaColors.burntOrange : textColor,
                          fontWeight: activeSection == 'howToUse' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              if (!isDesktop) const Spacer(),

              // Right controls: Language, Theme, Auth buttons
              const LanguageSelector(),
              const SizedBox(width: 8),
              const ThemeToggle(),
              const SizedBox(width: 8),

              // Login Button (Hidden or compact on very small screens)
              if (!isCompact) ...[
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: textColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    s.navLogin,
                    style: TextStyle(
                      fontFamily: OryzaTypography.fontFamily,
                      package: 'oryzaelo_ui',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],

              // Sign Up Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: OryzaColors.burntOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  s.navSignUp,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final bool isActive;

  const _NavLink({
    required this.label,
    required this.onTap,
    required this.isDark,
    this.isActive = false,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = OryzaColors.burntOrange;
    final inactiveColor = widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary;
    final color = widget.isActive
        ? activeColor
        : (_hovered ? activeColor : inactiveColor);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 13,
              fontWeight: (widget.isActive || _hovered) ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
