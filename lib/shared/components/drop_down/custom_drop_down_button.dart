import 'package:flutter/material.dart';

import 'package:attendly/shared/styles/styles.dart';
import 'package:attendly/shared/extensions/extensions.dart';
import 'drop_down_item.dart';

class CustomDropDownButton<T> extends StatelessWidget {
  final List<DropdownItem<T>> items;
  final T? selectedValue;
  final String hintText;
  final void Function(T?)? onChanged;
  final InputDecoration? decoration;
  final bool isDisable;

  const CustomDropDownButton({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.hintText,
    required this.onChanged,
    this.decoration,
    this.isDisable = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<T>(
        icon: Padding(
          padding: EdgeInsets.only(
            right: $styles.grid.columnsMargin - 2,
          ),
          child: const Icon(Icons.arrow_drop_down),
        ),
        style: context.textTheme.bodyMedium?.copyWith(
          overflow: TextOverflow.ellipsis,
        ),
        isDense: true,
        isExpanded: true,

        value: selectedValue,

        hint: Text(hintText),
        decoration:
            decoration ??
            InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: $styles.grid.columnsGutter,
                horizontal: $styles.grid.columnsMargin,
              ),
            ),
        items: items
            .map(
              (DropdownItem<T> item) => DropdownMenuItem<T>(
                value: item.value,
                child: Text(
                  item.label,
                  style: TextStyle(color: AppColors.clrBlack),
                ),
              ),
            )
            .toList(),

        onChanged: isDisable ? null : onChanged,
      ),
    );
  }
}
