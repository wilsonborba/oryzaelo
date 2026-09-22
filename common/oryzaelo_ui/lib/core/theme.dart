import 'package:flutter/material.dart';

/// Oryza-Elo Canonical Design System Tokens and Theming
/// Following Swiss Design, Minimalism, and Botanical Laboratory aesthetics.
class OryzaColors {
  // Brand Core Colors (Selected by User)
  static const Color burntOrange = Color(0xFFD4532B); // Laranja levemente queimado (Ação / Destaque)
  static const Color militaryGreen = Color(0xFF2A3828); // Verde clássico para referências estruturais
  static const Color mustardYellow = Color(0xFFD9A028); // Amarelo mostarda (Marca-texto / Maturação)

  // Botanical Green Accents (Light Mode & Field Highlights)
  static const Color botanicalGreen = Color(0xFF2E6B34); // Verde botânico refinado para toques leves
  static const Color botanicalGreenLight = Color(0xFFEAF3EB); // Fundo sutil de chips e badges
  static const Color botanicalGreenBorder = Color(0xFFB4D2B8); // Borda hairline botânica suave

  // Light Theme Canvas & Ink (Warm Graph Paper)
  static const Color lightCanvas = Color(0xFFF7F6F0); // Papel milimetrado sutil
  static const Color lightSurface = Color(0xFFFFFFFF); // Branco marfim
  static const Color lightBorder = Color(0xFF2A3828); // Borda hairline / traço técnico
  static const Color lightTextPrimary = Color(0xFF1B231B); // Nanquim quase preto
  static const Color lightTextSecondary = Color(0xFF616B5F); // Anotações técnicas
  static const Color lightGridLine = Color(0xFFE5E3D8); // Linhas do papel milimetrado

  // Dark Theme Canvas & Ink ("Terra Fértil & Âmbar da Safra" - Warm Earth Espresso Base)
  // Substitui o verde militar por tons quentes de terra roxa e café queimado
  static const Color darkCanvas = Color(0xFF14110E); // Terra fértil profunda / Espresso Obsidian
  static const Color darkSurface = Color(0xFF1D1814); // Cerâmica queimada / placas elevadas
  static const Color darkBorder = Color(0xFF382E25); // Borda técnica âmbar / terra queimada
  static const Color darkTextPrimary = Color(0xFFF3EEE6); // Marfim fosco quente
  static const Color darkTextSecondary = Color(0xFFA69687); // Metadados em tom linho / areia
  static const Color darkGridLine = Color(0xFF241D17); // Linhas quentes de várzea
}

class OryzaTypography {
  // Canonical Typography: Ubuntu Sans across the entire application
  static const String fontFamily = 'Ubuntu Sans';
  static const String monoFontFamily = 'Ubuntu Sans Mono';

  static TextTheme textTheme(Color textColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        package: 'oryzaelo_ui',
        fontSize: 56,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        package: 'oryzaelo_ui',
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: textColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        package: 'oryzaelo_ui',
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        package: 'oryzaelo_ui',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        package: 'oryzaelo_ui',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        package: 'oryzaelo_ui',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        package: 'oryzaelo_ui',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        package: 'oryzaelo_ui',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: textColor,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        package: 'oryzaelo_ui',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: textColor,
      ),
      labelSmall: TextStyle(
        fontFamily: monoFontFamily,
        package: 'oryzaelo_ui',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
        color: textColor,
      ),
    );
  }
}

class OryzaTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: OryzaTypography.fontFamily,
      scaffoldBackgroundColor: OryzaColors.lightCanvas,
      colorScheme: const ColorScheme.light(
        primary: OryzaColors.burntOrange,
        onPrimary: Colors.white,
        secondary: OryzaColors.botanicalGreen,
        onSecondary: Colors.white,
        tertiary: OryzaColors.mustardYellow,
        surface: OryzaColors.lightSurface,
        onSurface: OryzaColors.lightTextPrimary,
        outline: OryzaColors.lightBorder,
      ),
      textTheme: OryzaTypography.textTheme(OryzaColors.lightTextPrimary),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: OryzaTypography.fontFamily,
      scaffoldBackgroundColor: OryzaColors.darkCanvas,
      colorScheme: const ColorScheme.dark(
        primary: OryzaColors.burntOrange,
        onPrimary: Colors.white,
        secondary: OryzaColors.mustardYellow,
        onSecondary: Colors.black,
        tertiary: OryzaColors.burntOrange,
        surface: OryzaColors.darkSurface,
        onSurface: OryzaColors.darkTextPrimary,
        outline: OryzaColors.darkBorder,
      ),
      textTheme: OryzaTypography.textTheme(OryzaColors.darkTextPrimary),
    );
  }
}
