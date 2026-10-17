import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CustomSearchableMultiSelect<T> extends StatelessWidget {
  final List<T> items;
  final List<T> initialValue;
  final String Function(T) itemAsString;
  final void Function(List<T>) onConfirm;
  final String title;
  final String buttonText;

  const CustomSearchableMultiSelect({
    super.key,
    required this.items,
    required this.itemAsString,
    required this.onConfirm,
    this.initialValue = const [],
    required this.title,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField<T>(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      buttonIcon: const Icon(Icons.arrow_drop_down),
      buttonText: Text(
        buttonText,
        overflow: TextOverflow.visible,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
      title: Text(
        title,
        overflow: TextOverflow.visible,
      ),
      searchable: true,
      items: items.map((e) => MultiSelectItem<T>(e, itemAsString(e))).toList(),
      initialValue: initialValue,
      onConfirm: (values) => onConfirm(values),
      chipDisplay: MultiSelectChipDisplay(
        chipColor: Theme.of(context).primaryColor,
        textStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
