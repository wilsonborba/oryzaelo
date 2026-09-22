import 'package:flutter/material.dart';
import '../core/state.dart';
import '../core/theme.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OryzaScope.of(context);
    final isDark = controller.isDark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: controller.toggleTheme,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: isDark ? OryzaColors.darkSurface : const Color(0xFFECEAE0),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? OryzaColors.darkBorder : OryzaColors.lightBorder,
              width: 1,
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => RotationTransition(
              turns: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              key: ValueKey<bool>(isDark),
              size: 16,
              color: isDark ? OryzaColors.mustardYellow : OryzaColors.botanicalGreen,
            ),
          ),
        ),
      ),
    );
  }
}
