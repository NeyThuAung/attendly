import 'package:flutter/material.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key, this.color,this.thickness
  });

  final Color? color;
  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: $styles.insets.xxs,
      color: color ?? context.theme.dividerColor,
      thickness: thickness ?? 0,
    );
  }
}
