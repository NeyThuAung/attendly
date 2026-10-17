import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'elevated_button.dart';

class ConfirmCancelRowButton extends StatelessWidget {
  const ConfirmCancelRowButton({
    super.key,
    required this.onPressed,
    this.confirmTitle,
    this.spacing,
    this.cancelOnPressed,
    this.cancelTitle,
    this.confirmButtonColor,
  });

  final VoidCallback onPressed;
  final VoidCallback? cancelOnPressed;
  final String? confirmTitle;
  final String? cancelTitle;
  final double? spacing;
  final Color? confirmButtonColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomElevatedButton(
            width: context.width,
            cancelButton: true,
            onPressed: cancelOnPressed ?? context.pop,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                cancelTitle ?? "Cancel",
              ),
            ),
          ),
        ),
        SizedBox(
          width: spacing ?? $styles.insets.sm,
        ),
        Expanded(
          child: CustomElevatedButton(
            backgroundColor: confirmButtonColor,
            width: context.width,
            onPressed: onPressed,
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(confirmTitle ?? "Confirm")),
          ),
        ),
      ],
    );
  }
}
