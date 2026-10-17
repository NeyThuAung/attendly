import 'package:flutter/material.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class NormalCardWithBorder extends StatelessWidget {
  final Widget child;

  const NormalCardWithBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : $styles.color.clrSoftGrey;

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: isDark ? context.theme.cardColor : Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular($styles.corner.lg),
          side: BorderSide(
            width: 1,
            color: cardBorderColor,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all($styles.grid.columnsMargin),
          child: child,
        ),
      ),
    );
  }
}
