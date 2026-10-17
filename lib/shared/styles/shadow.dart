import 'package:flutter/material.dart';

abstract class AppShadows {
  static const List<BoxShadow> light = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> dark = [
    BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 4)),
  ];
}
