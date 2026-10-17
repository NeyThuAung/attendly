import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:attendly/shared/extensions/extensions.dart';

enum SnackGravity { top, bottom }

abstract interface class Snacks {
  static void _showMessage(
    BuildContext context, {
    required String message,
    SnackGravity gravity = SnackGravity.top,
    Color? backgroundColor,
    Color? textColor,
  }) {
    showTopSnackBar(
      Overlay.of(context),
      OverflowControlSnackText(
        message: message,
        backgroundColor: backgroundColor,
        textColor: textColor,
      ),
    );
  }

  static void info(
    BuildContext context, {
    required String message,
    SnackGravity gravity = SnackGravity.top,
  }) {
    _showMessage(
      context,
      message: message,
      gravity: gravity,
      backgroundColor: context.theme.colorScheme.onSurface,
      textColor: context.theme.colorScheme.surface,
    );
  }

  static void error(
    BuildContext context, {
    required String message,
    SnackGravity gravity = SnackGravity.top,
  }) {
    _showMessage(
      context,
      message: message,
      gravity: gravity,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  static void success(
    BuildContext context, {
    required String message,
    SnackGravity gravity = SnackGravity.top,
  }) {
    _showMessage(
      context,
      message: message,
      gravity: gravity,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
}

class OverflowControlSnackText extends StatelessWidget {
  final String message;
  final Color? backgroundColor;
  final Color? textColor;

  const OverflowControlSnackText({
    super.key,
    required this.message,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.bodyMedium?.copyWith(
      color: textColor ?? context.theme.primaryColor,
    );

    final textSpan = TextSpan(text: message, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: double.infinity);

    bool isOverflowing =
        textPainter.width >
        MediaQuery.of(context).size.width - 32.0; // Adjust according to padding

    return !isOverflowing
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: backgroundColor ?? context.theme.cardColor,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor ?? context.theme.cardColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Column(
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  maxLines: 10,
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
  }
}
