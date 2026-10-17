import 'package:flutter/material.dart';
import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class RememberEmployeeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const RememberEmployeeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: context.theme.primaryColor,
            visualDensity: VisualDensity.compact,
          ),
          Text(
            'Remember Me',
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: $styles.color.clrGrey,
            ),
          ),
        ],
      ),
    );
  }
}
