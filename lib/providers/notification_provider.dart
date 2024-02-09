import 'package:alaa_admin/models/notification.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [
    NotificationModel(id: 1, title: 'New Message', content: 'You have a new message!', isRead: false, timestamp: DateTime.now()),
    NotificationModel(id: 2, title: 'Reminder', content: 'Don\'t forget your appointment.', isRead: true,timestamp: DateTime.now()),
    // Add more notifications as needed
  ];

  List<NotificationModel> get notifications => _notifications;

  void markAsRead(int notificationId) {
    final notificationIndex = _notifications.indexWhere((n) => n.id == notificationId);
    if (notificationIndex != -1) {
      _notifications[notificationIndex].isRead = true;
      notifyListeners();
    }
  }
}