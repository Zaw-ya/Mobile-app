import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_service.dart';
import '../models/message_models.dart';

/// Stable codes of the client messages API (`{code, message}`), plus [network] when no answer came back.
class MessageErrorCodes {
  MessageErrorCodes._();

  static const String conversationNotFound = 'ConversationNotFound';
  static const String templateNotConfigured = 'TemplateNotConfigured';
  static const String sendFailed = 'SendFailed';
  static const String invalidInput = 'InvalidInput';
  static const String serverError = 'ServerError';
  static const String network = 'NETWORK';
  static const String unknown = 'UNKNOWN';
}

/// Outcome of sending a reply. [reply] is the stored message even when the send failed
/// (status Failed), so the chat can show it with a retry.
class ReplyOutcome {
  final bool success;
  final String? code;
  final String? message;
  final ChatMessage? reply;

  const ReplyOutcome({required this.success, this.code, this.message, this.reply});
}

class MessagesRepo {
  final ApiService _api;

  MessagesRepo(this._api);

  String get _token => AppUtilities().serverToken;

  Future<ConversationPage> getConversations({int page = 1}) async {
    final raw = await _api.getMessageConversations(_token, page);
    return ConversationPage.fromJson(raw as Map<String, dynamic>);
  }

  Future<ConversationDetail> getConversation(int conversationId) async {
    final raw = await _api.getMessageConversation(_token, conversationId);
    return ConversationDetail.fromJson(raw as Map<String, dynamic>);
  }

  Future<void> markRead(int conversationId) async {
    await _api.markMessageConversationRead(_token, conversationId);
  }

  Future<int> getUnreadCount() async {
    try {
      final raw = await _api.getMessagesUnreadCount(_token);
      if (raw is Map) return (raw['count'] as num?)?.toInt() ?? 0;
    } catch (e) {
      debugPrint('Messages unread count failed: $e');
    }
    return 0;
  }

  /// Never throws: a failure is described by [ReplyOutcome].
  Future<ReplyOutcome> sendReply(
      int conversationId, String text, String clientMessageId) async {
    try {
      final raw = await _api.replyToMessageConversation(
        _token,
        conversationId,
        {'text': text, 'clientMessageId': clientMessageId},
      );
      return ReplyOutcome(success: true, reply: _replyOf(raw));
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map) {
        return ReplyOutcome(
          success: false,
          code: data['code']?.toString() ?? MessageErrorCodes.unknown,
          message: data['message']?.toString(),
          reply: _replyOf(data),
        );
      }
      return ReplyOutcome(
        success: false,
        code: e.response == null
            ? MessageErrorCodes.network
            : MessageErrorCodes.serverError,
      );
    } catch (e) {
      debugPrint('Send reply failed: $e');
      return const ReplyOutcome(success: false, code: MessageErrorCodes.unknown);
    }
  }

  ChatMessage? _replyOf(dynamic raw) {
    if (raw is Map && raw['reply'] is Map) {
      return ChatMessage.fromJson(Map<String, dynamic>.from(raw['reply'] as Map));
    }
    return null;
  }

  /// True when [e] means the conversation no longer exists (404).
  static bool isNotFound(Object e) =>
      e is DioException && e.response?.statusCode == 404;
}
