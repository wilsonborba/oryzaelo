import 'package:flutter/material.dart';
import '../core/state.dart';
import '../core/theme.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OryzaScope.of(context);
    final currentLang = controller.locale.languageCode;
    final isDark = controller.isDark;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? OryzaColors.darkSurface : const Color(0xFFECEAE0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPill(context, 'EN', 'en', currentLang == 'en', isDark),
          const SizedBox(width: 2),
          _buildPill(context, 'PT', 'pt', currentLang == 'pt', isDark),
          const SizedBox(width: 2),
          _buildPill(context, 'TH', 'th', currentLang == 'th', isDark),
        ],
      ),
    );
  }

  Widget _buildPill(
    BuildContext context,
    String label,
    String langCode,
    bool isSelected,
    bool isDark,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          final controller = OryzaScope.of(context);
          if (langCode == 'pt') {
            controller.setLocale(const Locale('pt', 'BR'));
          } else if (langCode == 'th') {
            controller.setLocale(const Locale('th'));
          } else {
            controller.setLocale(const Locale('en'));
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? OryzaColors.burntOrange : OryzaColors.botanicalGreen)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: OryzaTypography.fontFamily,
              package: 'oryzaelo_ui',
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.8,
              color: isSelected
                  ? Colors.white
                  : (isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
