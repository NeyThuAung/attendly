import 'package:flutter/material.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool? cancelButton;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? cancelButtonBorderColor;
  final double? elevation;

  const CustomElevatedButton({
    super.key,
    this.onPressed,
    required this.child,
    this.cancelButton,
    this.width,
    this.height,
    this.backgroundColor,
    this.cancelButtonBorderColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? $styles.size.size100 * 6.5,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: context.textTheme.bodyMedium,
          elevation: elevation,
          backgroundColor: cancelButton == true
              ? context.theme.colorScheme.onPrimary
              : backgroundColor,
          foregroundColor: cancelButton == true
              ? context.theme.colorScheme.primary
              : null,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color:
                  cancelButtonBorderColor ?? context.theme.colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(
                $styles.insets.xs + 4
            ), // Rounded corners
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: width != null
              ? EdgeInsets.zero
              : EdgeInsets.all($styles.insets.xs),
          child: child,
        ),
      ),
    );
  }
}
