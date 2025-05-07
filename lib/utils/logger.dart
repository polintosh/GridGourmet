import 'package:logger/logger.dart';

/// Utility class for standardized logging throughout the app
class AppLogger {
  // Singleton instance
  static final AppLogger _instance = AppLogger._internal();
  static AppLogger get instance => _instance;
  
  // Logger instance
  final Logger _logger;

  // Private constructor
  AppLogger._internal()
      : _logger = Logger(
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 5,
            lineLength: 80,
            colors: true,
            printEmojis: true,
          ),
        );

  // Log methods
  void debug(String message) => _logger.d(message);
  void info(String message) => _logger.i(message);
  void warning(String message) => _logger.w(message);
  void error(String message, [dynamic error, StackTrace? stackTrace]) => 
      _logger.e(message, error: error, stackTrace: stackTrace);
} 