import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgroTheme {
  // Brand color palette
  static const Color primary = Color(0xFF4CAF50);
  static const Color secondary = Color(0xFF1B4332);
  static const Color background = Color(0xFF07130B);
  static const Color surface = Color(0xFF0F1F14);
  static const Color cardBg = Color(0x0DFFFFFF); // rgba(255, 255, 255, 0.05)
  
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8C5BE);
  static const Color accentGold = Color(0xFFFBBF24);
  static const Color accentGlow = Color(0x334CAF50);
  static const Color border = Color(0x1A4CAF50); // Soft green border
  
  // Border radius
  static const double radiusVal = 20.0;
  static final BorderRadius radius = BorderRadius.circular(radiusVal);
  static final BorderRadius radiusSm = BorderRadius.circular(12.0);

  // Soft elegant shadow
  static final List<BoxShadow> shadows = [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 15,
      offset: const Offset(0, 8),
    ),
  ];

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      cardColor: surface,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
        onPrimary: Colors.white,
        onSecondary: textPrimary,
        onSurface: textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.sora(fontSize: 32, fontWeight: FontWeight.extrabold, color: textPrimary),
        displayMedium: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),
        titleLarge: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.semibold, color: textPrimary),
        bodyLarge: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.normal, color: textSecondary, height: 1.5),
        bodyMedium: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.normal, color: textSecondary),
        labelLarge: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background.withOpacity(0.95),
        elevation: 0,
        titleTextStyle: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
    );
  }
}
