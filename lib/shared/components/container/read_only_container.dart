import 'package:flutter/material.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class ReadOnlyContainer extends StatelessWidget {
  const ReadOnlyContainer({
    super.key,
    required this.value,
    this.onPressed,
    this.icon,
    this.isHint = false,
  });

  final String value;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isHint;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: $styles.insets.xs * 1.3,
          vertical: $styles.insets.xs * 1.5,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isHint
                ? context.theme.textTheme.bodySmall!.color!.addOpacity(0.2)
                : context.theme.primaryColor,
          ),
          borderRadius: BorderRadius.circular($styles.insets.xxs * 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 15,
          children: [
            if (icon != null) Icon(icon),
            Flexible(
              child: Text(
                value,
                maxLines: 100,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isHint ? Colors.grey : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
