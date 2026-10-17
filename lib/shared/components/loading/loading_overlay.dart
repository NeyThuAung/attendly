import 'package:flutter/material.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'loading_indicator.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String? loadingInfo;
  final Widget? child;

  const LoadingOverlay({
    super.key,
    this.isLoading = false,
    this.child,
    this.loadingInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          child ??
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
          if (isLoading)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.addOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: context.theme.cardColor,
                          borderRadius: BorderRadius.circular(
                            $styles.insets.md - 4,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: $styles.insets.sm,
                            vertical: $styles.insets.xs * 1.3,
                          ),
                          child: LoadingIndicator(loadingInfo: loadingInfo),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
