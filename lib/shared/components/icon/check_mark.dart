import 'package:flutter/material.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class CheckMark extends StatelessWidget {
  const CheckMark({
    super.key,
    this.iconSize,
  });

  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all($styles.insets.xxs / 2),
      child: Icon(
        Icons.check,
        color: context.theme.colorScheme.onPrimary,
        size: iconSize ?? $styles.size.size100 * 18,
      ),
    );
  }
}
