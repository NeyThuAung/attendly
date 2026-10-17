import 'package:flutter/material.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class BadgeWithCount extends StatelessWidget {
  const BadgeWithCount({
    super.key,
    required this.notiCount,
    required this.onPressed,
    this.iconColor,
  });

  final int notiCount;
  final Color? iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: $styles.grid.columnsMargin / 2 - 4,
          ),
          child: IconButton(
            iconSize: 26,
            onPressed: onPressed,
            icon: Icon(
              Icons.notifications_rounded,
              color: iconColor,
            ),
          ),
        ),
        if (notiCount != 0)
          Positioned(
            top: 2,
            right: $styles.grid.columnsMargin / 2 + (notiCount < 10 ? 2 : 0),
            child: NotiCountCircle(notiCount: notiCount),
          ),
      ],
    );
  }
}

class NotiCountCircle extends StatelessWidget {
  const NotiCountCircle({
    super.key,
    required this.notiCount,
  });

  final int notiCount;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            fontSize: (notiCount <= 99) ? 8.5 : 9.0,
            fontWeight: FontWeight.bold,
          ),
          //  textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
