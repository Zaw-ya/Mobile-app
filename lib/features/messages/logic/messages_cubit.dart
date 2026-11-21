import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/message_models.dart';
import '../data/repo/messages_repo.dart';
import 'messages_events.dart';

enum MessagesStatus { initial, loading, success, error }

class MessagesState {
  final MessagesStatus status;
  final List<ConversationItem> items;
  final int unreadTotal;
  final bool hasMore;
  final bool loadingMore;
  final int page;

  const MessagesState({
    this.status = MessagesStatus.initial,
    this.items = const [],
    this.unreadTotal = 0,
    this.hasMore = false,
    this.loadingMore = false,
    this.page = 1,
  });

  MessagesState copyWith({
    MessagesStatus? status,
    List<ConversationItem>? items,
    int? unreadTotal,
    bool? hasMore,
    bool? loadingMore,
    int? page,
  }) =>
      MessagesState(
        status: status ?? this.status,
        items: items ?? this.items,
        unreadTotal: unreadTotal ?? this.unreadTotal,
        hasMore: hasMore ?? this.hasMore,
        loadingMore: loadingMore ?? this.loadingMore,
        page: page ?? this.page,
      );
}

/// Conversations list + unread badge. A singleton (like NotificationsCubit) so the tab badge, the list
/// and the push handler share one state; reset on logout.
class MessagesCubit extends Cubit<MessagesState> {
  final MessagesRepo _repo;
  StreamSubscription<int?>? _pushSub;
  int _loadToken = 0;

  MessagesCubit(this._repo) : super(const MessagesState()) {
    _pushSub = MessagesEvents.newMessage.listen((_) => load(silent: true));
  }

  /// [silent] keeps the current list on screen while refreshing (pull-to-refresh, push, tab re-entry).
  Future<void> load({bool silent = false}) async {
    final token = ++_loadToken;
    if (!silent || state.status == MessagesStatus.initial) {
      emit(state.copyWith(status: MessagesStatus.loading));
    }
    try {
      final page = await _repo.getConversations(page: 1);
      final unread = await _repo.getUnreadCount();
      if (isClosed || token != _loadToken) return; // a newer load (or reset) won
      emit(MessagesState(
        status: MessagesStatus.success,
        items: page.items,
        unreadTotal: unread,
        hasMore: page.hasMore,
        page: 1,
      ));
    } catch (e) {
      debugPrint('Messages load failed: $e');
      if (isClosed || token != _loadToken) return;
      // A silent refresh must not wipe a list the user is already looking at.
      emit(state.copyWith(
        status: state.items.isNotEmpty && silent
            ? MessagesStatus.success
            : MessagesStatus.error,
      ));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.loadingMore || state.status != MessagesStatus.success) {
      return;
    }
    final token = _loadToken;
    emit(state.copyWith(loadingMore: true));
    try {
      final next = state.page + 1;
      final page = await _repo.getConversations(page: next);
      if (isClosed || token != _loadToken) return;
      final known = state.items.map((e) => e.conversationId).toSet();
      emit(state.copyWith(
        items: [
          ...state.items,
          ...page.items.where((e) => !known.contains(e.conversationId)),
        ],
        hasMore: page.hasMore,
        page: next,
        loadingMore: false,
      ));
    } catch (e) {
      debugPrint('Messages loadMore failed: $e');
      if (!isClosed && token == _loadToken) emit(state.copyWith(loadingMore: false));
    }
  }

  Future<void> refreshUnread() async {
    final unread = await _repo.getUnreadCount();
    if (!isClosed) emit(state.copyWith(unreadTotal: unread));
  }

  /// The chat opened [conversationId] and told the server it was read.
  void onConversationRead(int conversationId) {
    final items = [
      for (final c in state.items)
        c.conversationId == conversationId ? c.copyWith(unreadCount: 0) : c
    ];
    final removed = state.items
        .where((c) => c.conversationId == conversationId)
        .fold<int>(0, (sum, c) => sum + c.unreadCount);
    emit(state.copyWith(
      items: items,
      unreadTotal: (state.unreadTotal - removed).clamp(0, 1 << 30),
    ));
  }

  void reset() {
    _loadToken++;
    if (!isClosed) emit(const MessagesState());
  }

  @override
  Future<void> close() {
    _pushSub?.cancel();
    return super.close();
  }
}
