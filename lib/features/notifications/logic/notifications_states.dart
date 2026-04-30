import '../../notifications/data/models/notification_model.dart';

abstract class NotificationsStates {
  const NotificationsStates();
}

class NotificationsInitial extends NotificationsStates {}

class NotificationsLoading extends NotificationsStates {}

class NotificationsSuccess extends NotificationsStates {
  final List<NotificationModel> notifications;
  const NotificationsSuccess(this.notifications);
}

class NotificationsError extends NotificationsStates {
  final String message;
  const NotificationsError(this.message);
}
