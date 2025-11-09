import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
class AppTheme {
  AppTheme._();

  // Sustainable Trust Palette - Color specifications
  static const Color primaryLight = Color(0xFF2D5A3D); // Deep forest green
  static const Color primaryVariantLight = Color(0xFF1E3D2A);
  static const Color secondaryLight = Color(0xFFFF6B47); // Warm coral
  static const Color secondaryVariantLight = Color(0xFFE55A3F);
  static const Color accentLight = Color(0xFFF4A261); // Golden amber
  static const Color backgroundLight = Color(0xFFFEFEFE); // Pure white
  static const Color surfaceLight = Color(0xFFF8F9FA); // Subtle warm gray
  static const Color successLight = Color(0xFF27AE60); // Clear green
  static const Color warningLight = Color(0xFFF39C12); // Amber orange
  static const Color errorLight = Color(0xFFE74C3C); // Clean red
  static const Color textPrimaryLight = Color(0xFF2C3E50); // Dark blue-gray
  static const Color textSecondaryLight = Color(0xFF7F8C8D); // Medium gray
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight = Color(0xFF2C3E50);
  static const Color onSurfaceLight = Color(0xFF2C3E50);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  // Dark theme colors
  static const Color primaryDark = Color(0xFF4A7C59);
  static const Color primaryVariantDark = Color(0xFF2D5A3D);
  static const Color secondaryDark = Color(0xFFFF8A6B);
  static const Color secondaryVariantDark = Color(0xFFFF6B47);
  static const Color accentDark = Color(0xFFF4A261);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surfaceDark = Color(0xFF2D2D2D);
  static const Color successDark = Color(0xFF2ECC71);
  static const Color warningDark = Color(0xFFF39C12);
  static const Color errorDark = Color(0xFFE74C3C);
  static const Color textPrimaryDark = Color(0xFFECF0F1);
  static const Color textSecondaryDark = Color(0xFFBDC3C7);
  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFF000000);
  static const Color onBackgroundDark = Color(0xFFECF0F1);
  static const Color onSurfaceDark = Color(0xFFECF0F1);
  static const Color onErrorDark = Color(0xFFFFFFFF);

  // Card and dialog colors
  static const Color cardLight = Color(0xFFF8F9FA);
  static const Color cardDark = Color(0xFF2D2D2D);
  static const Color dialogLight = Color(0xFFFEFEFE);
  static const Color dialogDark = Color(0xFF2D2D2D);

  // Shadow colors
  static const Color shadowLight = Color(0x0A000000); // 0.04 opacity
  static const Color shadowDark = Color(0x0AFFFFFF); // 0.04 opacity

  // Divider colors
  static const Color dividerLight = Color(0xFFE9ECEF);
  static const Color dividerDark = Color(0xFF495057);

  /// Light theme
  static ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: primaryLight,
    onPrimary: onPrimaryLight,
    primaryContainer: primaryVariantLight,
    onPrimaryContainer: onPrimaryLight,
    secondary: secondaryLight,
    onSecondary: onSecondaryLight,
    secondaryContainer: secondaryVariantLight,
    onSecondaryContainer: onSecondaryLight,
    tertiary: accentLight,
    onTertiary: Color(0xFF000000),
    tertiaryContainer: accentLight.withValues(alpha: 0.2),
    onTertiaryContainer: Color(0xFF000000),
    error: errorLight,
    onError: onErrorLight,
    surface: surfaceLight,
    onSurface: onSurfaceLight,
    onSurfaceVariant: textSecondaryLight,
    outline: dividerLight,
    outlineVariant: dividerLight.withValues(alpha: 0.5),
    shadow: shadowLight,
    scrim: shadowLight,
    inverseSurface: surfaceDark,
    onInverseSurface: onSurfaceDark,
    inversePrimary: primaryDark,
  ),
  scaffoldBackgroundColor: backgroundLight,
  cardColor: cardLight,
  dividerColor: dividerLight,

  appBarTheme: AppBarTheme(
    backgroundColor: backgroundLight,
    foregroundColor: textPrimaryLight,
    elevation: 1.0,
    shadowColor: shadowLight,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textPrimaryLight,
    ),
    iconTheme: IconThemeData(color: textPrimaryLight),
    actionsIconTheme: IconThemeData(color: textPrimaryLight),
  ),

  cardTheme: CardThemeData(
    color: cardLight,
    elevation: 1.0,
    shadowColor: shadowLight,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: backgroundLight,
    selectedItemColor: primaryLight,
    unselectedItemColor: textSecondaryLight,
    elevation: 2.0,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: secondaryLight,
    foregroundColor: onSecondaryLight,
    elevation: 2.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: onSecondaryLight,
      backgroundColor: secondaryLight,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryLight,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      side: BorderSide(color: dividerLight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  textTheme: _buildTextTheme(isLight: true),

  inputDecorationTheme: InputDecorationTheme(
    fillColor: backgroundLight,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(color: dividerLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(color: dividerLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(color: primaryLight, width: 2.0),
    ),
  ),

  tabBarTheme: TabBarThemeData(
    labelColor: primaryLight,
    unselectedLabelColor: textSecondaryLight,
    indicatorColor: primaryLight,
    indicatorSize: TabBarIndicatorSize.label,
    labelStyle: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: dialogLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
  ),
);


  /// Dark theme
  static ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: primaryDark,
    onPrimary: onPrimaryDark,
    primaryContainer: primaryVariantDark,
    onPrimaryContainer: onPrimaryDark,
    secondary: secondaryDark,
    onSecondary: onSecondaryDark,
    secondaryContainer: secondaryVariantDark,
    onSecondaryContainer: onSecondaryDark,
    tertiary: accentDark,
    onTertiary: Color(0xFF000000),
    tertiaryContainer: accentDark.withValues(alpha: 0.2),
    onTertiaryContainer: Color(0xFFFFFFFF),
    error: errorDark,
    onError: onErrorDark,
    surface: surfaceDark,
    onSurface: onSurfaceDark,
    onSurfaceVariant: textSecondaryDark,
    outline: dividerDark,
    outlineVariant: dividerDark.withValues(alpha: 0.5),
    shadow: shadowDark,
    scrim: shadowDark,
    inverseSurface: surfaceLight,
    onInverseSurface: onSurfaceLight,
    inversePrimary: primaryLight,
  ),
  scaffoldBackgroundColor: backgroundDark,
  cardColor: cardDark,
  dividerColor: dividerDark,

  appBarTheme: AppBarTheme(
    backgroundColor: backgroundDark,
    foregroundColor: textPrimaryDark,
    elevation: 1.0,
    shadowColor: shadowDark,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textPrimaryDark,
    ),
    iconTheme: IconThemeData(color: textPrimaryDark),
    actionsIconTheme: IconThemeData(color: textPrimaryDark),
  ),

  cardTheme: CardThemeData(
    color: cardDark,
    elevation: 1.0,
    shadowColor: shadowDark,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  ),

  tabBarTheme: TabBarThemeData(
    labelColor: primaryDark,
    unselectedLabelColor: textSecondaryDark,
    indicatorColor: primaryDark,
    indicatorSize: TabBarIndicatorSize.label,
    labelStyle: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: dialogDark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
  ),
);

  /// Helper method to build text theme based on brightness
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textPrimary = isLight ? textPrimaryLight : textPrimaryDark;
    final Color textSecondary =
        isLight ? textSecondaryLight : textSecondaryDark;

    return TextTheme(
      // Display styles - Inter headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),

      // Headline styles - Inter headings
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),

      // Title styles - Inter headings
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.1,
      ),

      // Body styles - Inter body text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.4,
      ),

      // Label styles - Inter captions
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }
}
