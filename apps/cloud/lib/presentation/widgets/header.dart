import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:oryzaelo_ui/oryzaelo_ui.dart';

class OryzaHeader extends StatelessWidget {
  final void Function(String sectionKey)? onNavigateToSection;

  const OryzaHeader({
    super.key,
    this.onNavigateToSection,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OryzaScope.of(context);
    final isDark = controller.isDark;
    final s = OryzaI18n.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1080;
    final isWideTablet = screenWidth >= 860;
    final isCompact = screenWidth < 680;

    final bgColor = (isDark ? const Color(0xFF141914) : const Color(0xFFF7F6F0))
        .withValues(alpha: 0.90);
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
              // Logo & Brand
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
                      if (isWideTablet) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1C241C) : const Color(0xFFEDEAE0),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: borderColor),
                          ),
                          child: Text(
                            s.navCoords,
                            style: TextStyle(
                              fontFamily: OryzaTypography.monoFontFamily,
                              package: 'oryzaelo_ui',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
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
                const SizedBox(width: 24),
                _NavLink(
                  label: s.navSystem,
                  onTap: () => onNavigateToSection?.call('system'),
                  isDark: isDark,
                ),
                _NavLink(
                  label: s.navHardware,
                  onTap: () => onNavigateToSection?.call('hardware'),
                  isDark: isDark,
                ),
                _NavLink(
                  label: s.navTcc,
                  onTap: () => onNavigateToSection?.call('tcc'),
                  isDark: isDark,
                ),
              ],

              const Spacer(),

              // Right controls: Language, Theme, Background Style, Auth buttons
              const LanguageSelector(),
              const SizedBox(width: 8),
              const ThemeToggle(),
              const SizedBox(width: 8),

              // Login Button (Hidden or compact on very small screens)
              if (!isCompact) ...[
                TextButton(
                  onPressed: () => AuthModal.show(context, isSignUp: false, isDark: isDark),
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
                onPressed: () => AuthModal.show(context, isSignUp: true, isDark: isDark),
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

  const _NavLink({
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = _hovered
        ? OryzaColors.burntOrange
        : (widget.isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 13,
              fontWeight: _hovered ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
