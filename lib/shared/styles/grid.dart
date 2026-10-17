import 'package:flutter/material.dart';

enum ScreenType { sm, md, lg }

class AppGridSystem {
  final Size size;
  const AppGridSystem(this.size);

  int get columns => size.width > 800 ? 12 : 4;
  double get margin => size.width > 800 ? 32 : 16;
  double get gutter => 16;
}
