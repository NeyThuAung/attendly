import 'package:flutter/material.dart';

extension ColorOpacityExtension on Color {
  Color addOpacity(double opacity) => withOpacity(opacity);
}
