import 'package:intl/intl.dart';

extension DateTimeFormatExtension on DateTime {
  String formatToDisplay() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
  }

  String formatToDateOnly() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String formatToTimeOnly() {
    return DateFormat('hh:mm a').format(this);
  }
}
