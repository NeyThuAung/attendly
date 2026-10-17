import 'dart:convert';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger(this._logger);

  final Logger _logger;

  void debug(String message, {Map<String, dynamic>? data}) {
    final buffer = StringBuffer(message);
    if (data != null) {
      buffer
        ..writeln()
        ..writeln(const JsonEncoder.withIndent('  ').convert(data));
    }
    _logger.d(buffer.toString());
  }

  void info(String message, {Map<String, dynamic>? data}) {
    final buffer = StringBuffer(message);
    if (data != null) {
      buffer
        ..writeln()
        ..writeln(const JsonEncoder.withIndent('  ').convert(data));
    }
    _logger.i(buffer.toString());
  }

  void error(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    final buffer = StringBuffer(message);
    if (data != null) {
      buffer
        ..writeln()
        ..writeln(const JsonEncoder.withIndent('  ').convert(data));
    }
    _logger.e(buffer.toString(), error: error, stackTrace: stackTrace);
  }
}
