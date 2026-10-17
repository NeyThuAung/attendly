import 'package:flutter/material.dart';
import 'package:attendly/flavors.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;
  final bool show;

  const FlavorBanner({
    super.key,
    required this.child,
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return child;

    return Banner(
      location: BannerLocation.topStart,
      message: F.name,
      color: Colors.black,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12.0,
        letterSpacing: 1.0,
      ),
      textDirection: TextDirection.ltr,
      child: child,
    );
  }
}
