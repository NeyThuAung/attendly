import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class IconTextElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final Widget? child;

  final String? svgAsset;

  final String? label;
  final Color? textColor;

  final bool? cancelButton;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? cancelButtonBorderColor;
  final double? elevation;

  const IconTextElevatedButton({
    super.key,
    this.onPressed,
    this.child,
    this.svgAsset,
    this.label,
    this.textColor,
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
      height: height ?? $styles.size.size100 * 5.5,
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
          shape: cancelButton == true
              ? RoundedRectangleBorder(
                  side: BorderSide(
                    color:
                        cancelButtonBorderColor ??
                        context.theme.colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(
                    $styles.insets.sm,
                  ),
                )
              : null,
        ),
        onPressed: onPressed,
        child: child ?? _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (svgAsset != null) ...[
          SvgPicture.asset(
            svgAsset!,
            width: 17,
            height: 17,
          ),
          const SizedBox(width: 5),
        ],
        if (label != null)
          Flexible(
            child: Text(
              maxLines: 2,
              label!,
              style: context.textTheme.bodyMedium?.copyWith(
                color: textColor ?? $styles.color.clrBlack,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}
