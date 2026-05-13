import '../data/models/notification_model.dart';

abstract class NotificationsStates {
  final int unreadCount;
  final List<NotificationModel> notifications;
  final bool hasMore;
  final int currentPage;

  const NotificationsStates({
    this.unreadCount = 0,
    this.notifications = const [],
    this.hasMore = false,
    this.currentPage = 1,
  });
}

class NotificationsInitial extends NotificationsStates {
  const NotificationsInitial() : super();
}

class NotificationsLoading extends NotificationsStates {
  const NotificationsLoading({
    super.unreadCount,
    super.notifications,
    super.hasMore,
    super.currentPage,
  });
}

class NotificationsLoadingMore extends NotificationsStates {
  const NotificationsLoadingMore({
    required super.notifications,
    required super.unreadCount,
    required super.hasMore,
    required super.currentPage,
  });
}

class NotificationsSuccess extends NotificationsStates {
  const NotificationsSuccess({
    required super.notifications,
    required super.unreadCount,
    required super.hasMore,
    required super.currentPage,
  });
}

class NotificationsError extends NotificationsStates {
  final String message;
  const NotificationsError(
    this.message, {
    super.unreadCount,
    super.notifications,
    super.hasMore,
    super.currentPage,
  });
}