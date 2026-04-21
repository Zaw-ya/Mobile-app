import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class LoggingServicePrinter {
  static void log(String message, [String? tag = "MyApp-Log"]) {
    if (kDebugMode) {
      developer.log("[$tag] $message", time: DateTime.now());
    }
  }

  static void error(String message, [String? tag = "MyApp-Error"]) {
    if (kDebugMode) {
      developer.log(
        "[$tag] $message",
        time: DateTime.now(),
        level: 1000, // Higher level for errors
      );
    }
  }

  static void info(String message, [String? tag = "MyApp-Info"]) {
    if (kDebugMode) {
      developer.log(
        "[$tag] $message",
        time: DateTime.now(),
        level: 800, // Higher level for info
      );
    }
  }

  static void warn(String message, [String? tag = "MyApp-Warning"]) {
    if (kDebugMode) {
      developer.log(
        "[$tag] $message",
        time: DateTime.now(),
        level: 900, // Higher level for warnings
      );
    }
  }
}
