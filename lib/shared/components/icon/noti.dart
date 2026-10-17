import 'package:flutter/material.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class NotiIcon extends StatelessWidget {
  final int? count;
  final VoidCallback? onTap;

  const NotiIcon({super.key, this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          if (count != null && count! > 0)
            Container(
              padding: EdgeInsets.all(
                $styles.insets.xxs / 3,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: EdgeInsets.all($styles.insets.xxs + (count! <= 9 ? 3 : 0)),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count! <= 99 ? "$count" : "99+",
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.theme.colorScheme.onPrimary,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
