import 'package:app/features/notifications/data/models/notifications_response.dart';

import '../../../../core/networking/api_service.dart';
import '../../../../core/di/dependency_injection.dart';

class NotificationsRepo {
  final ApiService _apiService = getIt<ApiService>();

  NotificationsRepo();

  Future<NotificationsResponse> fetchNotifications(String token, {int page = 1}) async {
    final raw = await _apiService.getNotifications(token, page);
    return NotificationsResponse.fromJson(raw as Map<String, dynamic>);
  }

  Future<void> markAsRead(String token, String notificationId) async {
    await _apiService.markNotificationRead(token, notificationId);
  }

  Future<int> fetchUnreadCount(String token) async {
  try {
    final raw = await _apiService.getUnreadNotificationsCount(token);
    if (raw is Map) {
      return (raw['count'] as num?)?.toInt() ?? 0;
    }
    return 0;
  } catch (_) {
    return 0;
  }
}
}
