import 'dart:io';

import 'package:flutter/material.dart';

extension BottomPaddingExtension on BuildContext {
  double get bottomPadding {
    final bottomInset = MediaQuery.of(this).padding.bottom;

    if (Platform.isAndroid) {
      return bottomInset;
    }

    return bottomInset.clamp(0.0, 24.0).toDouble();
  }
}
