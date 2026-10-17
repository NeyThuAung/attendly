import 'package:flutter/material.dart';
import '../icon/svg_icon.dart';

class NavItem {
  final String? label;
  final dynamic icon;
  final dynamic selectedIcon;
  final Color? color;
  final Color? selectedColor;
  final int notiCount;

  const NavItem({
    required this.icon,
    required this.selectedIcon,
    this.color,
    this.selectedColor,
    this.label,
    this.notiCount = 0,
  });
}

class NavIconWidget extends StatelessWidget {
  final dynamic icon;
  final Color color;
  final double size;

  const NavIconWidget({
    super.key,
    required this.icon,
    required this.color,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    if (icon is IconData) {
      return Icon(
        icon as IconData,
        color: color,
        size: size,
      );
    } else if (icon is String) {
      return SvgIcon(
        icon as String,
        color: color,
        size: size,
      );
    } else if (icon is Widget) {
      return icon as Widget;
    }
    return const SizedBox.shrink();
  }
}
