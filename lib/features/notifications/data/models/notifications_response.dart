import 'package:app/features/notifications/data/models/notification_model.dart';

class NotificationsResponse {
  final List<NotificationModel> items;
  final bool hasMore;
  final int page;

  NotificationsResponse({
    required this.items,
    required this.hasMore,
    required this.page,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      items: (json['items'] as List)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['hasMore'] as bool,
      page: json['page'] as int,
    );
  }
}