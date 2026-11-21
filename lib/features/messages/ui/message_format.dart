import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/widgets.dart';

import '../data/models/message_models.dart';
import '../data/repo/messages_repo.dart';

/// Short time for chat bubbles / list rows: "14:05" today, "03/11 14:05" otherwise.
String formatMessageTime(DateTime t) {
  String two(int n) => n.toString().padLeft(2, '0');
  final now = DateTime.now();
  final time = '${two(t.hour)}:${two(t.minute)}';
  if (t.year == now.year && t.month == now.month && t.day == now.day) return time;
  return '${two(t.day)}/${two(t.month)} $time';
}

/// A guest may write in Arabic while the app is in English (or the reverse): lay each message out by its own script.
TextDirection directionOf(String text) {
  for (final unit in text.runes) {
    if ((unit >= 0x0600 && unit <= 0x06FF) ||
        (unit >= 0x0750 && unit <= 0x077F) ||
        (unit >= 0xFB50 && unit <= 0xFDFF) ||
        (unit >= 0xFE70 && unit <= 0xFEFF)) {
      return TextDirection.rtl;
    }
    if ((unit >= 0x41 && unit <= 0x5A) || (unit >= 0x61 && unit <= 0x7A)) {
      return TextDirection.ltr;
    }
  }
  return TextDirection.ltr;
}

/// Localised text for a failed reply. [reason] is a code for failures known on this device,
/// or the server's text for messages loaded from the server.
String failureText(String? reason) {
  if (reason == MessageErrorCodes.templateNotConfigured ||
      (reason != null && reason.contains('template is not configured'))) {
    return 'messages_template_not_configured'.tr();
  }
  if (reason == MessageErrorCodes.network) return 'messages_network_error'.tr();
  return 'messages_send_failed'.tr();
}

String initialOf(String name) {
  final trimmed = name.trim();
  return trimmed.isEmpty ? '?' : String.fromCharCode(trimmed.runes.first).toUpperCase();
}

bool isFailed(ChatMessage m) => m.status == ChatStatus.failed;
