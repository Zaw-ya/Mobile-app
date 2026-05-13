import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helpers/app_utilities.dart';
import '../../../core/services/notification_service.dart';
import '../data/models/notification_model.dart';
import '../data/repo/notifications_repo.dart';
import 'notifications_states.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  final NotificationsRepo _repo;

  NotificationsCubit(this._repo) : super(const NotificationsInitial());

  int _backendUnreadCount = 0;
  List<NotificationModel> _cachedNotifications = [];

  // ── Load all notifications ─────────────────────────────
  Future<void> loadNotifications() async {
    if (isClosed) return;
    emit(NotificationsLoading(
      unreadCount: state.unreadCount,
      notifications: _cachedNotifications,
    ));

    try {
      final token = AppUtilities().serverToken;

      
      final list = await _repo.fetchNotifications(token);
      _backendUnreadCount = await _repo.fetchUnreadCount(token);

      _cachedNotifications = list;
      final totalBadge = await _calculateBadgeCount();
      
      if (isClosed) return;
      emit(NotificationsSuccess(
        notifications: list,
        unreadCount: totalBadge,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(NotificationsError(
        e.toString(),
        unreadCount: state.unreadCount,
        notifications: _cachedNotifications,
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
  Future<int> _calculateBadgeCount() async {
    final localPending = await NotificationService().getPendingNotifications();
    return localPending.length + _backendUnreadCount;
  }

  // ── Badge update  
  Future<void> updateBadgeCountOnly() async {
    try {
      final token = AppUtilities().serverToken;
      _backendUnreadCount = await _repo.fetchUnreadCount(token);
      final totalBadge = await _calculateBadgeCount();

      if (isClosed) return;
      if (state is NotificationsSuccess) {
        emit(NotificationsSuccess(
          notifications: state.notifications,
          unreadCount: totalBadge,
        ));
      } else {
        emit(NotificationsSuccess(
          notifications: _cachedNotifications,
          unreadCount: totalBadge,
        ));
      }
    } catch (_) {}
  }
}

