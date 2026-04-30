import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helpers/app_utilities.dart';
import '../../../core/services/notification_service.dart';
import '../data/models/notification_model.dart';
import '../data/repo/notifications_repo.dart';
import 'notifications_states.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  final NotificationsRepo _repo;
  NotificationsCubit(this._repo) : super(NotificationsInitial());

  int backendUnreadCount = 0;
  List<NotificationModel> backendNotifications = [];

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());
    try {
      final token = AppUtilities().serverToken;
      final list = await _repo.fetchNotifications(token);
      backendNotifications = list;
      backendUnreadCount = await _repo.fetchUnreadCount(token);

      // get local scheduled notifications (count is computed on demand)
      emit(NotificationsSuccess(list));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> markRead(String id) async {
    try {
      final token = AppUtilities().serverToken;
      await _repo.markAsRead(token, id);
      // refresh
      // refresh backend notifications and unread count
      await loadNotifications();
    } catch (e) {
      // ignore for now
    }
  }

  Future<int> combinedBadgeCount() async {
    // local pending
    final localPending = await NotificationService().getPendingNotifications();
    final localCount = localPending.length;
    // backend unread count (cached)
    return localCount + backendUnreadCount;
  }
}
