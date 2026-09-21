import 'package:flutter/material.dart';
import '../core/state.dart';
import '../core/theme.dart';

class BackgroundStyleSelector extends StatelessWidget {
  const BackgroundStyleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OryzaScope.of(context);
    final isDark = controller.isDark;
    final current = controller.backgroundStyle;

    return PopupMenuButton<OryzaBackgroundStyle>(
      tooltip: 'Estilo do Background',
      initialValue: current,
      onSelected: (style) => controller.setBackgroundStyle(style),
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
        ),
      ),
      color: isDark ? const Color(0xFF161E16) : const Color(0xFFF9F7F0),
      itemBuilder: (ctx) => [
        _buildItem(
          value: OryzaBackgroundStyle.atmospheric,
          title: 'Atmosférico Suave',
          subtitle: 'Glow difuso + pólen biofísico (Padrão)',
          isSelected: current == OryzaBackgroundStyle.atmospheric,
          isDark: isDark,
          icon: Icons.auto_awesome,
        ),
        _buildItem(
          value: OryzaBackgroundStyle.cleanStudio,
          title: 'Estúdio Minimalista',
          subtitle: 'Canvas 100% liso sem partículas',
          isSelected: current == OryzaBackgroundStyle.cleanStudio,
          isDark: isDark,
          icon: Icons.crop_portrait,
        ),
        _buildItem(
          value: OryzaBackgroundStyle.swissDots,
          title: 'Micro-Pontos Suíços',
          subtitle: 'Matriz suave de 48px',
          isSelected: current == OryzaBackgroundStyle.swissDots,
          isDark: isDark,
          icon: Icons.grain,
        ),
        _buildItem(
          value: OryzaBackgroundStyle.topographic,
          title: 'Curvas de Nível',
          subtitle: 'Topografia de várzea de arroz',
          isSelected: current == OryzaBackgroundStyle.topographic,
          isDark: isDark,
          icon: Icons.waves,
        ),
      ],
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF192019) : const Color(0xFFECEAE0),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.layers_outlined,
            size: 16,
            color: isDark ? OryzaColors.mustardYellow : OryzaColors.militaryGreen,
          ),
        ),
      ),
    );
  }

  PopupMenuItem<OryzaBackgroundStyle> _buildItem({
    required OryzaBackgroundStyle value,
    required String title,
    required String subtitle,
    required bool isSelected,
    required bool isDark,
    required IconData icon,
  }) {
    return PopupMenuItem<OryzaBackgroundStyle>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? OryzaColors.burntOrange
                : (isDark ? Colors.white60 : Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? OryzaColors.burntOrange
                        : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: OryzaTypography.fontFamily,
                    package: 'oryzaelo_ui',
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected) ...[
            const SizedBox(width: 8),
            const Icon(Icons.check, size: 16, color: OryzaColors.burntOrange),
          ],
        ],
      ),
    );
  }
}
