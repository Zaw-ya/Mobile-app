import 'dart:async';

/// A new guest message arrived (push received while the app is open, or a notification tap).
/// Lets an open Messages list / chat refresh itself without knowing about Firebase.
class MessagesEvents {
  MessagesEvents._();

  static final StreamController<int?> _controller =
      StreamController<int?>.broadcast();

  /// Emits the conversation id of the new message (null when unknown).
  static Stream<int?> get newMessage => _controller.stream;

  static void notifyNewMessage(int? conversationId) {
    if (!_controller.isClosed) _controller.add(conversationId);
  }

  /// Conversation currently open on screen; the foreground banner is skipped for it.
  static int? openConversationId;
}
