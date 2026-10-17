import 'package:flutter/material.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final Color activeColor;
  final Color borderColor;
  final double? borderRadius;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.activeColor,
    required this.borderColor,
     this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              border: Border.all(
                color: value ? activeColor : borderColor,
                width: 2,
              ),
              color: value ? activeColor : Colors.transparent,
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
          $styles.insets.xxs.toWidthSizedBox,
          Text(label),
        ],
      ),
    );
  }
}
