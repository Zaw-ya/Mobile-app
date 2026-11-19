import 'package:app/features/messages/data/models/message_models.dart';
import 'package:app/features/messages/data/repo/messages_repo.dart';
import 'package:app/features/messages/logic/chat_cubit.dart';
import 'package:app/features/messages/logic/feedback_push.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements MessagesRepo {
  final List<ChatMessage> server;
  final List<ReplyOutcome> outcomes;
  final List<String> sentClientIds = [];
  int markReadCalls = 0;

  _FakeRepo({this.server = const [], this.outcomes = const []});

  @override
  Future<ConversationDetail> getConversation(int id) async => ConversationDetail(
        conversationId: id,
        eventId: 1,
        eventTitle: 'Wedding',
        guestId: 5,
        guestName: 'Sara',
        messages: server,
      );

  @override
  Future<void> markRead(int id) async => markReadCalls++;

  @override
  Future<ReplyOutcome> sendReply(int id, String text, String clientMessageId) async {
    sentClientIds.add(clientMessageId);
    return outcomes[sentClientIds.length - 1];
  }

  @override
  Future<ConversationPage> getConversations({int page = 1}) => throw UnimplementedError();

  @override
  Future<int> getUnreadCount() async => 0;
}

ChatMessage _guestMsg() => ChatMessage(
      id: 1,
      clientMessageId: null,
      direction: ChatDirection.incoming,
      body: 'Great party',
      createdAt: DateTime(2026, 11, 1),
      status: ChatStatus.received,
    );

void main() {
  test('opening a conversation loads the history and marks it read', () async {
    final repo = _FakeRepo(server: [_guestMsg()]);
    final cubit = ChatCubit(repo, 7);
    await cubit.load();

    expect(cubit.state.status, ChatLoadStatus.ready);
    expect(cubit.state.messages.single.body, 'Great party');
    await Future<void>.delayed(Duration.zero);
    expect(repo.markReadCalls, 1);
    await cubit.close();
  });

  test('a reply shows as sending, then settles to the stored sent message', () async {
    final stored = ChatMessage(
      id: 2,
      clientMessageId: 'x',
      direction: ChatDirection.outgoing,
      body: 'Thanks!',
      createdAt: DateTime(2026, 11, 2),
      status: ChatStatus.sent,
    );
    final repo = _FakeRepo(server: [_guestMsg()], outcomes: [ReplyOutcome(success: true, reply: stored)]);
    final cubit = ChatCubit(repo, 7);
    await cubit.load();
    await cubit.send('  Thanks!  ');

    final out = cubit.state.messages.where((m) => m.isOutgoing).single;
    expect(out.status, ChatStatus.sent);
    expect(out.id, 2);
    await cubit.close();
  });

  test('a failed reply is kept as failed and the retry reuses the same client id', () async {
    final repo = _FakeRepo(outcomes: [
      const ReplyOutcome(success: false, code: MessageErrorCodes.network),
      ReplyOutcome(
        success: true,
        reply: ChatMessage(
          id: 3,
          clientMessageId: null,
          direction: ChatDirection.outgoing,
          body: 'Hello',
          createdAt: DateTime(2026, 11, 2),
          status: ChatStatus.sent,
        ),
      ),
    ]);
    final cubit = ChatCubit(repo, 7);
    await cubit.load();
    await cubit.send('Hello');

    final failed = cubit.state.messages.single;
    expect(failed.status, ChatStatus.failed);
    expect(failed.failureReason, MessageErrorCodes.network);

    await cubit.retry(failed);
    expect(repo.sentClientIds.length, 2);
    expect(repo.sentClientIds[0], repo.sentClientIds[1], reason: 'retry must not create a second message');
    expect(cubit.state.messages.single.status, ChatStatus.sent);
    await cubit.close();
  });

  test('an empty reply is never sent', () async {
    final repo = _FakeRepo();
    final cubit = ChatCubit(repo, 7);
    await cubit.load();
    await cubit.send('   ');
    expect(repo.sentClientIds, isEmpty);
    await cubit.close();
  });

  test('server timestamps without an offset are read as UTC', () {
    final t = parseServerUtc('2026-11-19T10:00:00');
    expect(t.toUtc().hour, 10);
    expect(parseServerUtc('2026-11-19T10:00:00Z').toUtc().hour, 10);
  });

  test('push payload: conversation id parsed from FCM string data; bad payload has no chat args', () {
    final data = {
      'type': 'FeedbackMessage',
      'conversationId': '42',
      'guestName': 'Sara',
      'eventTitle': 'Wedding',
    };
    expect(FeedbackPush.matches(data), isTrue);
    expect(FeedbackPush.chatArguments(data)!['conversationId'], 42);
    expect(FeedbackPush.chatArguments({'type': 'FeedbackMessage'}), isNull);
    expect(FeedbackPush.matches({'type': 'GuestConfirmed'}), isFalse);
  });
}
