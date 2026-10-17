import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class LoadingIndicator extends StatelessWidget {
  final String? loadingInfo;
  final bool showText;
  final double? width;

  const LoadingIndicator({
    super.key,
    this.loadingInfo,
    this.showText = true,
    this.width
  });

  /// Factory: Only indicator (no title/text)
  factory LoadingIndicator.onlyIndicator() {
    return LoadingIndicator(
      showText: false,
      loadingInfo: null,
      width: $styles.size.size100 * 7,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 3,
      children: [
        Lottie.asset(
          "assets/animations/loading.json",
          width: width ?? $styles.size.size300 * 2,
          height: width ?? $styles.size.size300 * 2,
          fit: BoxFit.cover,
        ),
        if (showText)
          Column(
            children: [
              ($styles.insets.xxs).toHeightSizedBox,
              Text(
                loadingInfo ?? "Loading . . .",
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 12
                ),
              ),
            ],
          ),
      ],
    );
  }
}
