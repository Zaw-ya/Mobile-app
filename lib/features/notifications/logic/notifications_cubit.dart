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

      // جلب البيانات من الـ Repo
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
      // اختياري: يمكنك عمل emit لـ Error هنا إذا أردتِ
    }
  }

  // ── Badge calculation ──────────────────────────────────
  Future<int> _calculateBadgeCount() async {
    final localPending = await NotificationService().getPendingNotifications();
    return localPending.length + _backendUnreadCount;
  }

  // ── تحديث الـ Badge فقط (مثالي للـ initState) ──────────
  Future<void> updateBadgeCountOnly() async {
    try {
      final token = AppUtilities().serverToken;
      _backendUnreadCount = await _repo.fetchUnreadCount(token);
      final totalBadge = await _calculateBadgeCount();

      if (isClosed) return;
      // نقوم بعمل emit للحالة الحالية مع تحديث الرقم فقط
      if (state is NotificationsSuccess) {
        emit(NotificationsSuccess(
          notifications: state.notifications,
          unreadCount: totalBadge,
        ));
      } else {
        // إذا كان في حالة Loading أو Initial نحدث الرقم في الحالة العامة
        emit(NotificationsSuccess(
          notifications: _cachedNotifications,
          unreadCount: totalBadge,
        ));
      }
    } catch (_) {}
  }
}


// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../core/helpers/app_utilities.dart';
// import '../../../core/services/notification_service.dart';
// import '../data/models/notification_model.dart';
// import '../data/repo/notifications_repo.dart';
// import 'notifications_states.dart';

// class NotificationsCubit extends Cubit<NotificationsStates> {
//   final NotificationsRepo _repo;
//   NotificationsCubit(this._repo) : super(NotificationsInitial());

//   int backendUnreadCount = 0;
//   List<NotificationModel> backendNotifications = [];

//   Future<void> loadNotifications() async {
//     emit(NotificationsLoading());
//     try {
//       final token = AppUtilities().serverToken;
//       final list = await _repo.fetchNotifications(token);
//       backendNotifications = list;
//       backendUnreadCount = await _repo.fetchUnreadCount(token);

//       // get local scheduled notifications (count is computed on demand)
//       emit(NotificationsSuccess(list));
//     } catch (e) {
//       emit(NotificationsError(e.toString()));
//     }
//   }

//   Future<void> markRead(String id) async {
//     try {
//       final token = AppUtilities().serverToken;
//       await _repo.markAsRead(token, id);
//       // refresh
//       // refresh backend notifications and unread count
//       await loadNotifications();
//     } catch (e) {
//       // ignore for now
//     }
//   }

//   Future<int> combinedBadgeCount() async {
//     // local pending
//     final localPending = await NotificationService().getPendingNotifications();
//     final localCount = localPending.length;
//     // backend unread count (cached)
//     return localCount + backendUnreadCount;
//   }
// }
