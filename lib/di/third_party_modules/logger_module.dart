import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'app_logger.dart';

@module
abstract class LoggerModule {
  @lazySingleton
  Logger get logger => Logger(
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 5,
          lineLength: 100,
          colors: true,
          printEmojis: true,
        ),
      );

  @lazySingleton
  AppLogger appLogger(Logger logger) => AppLogger(logger);
}
