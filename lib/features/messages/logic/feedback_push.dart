/// Reads the `FeedbackMessage` push payload (sent by the backend for a new guest feedback message):
/// `type`, `conversationId`, `messageId`, `guestName`, `eventTitle`, `eventId`, `guestId`.
/// All FCM data values are strings, hence the parsing.
class FeedbackPush {
  FeedbackPush._();

  static const String type = 'FeedbackMessage';

  static bool matches(Map<dynamic, dynamic> data) => data['type'] == type;

  static int? conversationId(Map<dynamic, dynamic> data) =>
      int.tryParse('${data['conversationId']}');

  /// Arguments for `Routes.chatScreen`, or null when the payload has no usable conversation id
  /// (the caller then falls back to the notifications screen instead of crashing).
  static Map<String, dynamic>? chatArguments(Map<dynamic, dynamic> data) {
    final id = conversationId(data);
    if (id == null) return null;
    return {
      'conversationId': id,
      'guestName': data['guestName']?.toString() ?? '',
      'eventTitle': data['eventTitle']?.toString() ?? '',
    };
  }
}
