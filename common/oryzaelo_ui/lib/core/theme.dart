import 'package:flutter/material.dart';

/// Oryza-Elo Canonical Design System Tokens and Theming
/// Following Swiss Design, Minimalism, and Botanical Laboratory aesthetics.
class OryzaColors {
  // Brand Core Colors (Selected by User)
  static const Color burntOrange = Color(0xFFD4532B); // Laranja levemente queimado (Ação / Destaque)
  static const Color militaryGreen = Color(0xFF2A3828); // Verde militar escuro (Estrutura / Identidade)
  static const Color mustardYellow = Color(0xFFD9A028); // Amarelo mostarda (Marca-texto / Maturação)

  // Light Theme Canvas & Ink (Warm Graph Paper)
  static const Color lightCanvas = Color(0xFFF7F6F0); // Papel milimetrado sutil
  static const Color lightSurface = Color(0xFFFFFFFF); // Branco marfim
  static const Color lightBorder = Color(0xFF2A3828); // Borda hairline / traço técnico
  static const Color lightTextPrimary = Color(0xFF1B231B); // Nanquim quase preto
  static const Color lightTextSecondary = Color(0xFF616B5F); // Anotações técnicas
  static const Color lightGridLine = Color(0xFFE5E3D8); // Linhas do papel milimetrado

  // Dark Theme Canvas & Ink (Nighttime Field Station)
  static const Color darkCanvas = Color(0xFF141914); // Verde militar ultra-escuro / noite no campo
  static const Color darkSurface = Color(0xFF1C231C); // Placas elevadas
  static const Color darkBorder = Color(0xFF2F3B2E); // Borda técnica noturna
  static const Color darkTextPrimary = Color(0xFFEDECE4); // Marfim fosco lunar
  static const Color darkTextSecondary = Color(0xFF8E9B8B); // Metadados fosforescentes
  static const Color darkGridLine = Color(0xFF1C261C); // Linhas noturnas
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
        secondary: OryzaColors.militaryGreen,
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
        secondary: OryzaColors.militaryGreen,
        onSecondary: Colors.white,
        tertiary: OryzaColors.mustardYellow,
        surface: OryzaColors.darkSurface,
        onSurface: OryzaColors.darkTextPrimary,
        outline: OryzaColors.darkBorder,
      ),
      textTheme: OryzaTypography.textTheme(OryzaColors.darkTextPrimary),
    );
  }
}
