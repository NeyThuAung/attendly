import 'package:flutter/material.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class SettingRowTile extends StatelessWidget {
  const SettingRowTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.status,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? status;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: $styles.insets.sm,
          horizontal: $styles.insets.xs * 1.5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: context.theme.primaryColor,
                ),
                $styles.insets.xs.toWidthSizedBox,
                Text(label),
              ],
            ),
            Row(
              children: [
                if (status != null) status!,
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.theme.disabledColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
