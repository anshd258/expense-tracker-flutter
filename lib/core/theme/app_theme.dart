import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ShadThemeData lightTheme() {
    return ShadThemeData(
      brightness: Brightness.light,
      colorScheme: const ShadZincColorScheme.light(),
      textTheme: ShadTextTheme.fromGoogleFont(
        GoogleFonts.inter,
      ),
    );
  }

  static ShadThemeData darkTheme() {
    return ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: const ShadZincColorScheme.dark(),
      textTheme: ShadTextTheme.fromGoogleFont(
        GoogleFonts.inter,
      ),
    );
  }
}