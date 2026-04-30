import '../../../../core/networking/api_service.dart';
import '../../../../core/di/dependency_injection.dart';
import '../models/notification_model.dart';

class NotificationsRepo {
  final ApiService _apiService = getIt<ApiService>();

  NotificationsRepo();

  Future<List<NotificationModel>> fetchNotifications(String token) async {
    final raw = await _apiService.getNotifications(token);
    return raw;
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
