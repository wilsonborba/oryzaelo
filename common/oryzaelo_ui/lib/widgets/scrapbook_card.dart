import 'package:flutter/material.dart';
import '../core/theme.dart';

class ScrapbookCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool isDark;
  final String? tag;
  final Color? accentColor;

  const ScrapbookCard({
    super.key,
    required this.child,
    required this.isDark,
    this.padding,
    this.onTap,
    this.tag,
    this.accentColor,
  });

  @override
  State<ScrapbookCard> createState() => _ScrapbookCardState();
}

class _ScrapbookCardState extends State<ScrapbookCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = widget.isDark ? OryzaColors.darkSurface : OryzaColors.lightSurface;
    final borderColor = widget.accentColor ??
        (_isHovered
            ? (widget.isDark ? OryzaColors.burntOrange : OryzaColors.militaryGreen)
            : (widget.isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder));

    final shadowColor = widget.isDark
        ? Colors.black.withValues(alpha: _isHovered ? 0.75 : 0.5)
        : (widget.accentColor ?? OryzaColors.militaryGreen).withValues(alpha: _isHovered ? 0.2 : 0.1);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(
            _isHovered ? -2.0 : 0.0,
            _isHovered ? -2.0 : 0.0,
            0.0,
          ),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: borderColor,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                offset: Offset(_isHovered ? 5.0 : 3.0, _isHovered ? 5.0 : 3.0),
                blurRadius: 0, // Hard shadow (Swiss Design & Refero Design)
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: widget.padding ?? const EdgeInsets.all(20),
                child: widget.child,
              ),
              if (widget.tag != null)
                Positioned(
                  top: 0,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? const Color(0xFF141914)
                          : const Color(0xFFF0EFE6),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                      border: Border(
                        bottom: BorderSide(color: borderColor, width: 1),
                        left: BorderSide(color: borderColor, width: 1),
                        right: BorderSide(color: borderColor, width: 1),
                      ),
                    ),
                    child: Text(
                      widget.tag!,
                      style: TextStyle(
                        fontFamily: OryzaTypography.monoFontFamily,
                        package: 'oryzaelo_ui',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: widget.isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
                      ),
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
