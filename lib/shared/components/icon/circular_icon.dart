import 'package:flutter/material.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'svg_icon.dart';

class CircularIcon extends StatelessWidget {
  final Widget icon;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const CircularIcon({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.padding,
  });

  factory CircularIcon.asset(String path, {Color? color, double size = 16}) {
    return CircularIcon(
      icon: SvgIcon(
        path,
        color: color,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all($styles.insets.xs),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? context.theme.primaryColor.addOpacity(0.04),
      ),
      child: icon,
    );
  }
}
