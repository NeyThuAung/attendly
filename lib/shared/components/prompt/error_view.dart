import 'dart:math';
import 'package:flutter/material.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final String error;

  const ErrorView({
    super.key,
    required this.onRetry,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: min(
            context.width - (2 * 8),
            context.width * 0.8,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Failed",
              style: context.textTheme.titleMedium?.copyWith(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              error,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0),
              onPressed: onRetry,
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
