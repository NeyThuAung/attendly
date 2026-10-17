import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'text_button.dart';

class ConfirmCancelButton extends StatelessWidget {
  const ConfirmCancelButton({
    super.key,
    required this.onPressed,
    this.confirmTitle,
    this.spacing,
    this.cancelOnPressed,
    this.cancelTitle,
    this.color,
  });

  final VoidCallback onPressed;
  final VoidCallback? cancelOnPressed;
  final String? confirmTitle;
  final String? cancelTitle;
  final double? spacing;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomTextButton(
            color: context.theme.disabledColor,
            onPressed: cancelOnPressed ?? context.pop,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                cancelTitle ?? "Cancel",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.theme.disabledColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: spacing ?? $styles.insets.sm,
        ),
        Expanded(
          child: CustomTextButton(
            color: color ?? context.theme.primaryColor,
            onPressed: onPressed,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                confirmTitle ?? "Confirm",
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: color ?? context.theme.primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
