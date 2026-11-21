/// A feedback conversation of ONE guest of ONE event (never keyed by phone number).
class ConversationItem {
  final int conversationId;
  final int eventId;
  final String eventTitle;
  final int guestId;
  final String guestName;
  final String? lastMessagePreview;
  final DateTime lastMessageAt;
  final int unreadCount;

  const ConversationItem({
    required this.conversationId,
    required this.eventId,
    required this.eventTitle,
    required this.guestId,
    required this.guestName,
    required this.lastMessagePreview,
    required this.lastMessageAt,
    required this.unreadCount,
  });

  factory ConversationItem.fromJson(Map<String, dynamic> json) =>
      ConversationItem(
        conversationId: (json['conversationId'] as num).toInt(),
        eventId: (json['eventId'] as num?)?.toInt() ?? 0,
        eventTitle: json['eventTitle']?.toString() ?? '',
        guestId: (json['guestId'] as num?)?.toInt() ?? 0,
        guestName: json['guestName']?.toString() ?? '',
        lastMessagePreview: json['lastMessagePreview']?.toString(),
        lastMessageAt: parseServerUtc(json['lastMessageAt']),
        unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      );

  ConversationItem copyWith({int? unreadCount}) => ConversationItem(
        conversationId: conversationId,
        eventId: eventId,
        eventTitle: eventTitle,
        guestId: guestId,
        guestName: guestName,
        lastMessagePreview: lastMessagePreview,
        lastMessageAt: lastMessageAt,
        unreadCount: unreadCount ?? this.unreadCount,
      );
}

class ConversationPage {
  final List<ConversationItem> items;
  final bool hasMore;
  final int page;

  const ConversationPage(
      {required this.items, required this.hasMore, required this.page});

  factory ConversationPage.fromJson(Map<String, dynamic> json) =>
      ConversationPage(
        items: (json['items'] as List? ?? const [])
            .map((e) => ConversationItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        hasMore: json['hasMore'] == true,
        page: (json['page'] as num?)?.toInt() ?? 1,
      );
}

enum ChatDirection { incoming, outgoing }

enum ChatStatus { received, sending, sent, failed }

class ChatMessage {
  /// Server id; null while an outgoing reply exists only on this device.
  final int? id;

  /// Client-generated id of an outgoing reply (idempotent retries) / null for guest messages.
  final String? clientMessageId;
  final ChatDirection direction;
  final String body;
  final DateTime createdAt;
  final ChatStatus status;
  final String? failureReason;

  const ChatMessage({
    required this.id,
    required this.clientMessageId,
    required this.direction,
    required this.body,
    required this.createdAt,
    required this.status,
    this.failureReason,
  });

  bool get isOutgoing => direction == ChatDirection.outgoing;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: (json['id'] as num?)?.toInt(),
        clientMessageId: json['clientMessageId']?.toString(),
        direction: json['direction'] == 'Outgoing'
            ? ChatDirection.outgoing
            : ChatDirection.incoming,
        body: json['body']?.toString() ?? '',
        createdAt: parseServerUtc(json['createdAt']),
        status: _statusOf(json['status']?.toString()),
        failureReason: json['failureReason']?.toString(),
      );

  ChatMessage copyWith({
    int? id,
    ChatStatus? status,
    String? failureReason,
    bool clearFailure = false,
  }) =>
      ChatMessage(
        id: id ?? this.id,
        clientMessageId: clientMessageId,
        direction: direction,
        body: body,
        createdAt: createdAt,
        status: status ?? this.status,
        failureReason: clearFailure ? null : (failureReason ?? this.failureReason),
      );

  static ChatStatus _statusOf(String? s) {
    switch (s) {
      case 'Sending':
        return ChatStatus.sending;
      case 'Sent':
        return ChatStatus.sent;
      case 'Failed':
        return ChatStatus.failed;
      default:
        return ChatStatus.received;
    }
  }
}

class ConversationDetail {
  final int conversationId;
  final int eventId;
  final String eventTitle;
  final int guestId;
  final String guestName;
  final List<ChatMessage> messages;

  const ConversationDetail({
    required this.conversationId,
    required this.eventId,
    required this.eventTitle,
    required this.guestId,
    required this.guestName,
    required this.messages,
  });

  factory ConversationDetail.fromJson(Map<String, dynamic> json) =>
      ConversationDetail(
        conversationId: (json['conversationId'] as num).toInt(),
        eventId: (json['eventId'] as num?)?.toInt() ?? 0,
        eventTitle: json['eventTitle']?.toString() ?? '',
        guestId: (json['guestId'] as num?)?.toInt() ?? 0,
        guestName: json['guestName']?.toString() ?? '',
        messages: (json['messages'] as List? ?? const [])
            .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// The server sends UTC without an offset marker on some paths; treat it as UTC, show it local.
DateTime parseServerUtc(dynamic value) {
  final raw = value?.toString();
  if (raw == null || raw.isEmpty) return DateTime.now();
  final hasZone = raw.endsWith('Z') || RegExp(r'[+-]\d{2}:\d{2}$').hasMatch(raw);
  final parsed = DateTime.tryParse(hasZone ? raw : '${raw}Z');
  return (parsed ?? DateTime.now()).toLocal();
}
