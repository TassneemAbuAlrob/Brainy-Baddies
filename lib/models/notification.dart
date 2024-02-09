class NotificationModel {
  final int id;
  final String title;
  final String content;
  final DateTime timestamp;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });
}
