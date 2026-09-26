import 'package:flutter/material.dart';
import '../core/state.dart';
import '../core/theme.dart';

class LanguageSelector extends StatelessWidget {
  /// When true, renders as a single small tap target showing only the
  /// current language code, opening a menu to switch — for narrow/mobile
  /// headers where the full 3-pill row (~140px) doesn't fit.
  final bool compact;

  const LanguageSelector({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final controller = OryzaScope.of(context);
    final currentLang = controller.locale.languageCode;
    final isDark = controller.isDark;

    if (compact) {
      return _CompactLanguageButton(currentLang: currentLang, isDark: isDark);
    }

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

class _CompactLanguageButton extends StatelessWidget {
  final String currentLang;
  final bool isDark;

  const _CompactLanguageButton({required this.currentLang, required this.isDark});

  static const _codes = {'en': 'EN', 'pt': 'PT', 'th': 'TH'};

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: '',
      offset: const Offset(0, 36),
      onSelected: (langCode) {
        final controller = OryzaScope.of(context);
        if (langCode == 'pt') {
          controller.setLocale(const Locale('pt', 'BR'));
        } else if (langCode == 'th') {
          controller.setLocale(const Locale('th'));
        } else {
          controller.setLocale(const Locale('en'));
        }
      },
      itemBuilder: (context) => _codes.entries
          .map((e) => PopupMenuItem(value: e.key, child: Text(e.value)))
          .toList(),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? OryzaColors.darkSurface : const Color(0xFFECEAE0),
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
            width: 1,
          ),
        ),
        child: Text(
          _codes[currentLang] ?? currentLang.toUpperCase(),
          style: TextStyle(
            fontFamily: OryzaTypography.fontFamily,
            package: 'oryzaelo_ui',
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: isDark ? OryzaColors.darkTextSecondary : OryzaColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }
}
