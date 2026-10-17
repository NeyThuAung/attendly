import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final double size;
  final String path;
  final Color? color;

  const SvgIcon(
    this.path, {
    super.key,
    this.size = kSize,
    this.color,
  });

  static const double kSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      // ignore: deprecated_member_use
      color: color ?? IconTheme.of(context).color!,
      theme: SvgTheme(
        currentColor: color ?? IconTheme.of(context).color!,
      ),
    );
  }
}
