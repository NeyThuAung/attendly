import 'package:flutter/material.dart';
import 'colors.dart';
import 'corners.dart';
import 'sizes.dart';
import 'typography.dart';

class AppStyles {
  final double scale = 1.0;
  final bool useMaterial3 = true;
  final ThemeMode themeMode;
  final Size? screenSize;

  AppStyles({this.themeMode = ThemeMode.light, this.screenSize});

  late final typography = AppTypography(null);
  late final color = _Colors();
  late final insets = _Insets();
  late final corner = AppCorners();
  late final time = _Times();
  late final size = _Sizes();
  late final grid = _GridSystem(screenSize ?? Size.zero);

  late final light = ThemeData.light(useMaterial3: true).copyWith(
    primaryColor: AppColors.clrPrimary,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    cardColor: AppColors.clrWhite,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.clrPrimary,
      primary: AppColors.clrPrimary,
      onPrimary: Colors.white,
      brightness: Brightness.light,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.clrPrimary,
        foregroundColor: Colors.white,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.clrPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  late final dark = ThemeData.dark(useMaterial3: true).copyWith(
    primaryColor: AppColors.clrPrimaryDark,
    scaffoldBackgroundColor: AppColors.clrOffBlack,
    cardColor: AppColors.clrDarkerGrey,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.clrPrimary,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.clrOffBlack,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}

class _Colors {
  Color get clrSuccess => AppColors.clrSuccess;
  Color get clrPrimary => AppColors.clrPrimary;
  Color get clrPrimaryDark => AppColors.clrPrimaryDark;
  Color get clrSecondary => AppColors.clrSecondary;
  Color get clrWhite => AppColors.clrWhite;
  Color get clrBlack => AppColors.clrBlack;
  Color get clrBlue => AppColors.clrBlue;
  Color get clrRed => AppColors.clrRed;
  Color get clrSofterGrey => AppColors.clrSofterGrey;
  Color get clrSoftGrey => AppColors.clrSoftGrey;
  Color get clrGrey => AppColors.clrGrey;
  Color get clrDarkGrey => AppColors.clrDarkGrey;
  Color get clrDarkerGrey => AppColors.clrDarkerGrey;
  Color get background => AppColors.background;
  Color get scaffoldBackgroundColor => AppColors.scaffoldBackgroundColor;

  final List<Color> colors = [
    Colors.yellow,
    Colors.grey,
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
    Colors.green,
  ];

  Color getRandomColor(String firstChar) {
    if (firstChar.isEmpty) return colors[0];
    int index = firstChar.codeUnitAt(0) % colors.length;
    return colors[index];
  }
}

class _Insets {
  final double xxs = AppSizes.size50;
  final double xs = AppSizes.size100;
  final double sm = AppSizes.size200;
  final double md = AppSizes.size300;
  final double lg = AppSizes.size400;
  final double xl = AppSizes.size600;
}

class _Sizes {
  final double size50 = AppSizes.size50;
  final double size100 = AppSizes.size100;
  final double size200 = AppSizes.size200;
  final double size300 = AppSizes.size300;
  final double size400 = AppSizes.size400;
  final double size500 = AppSizes.size500;
  final double size600 = AppSizes.size600;
  final double size700 = AppSizes.size700;
  final double size800 = AppSizes.size800;
  final double size900 = AppSizes.size900;
}

class _GridSystem {
  final Size size;
  _GridSystem(this.size);

  int get columns => size.width > 800 ? 12 : 4;
  double get columnsMargin => size.width > 800 ? 32 : 16;
  double get columnsGutter => 16;
}

class _Times {
  final Duration fast = const Duration(milliseconds: 200);
  final Duration med = const Duration(milliseconds: 400);
  final Duration slow = const Duration(milliseconds: 800);
}
