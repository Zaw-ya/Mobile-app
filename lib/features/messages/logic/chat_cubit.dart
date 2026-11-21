import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/dependency_injection.dart';
import '../data/models/message_models.dart';
import '../data/repo/messages_repo.dart';
import 'messages_cubit.dart';
import 'messages_events.dart';

enum ChatLoadStatus { loading, ready, error, notFound }

class ChatState {
  final ChatLoadStatus status;
  final List<ChatMessage> messages;

  const ChatState({this.status = ChatLoadStatus.loading, this.messages = const []});

  ChatState copyWith({ChatLoadStatus? status, List<ChatMessage>? messages}) =>
      ChatState(
        status: status ?? this.status,
        messages: messages ?? this.messages,
      );
}

/// One open conversation. Reading is automatic on open; replying is optional.
class ChatCubit extends Cubit<ChatState> {
  final MessagesRepo _repo;
  final int conversationId;
  StreamSubscription<int?>? _pushSub;
  final _random = Random();

  ChatCubit(this._repo, this.conversationId) : super(const ChatState()) {
    MessagesEvents.openConversationId = conversationId;
    _pushSub = MessagesEvents.newMessage.listen((id) {
      if (id == null || id == conversationId) refresh();
    });
  }

  Future<void> load() async {
    emit(state.copyWith(status: ChatLoadStatus.loading));
    await _fetch(initial: true);
  }

  /// Quiet reload (new push while open, app resumed): keeps local not-yet-confirmed replies.
  Future<void> refresh() => _fetch(initial: false);

  Future<void> _fetch({required bool initial}) async {
    try {
      final detail = await _repo.getConversation(conversationId);
      if (isClosed) return;

      // Replies still sending / failed only on this device must not vanish on a refresh.
      final serverIds = detail.messages.map((m) => m.clientMessageId).whereType<String>().toSet();
      final localOnly = state.messages
          .where((m) => m.id == null && m.clientMessageId != null && !serverIds.contains(m.clientMessageId))
          .toList();

      emit(ChatState(
        status: ChatLoadStatus.ready,
        messages: [...detail.messages, ...localOnly],
      ));
      unawaited(_markRead());
    } catch (e) {
      debugPrint('Chat load failed: $e');
      if (isClosed) return;
      if (MessagesRepo.isNotFound(e)) {
        emit(state.copyWith(status: ChatLoadStatus.notFound));
      } else if (initial || state.messages.isEmpty) {
        emit(state.copyWith(status: ChatLoadStatus.error));
      }
    }
  }

  Future<void> _markRead() async {
    try {
      await _repo.markRead(conversationId);
      if (getIt.isRegistered<MessagesCubit>()) {
        getIt<MessagesCubit>().onConversationRead(conversationId);
      }
    } catch (e) {
      debugPrint('Mark read failed: $e');
    }
  }

  String _newClientMessageId() =>
      '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}${_random.nextInt(1 << 30).toRadixString(36)}';

  /// Optimistic send: the reply shows at once as "sending" and settles to sent / failed.
  Future<void> send(String rawText) async {
    final text = rawText.trim();
    if (text.isEmpty) return;

    final local = ChatMessage(
      id: null,
      clientMessageId: _newClientMessageId(),
      direction: ChatDirection.outgoing,
      body: text,
      createdAt: DateTime.now(),
      status: ChatStatus.sending,
    );
    emit(state.copyWith(messages: [...state.messages, local]));
    await _deliver(local);
  }

  /// Same clientMessageId, so the server retries that message instead of creating a second one.
  Future<void> retry(ChatMessage failed) async {
    if (failed.clientMessageId == null) return;
    _replace(failed.clientMessageId!,
        (m) => m.copyWith(status: ChatStatus.sending, clearFailure: true));
    await _deliver(failed);
  }

  Future<void> _deliver(ChatMessage message) async {
    final cid = message.clientMessageId!;
    final outcome = await _repo.sendReply(conversationId, message.body, cid);
    if (isClosed) return;

    if (outcome.success) {
      final reply = outcome.reply;
      _replace(cid, (m) => reply ?? m.copyWith(status: ChatStatus.sent));
      unawaited(_touchList());
    } else {
      _replace(cid, (m) {
        final stored = outcome.reply;
        final reason = outcome.code == MessageErrorCodes.templateNotConfigured
            ? MessageErrorCodes.templateNotConfigured
            : outcome.code == MessageErrorCodes.network
                ? MessageErrorCodes.network
                : (stored?.failureReason ?? outcome.message);
        return (stored ?? m).copyWith(status: ChatStatus.failed, failureReason: reason);
      });
    }
  }

  void _replace(String clientMessageId, ChatMessage Function(ChatMessage) change) {
    emit(state.copyWith(messages: [
      for (final m in state.messages)
        m.clientMessageId == clientMessageId ? change(m) : m
    ]));
  }

  Future<void> _touchList() async {
    if (getIt.isRegistered<MessagesCubit>()) {
      await getIt<MessagesCubit>().load(silent: true);
    }
  }

  @override
  Future<void> close() {
    if (MessagesEvents.openConversationId == conversationId) {
      MessagesEvents.openConversationId = null;
    }
    _pushSub?.cancel();
    return super.close();
  }
}
