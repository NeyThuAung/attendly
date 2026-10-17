import 'package:flutter/material.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class NotiElevatedButton extends StatelessWidget {
  const NotiElevatedButton({
    super.key,
    required this.notiCount,
    required this.title,
    this.onPressed,
  });

  final int notiCount;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(
          top: $styles.insets.xs * 1.5,
          bottom: $styles.insets.xs * 1.5,
          left: $styles.insets.xs,
          right: $styles.insets.xxs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular($styles.insets.xs),
          border: Border.all(
            color: notiCount != 0
                ? context.theme.primaryColor.addOpacity(0.7)
                : context.theme.dividerColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(title)),
            Row(
              children: [
                if (notiCount != 0)
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        (notiCount >= 99) ? "99+" : "$notiCount",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (notiCount <= 99) ? 11 : 12,
                          fontWeight: FontWeight.bold,
                        ),
                        //  textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                Icon(Icons.chevron_right_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
