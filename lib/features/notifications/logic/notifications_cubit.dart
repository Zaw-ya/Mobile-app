import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/features/notifications/data/models/notification_model.dart';
import 'package:app/features/notifications/data/repo/notifications_repo.dart';
import 'package:app/features/notifications/logic/notifications_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  final NotificationsRepo _repo;

  NotificationsCubit(this._repo) : super(const NotificationsInitial());

  int _backendUnreadCount = 0;
  List<NotificationModel> _cachedNotifications = [];

  // ── Initial load / Refresh ─────────────────────────────
  Future<void> loadNotifications() async {
    if (isClosed) return;
    emit(NotificationsLoading(
      unreadCount: state.unreadCount,
      notifications: _cachedNotifications,
    ));

    try {
      final token = AppUtilities().serverToken;

      final response = await _repo.fetchNotifications(token, page: 1);

      _backendUnreadCount = await _repo.fetchUnreadCount(token);

      _cachedNotifications = response.items;
      // final totalBadge = await _calculateBadgeCount();

      if (isClosed) return;
      emit(NotificationsSuccess(
        notifications: response.items,
        unreadCount: _backendUnreadCount,
        hasMore: response.hasMore,
        currentPage: 1,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(NotificationsError(
        e.toString(),
        unreadCount: state.unreadCount,
        notifications: _cachedNotifications,
        hasMore: state.hasMore,
        currentPage: state.currentPage,
      ));
    }
  }

  // ── Load next page ─────────────────────────────────────
  Future<void> loadMore() async {
    if (isClosed) return;
    if (!state.hasMore) return;
    if (state is NotificationsLoadingMore) return;

    emit(NotificationsLoadingMore(
      notifications: _cachedNotifications,
      unreadCount: state.unreadCount,
      hasMore: state.hasMore,
      currentPage: state.currentPage,
    ));

    try {
      final token = AppUtilities().serverToken;
      final nextPage = state.currentPage + 1;
      final response = await _repo.fetchNotifications(token, page: nextPage);

      _cachedNotifications = [..._cachedNotifications, ...response.items];

      if (isClosed) return;
      emit(NotificationsSuccess(
        notifications: _cachedNotifications,
        unreadCount: state.unreadCount,
        hasMore: response.hasMore,
        currentPage: nextPage,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(NotificationsError(
        e.toString(),
        unreadCount: state.unreadCount,
        notifications: _cachedNotifications,
        hasMore: state.hasMore,
        currentPage: state.currentPage,
      ));
    }
  }

  // ── Mark as read ───────────────────────────────────────
  Future<void> markRead(String id) async {
    try {
      final token = AppUtilities().serverToken;
      await _repo.markAsRead(token, id);
      await loadNotifications();

    } catch (e) {
      // can emit error state if you need
    }

  }

  // ── Badge calculation ──────────────────────────────────
  //>> We don't calculate Local Notifications >>

  // Future<int> _calculateBadgeCount() async {
  //   final localPending = await NotificationService().getPendingNotifications();
  //   return localPending.length + _backendUnreadCount;
  // }


  // ── Badge update  

  Future<void> updateBadgeCountOnly() async {
    try {
      final token = AppUtilities().serverToken;
      _backendUnreadCount = await _repo.fetchUnreadCount(token);
      // final totalBadge = await _calculateBadgeCount();

      if (isClosed) return;

      emit(NotificationsSuccess(
        notifications: _cachedNotifications,
        unreadCount: state.unreadCount,
        hasMore: state.hasMore,
        currentPage: state.currentPage,
      ));
    } catch (_) {}
  }
}

