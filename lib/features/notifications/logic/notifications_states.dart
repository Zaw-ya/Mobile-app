import '../data/models/notification_model.dart';

abstract class NotificationsStates {
  final int unreadCount;
  final List<NotificationModel> notifications;

  const NotificationsStates({
    this.unreadCount = 0,
    this.notifications = const [],
  });
}

class NotificationsInitial extends NotificationsStates {
  const NotificationsInitial() : super();
}

class NotificationsLoading extends NotificationsStates {
  const NotificationsLoading({super.unreadCount, super.notifications});
}

class NotificationsSuccess extends NotificationsStates {
  const NotificationsSuccess({
    required super.notifications,
    required super.unreadCount,
  });
}

class NotificationsError extends NotificationsStates {
  final String message;
  const NotificationsError(this.message, {super.unreadCount, super.notifications});
}
