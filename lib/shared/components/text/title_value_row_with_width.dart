import 'package:flutter/material.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import '../icon/svg_icon.dart';

class TitleValueRowWithWidth extends StatelessWidget {
  const TitleValueRowWithWidth({
    super.key,
    required this.title,
    required this.value,
    this.width,
    this.icon,
  });

  final String title;
  final String value;
  final double? width;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? $styles.size.size100 * 12;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null)
          Row(
            children: [
              Icon(
                icon,
                color: context.theme.colorScheme.onPrimary,
                size: SvgIcon.kSize - 3,
              ),
              $styles.insets.xxs.toWidthSizedBox,
            ],
          ),
        SizedBox(
          width: effectiveWidth,
          child: Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.theme.colorScheme.onPrimary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 3,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class TitleValueRow extends StatelessWidget {
  const TitleValueRow({
    super.key,
    required this.title,
    required this.value,
    this.width,
    this.icon,
    this.iconColor,
    this.valueTextColor,
    this.isTitleGrey = false,
  });

  final String title;
  final String value;
  final double? width;
  final IconData? icon;
  final Color? iconColor;
  final Color? valueTextColor;
  final bool isTitleGrey;

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? $styles.size.size100 * 15;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null)
          Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? context.theme.colorScheme.onPrimary,
                size: SvgIcon.kSize - 3,
              ),
              $styles.insets.xxs.toWidthSizedBox,
            ],
          ),
        SizedBox(
          width: effectiveWidth,
          child: Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              color: isTitleGrey ? Colors.black87.addOpacity(0.6) : null,
            ),
            maxLines: 5,
          ),
        ),
        Text(":   "),
        Expanded(
          child: Text(
            value,
            maxLines: 5,
            style: context.textTheme.titleMedium?.copyWith(
              color: valueTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
