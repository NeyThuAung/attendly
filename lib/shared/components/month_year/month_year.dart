import 'package:flutter/material.dart';

class MonthYearPickerField extends StatelessWidget {
  final int? selectedMonth;
  final int? selectedYear;
  final void Function(int month)? onMonthSelected;
  final void Function(int year)? onYearSelected;

  const MonthYearPickerField({
    super.key,
    this.selectedMonth,
    this.selectedYear,
    this.onMonthSelected,
    this.onYearSelected,
  });

  static const Map<int, String> months = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };

  Future<void> _showMonthDialog(BuildContext context) async {
    final picked = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Select Month"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: months.entries
                .map(
                  (e) => ListTile(
                    title: Text(e.value),
                    onTap: () => Navigator.pop(ctx, e.key),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
    if (picked != null && onMonthSelected != null) {
      onMonthSelected!(picked);
    }
  }

  Future<void> _showYearDialog(BuildContext context) async {
    final picked = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Select Year"),
        content: SizedBox(
          width: 300,
          height: 300,
          child: YearPicker(
            firstDate: DateTime(DateTime.now().year - 50),
            lastDate: DateTime(DateTime.now().year + 50),
            selectedDate: DateTime.now(),
            onChanged: (date) => Navigator.pop(ctx, date.year),
          ),
        ),
      ),
    );
    if (picked != null && onYearSelected != null) {
      onYearSelected!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Month Field
            Expanded(
              child: GestureDetector(
                onTap: () => _showMonthDialog(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    selectedMonth == null ? "Month" : months[selectedMonth]!,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Year Field
            Expanded(
              child: GestureDetector(
                onTap: () => _showYearDialog(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    selectedYear == null ? "Year" : selectedYear.toString(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
