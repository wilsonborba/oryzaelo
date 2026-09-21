import 'package:flutter/foundation.dart';
import 'package:farmer_app/core/settings.dart';

/// Centralized logger following all_structure_project.md specifications.
void logDebug(String message, [Object? error, StackTrace? stackTrace]) {
  if (AppSettings.isDevelopment) {
    debugPrint('[DEBUG] $message');
    if (error != null) debugPrint('Error: $error');
    if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
  }
}

void logInfo(String message) {
  debugPrint('[INFO] $message');
}

void logWarning(String message, [Object? error]) {
  debugPrint('[WARN] $message');
  if (error != null) debugPrint('Error: $error');
}

void logError(String message, [Object? error, StackTrace? stackTrace]) {
  debugPrint('[ERROR] $message');
  if (error != null) debugPrint('Error: $error');
  if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
}
