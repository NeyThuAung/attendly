import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'styles.dart';

class AppTypography {
  final Locale? _locale;

  AppTypography(this._locale);

  final tsEnglish = GoogleFonts.poppins().copyWith(
    letterSpacing: 0.5,
  );
  final tsUnicode = GoogleFonts.poppins().copyWith(
    letterSpacing: 0.5,
  );

  late final fontStyle =
      {
        "en": tsEnglish,
        "my": tsUnicode,
      }[_locale?.languageCode] ??
      tsUnicode;

  late final heading1 = fontStyle.copyWith(
    fontSize: 20.0,
    color: $styles.color.clrBlack,
  );

  late final heading2 = fontStyle.copyWith(
    fontSize: 18.0,
    color: $styles.color.clrBlack,
  );

  late final heading3 = fontStyle.copyWith(
    fontSize: 16.0,
    color: $styles.color.clrBlack,
  );

  late final paragraph1 = fontStyle.copyWith(
    fontSize: 16.0,
    color: $styles.color.clrBlack,
  );

  late final paragraph2 = fontStyle.copyWith(
    fontSize: 14.0,
    color: $styles.color.clrBlack,
  );

  late final paragraph3 = fontStyle.copyWith(
    fontSize: 12.0,
    color: $styles.color.clrBlack,
  );

  late final _defaultTextOverFlow = TextOverflow.ellipsis;
  late final _defaultM3TextTheme = ThemeData(
    useMaterial3: true,
    fontFamily: fontStyle.fontFamily,
  ).textTheme;

  late final light = _defaultM3TextTheme.copyWith(
    titleLarge: heading1.copyWith(overflow: _defaultTextOverFlow),
    titleMedium: heading2.copyWith(overflow: _defaultTextOverFlow),
    titleSmall: heading3.copyWith(overflow: _defaultTextOverFlow),
    bodyLarge: paragraph1.copyWith(overflow: _defaultTextOverFlow),
    bodyMedium: paragraph2.copyWith(overflow: _defaultTextOverFlow),
    bodySmall: paragraph3.copyWith(overflow: _defaultTextOverFlow),
    displayLarge: _defaultM3TextTheme.displayLarge?.copyWith(
      overflow: _defaultTextOverFlow,
    ),
    displayMedium: _defaultM3TextTheme.displayMedium?.copyWith(
      overflow: _defaultTextOverFlow,
    ),
    displaySmall: _defaultM3TextTheme.displaySmall?.copyWith(
      overflow: _defaultTextOverFlow,
    ),
    headlineLarge: _defaultM3TextTheme.headlineLarge?.copyWith(
      overflow: _defaultTextOverFlow,
    ),
    headlineMedium: _defaultM3TextTheme.headlineMedium?.copyWith(
      overflow: _defaultTextOverFlow,
    ),
    headlineSmall: _defaultM3TextTheme.headlineSmall?.copyWith(
      overflow: _defaultTextOverFlow,
    ),
    labelLarge: _defaultM3TextTheme.labelLarge?.copyWith(
      overflow: _defaultTextOverFlow,
    ),
    labelMedium: _defaultM3TextTheme.labelMedium?.copyWith(
      overflow: _defaultTextOverFlow,
    ),
    labelSmall: _defaultM3TextTheme.labelSmall?.copyWith(
      overflow: _defaultTextOverFlow,
    ),
  );

  late final dark = _defaultM3TextTheme.copyWith(
    titleLarge: heading1.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    titleMedium: heading2.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    titleSmall: heading3.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    bodyLarge: paragraph1.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    bodyMedium: paragraph2.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    bodySmall: paragraph3.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    displayLarge: _defaultM3TextTheme.displayLarge?.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    displayMedium: _defaultM3TextTheme.displayMedium?.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    displaySmall: _defaultM3TextTheme.displaySmall?.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    headlineLarge: _defaultM3TextTheme.headlineLarge?.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    headlineMedium: _defaultM3TextTheme.headlineMedium?.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    headlineSmall: _defaultM3TextTheme.headlineSmall?.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    labelLarge: _defaultM3TextTheme.labelLarge?.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    labelMedium: _defaultM3TextTheme.labelMedium?.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
    labelSmall: _defaultM3TextTheme.labelSmall?.copyWith(
      overflow: _defaultTextOverFlow,
      color: AppColors.clrWhite,
    ),
  );
}
