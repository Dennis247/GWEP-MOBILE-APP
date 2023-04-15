import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: AppColors.primaryColor,
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.primaryColor),

      // Define the default font family.

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: GoogleFonts.poppinsTextTheme());

  //  textTheme: GoogleFonts.poppinsTextTheme(TextTheme(
  //   displayLarge: GoogleFonts.poppins(textStyle: TextStyle()),
  //   displayMedium: GoogleFonts.poppins(textStyle: textTheme.displayMedium),
  //   displaySmall: GoogleFonts.poppins(textStyle: textTheme.displaySmall),
  //   headlineLarge: GoogleFonts.poppins(textStyle: textTheme.headlineLarge),
  //   headlineMedium:
  //       GoogleFonts.poppins(textStyle: textTheme.headlineMedium),
  //   headlineSmall: GoogleFonts.poppins(textStyle: textTheme.headlineSmall),
  //   titleLarge: GoogleFonts.poppins(textStyle: textTheme.titleLarge),
  //   titleMedium: GoogleFonts.poppins(textStyle: textTheme.titleMedium),
  //   titleSmall: GoogleFonts.poppins(textStyle: textTheme.titleSmall),
  //   bodyLarge: GoogleFonts.poppins(textStyle: textTheme.bodyLarge),
  //   bodyMedium: GoogleFonts.poppins(textStyle: textTheme.bodyMedium),
  //   bodySmall: GoogleFonts.poppins(textStyle: textTheme.bodySmall),
  //   labelLarge: GoogleFonts.poppins(textStyle: textTheme.labelLarge),
  //   labelMedium: GoogleFonts.poppins(textStyle: textTheme.labelMedium),
  //   labelSmall: GoogleFonts.poppins(textStyle: textTheme.labelSmall),
  // )));
}
