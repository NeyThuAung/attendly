import 'package:flutter/material.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class InfoValueText extends StatelessWidget {
  const InfoValueText({super.key,
  required this.label,
    required this.value,
  });

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: 100,
      '$label: ${value ?? '-'}',
      style: context.textTheme.bodyMedium?.size13,
    );
  }
}
