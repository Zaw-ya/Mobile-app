import 'package:flutter/foundation.dart';

/// Service for application logging
class LoggerService {
  /// Log an informational message
  void info(String message) {
    if (kDebugMode) {
      print('INFO: $message');
    }
    // In a real implementation, you might want to send logs to a remote service
  }

  /// Log a warning message
  void warning(String message) {
    if (kDebugMode) {
      print('WARNING: $message');
    }
  }

  /// Log an error message with optional exception
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('ERROR: $message');
      if (error != null) {
        print('Exception: $error');
      }
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }
  }

  /// Log for analytics purposes
  void analytics(String event, Map<String, dynamic> parameters) {
    if (kDebugMode) {
      print('ANALYTICS EVENT: $event');
      print('PARAMETERS: $parameters');
    }
  }
}
