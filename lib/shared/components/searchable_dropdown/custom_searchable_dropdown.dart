import 'package:flutter/material.dart';

import 'package:attendly/shared/extensions/extensions.dart';
import '../dropdown_search/dropdown_search.dart';

class CustomSearchableDropdown<T> extends StatelessWidget {
  final List<T>? items;
  final T? selectedItem;
  final String Function(T) itemAsString;
  final bool Function(T?, T?) compareFn;
  final String? hintText;
  final String? label;
  final void Function(T?) onChanged;

  const CustomSearchableDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.itemAsString,
    this.hintText,
    required this.onChanged,
    required this.compareFn,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: label,
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            color: context.textTheme.bodySmall?.color,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.primaryColor),
            // default border
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 1.3),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      items: (String filter, LoadProps? lp) async {
        return items
                ?.where(
                  (e) => itemAsString(
                    e,
                  ).toLowerCase().contains(filter.toLowerCase()),
                )
                .toList() ??
            [];
      },
      selectedItem: selectedItem,
      popupProps: PopupProps.menu(
        scrollbarProps: ScrollbarProps(
          thumbColor: context.theme.primaryColor.addOpacity(0.8),
          thumbVisibility: true,
        ),
        itemBuilder: (context, item, isSelected, isHighlighted) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.theme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              itemAsString(item),
              style:
                  context.textTheme.bodyMedium, // Use custom style or default
            ),
          );
        },
        showSearchBox: true,
        fit: FlexFit.tight,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: context.theme.primaryColor),
              // default border
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: context.theme.primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 1.3),
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: hintText,
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              color: context.textTheme.bodySmall?.color,
            ),
          ),
        ),
      ),
      dropdownBuilder: (context, item) =>
          Text(item != null ? itemAsString(item) : ''),
      itemAsString: itemAsString,
      compareFn: compareFn,
      onChanged: onChanged,
    );
  }
}
