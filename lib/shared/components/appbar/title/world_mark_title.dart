import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class LogoWorldMarkTitle extends StatelessWidget {
  const LogoWorldMarkTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: $styles.grid.columnsMargin),
          child: InkWell(
            onTap: () => context.go("/"),
            child: Image.asset(
              R.images.logoTransparent,
              height: $styles.size.size100 * 5 * $styles.scale,
            ),
          ),
        );
      },
    );
  }
}
