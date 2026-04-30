class NotificationModel {
  final String id;
  final int userId;
  final String title;
  final String body;
  final String type;
  final bool read;
  final String? referenceId;
  final DateTime? createdAt;
  final String? route;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.read,
    this.referenceId,
    this.createdAt,
    this.route,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      read: json['isRead'] == true || json['read'] == true,
      referenceId: json['referenceId']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      route: json['route'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'isRead': read,
      'referenceId': referenceId,
      'createdAt': createdAt?.toIso8601String(),
      'route': route,
    };
  }
}