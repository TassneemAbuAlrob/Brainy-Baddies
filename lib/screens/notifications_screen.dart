// notification.dart
import 'package:alaa_admin/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import 'notifications_details_screen.dart';






class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          List<NotificationModel> notifications = notificationProvider.notifications;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              NotificationModel notification = notifications[index];
              return NotificationTile(notification: notification);
            },
          );
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              notification.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${notification.isRead ? 'Read' : 'Unread'}',
              style: TextStyle(fontSize: 12, color: notification.isRead ? Colors.green : Colors.red),
            ),
          ],
        ),
        onTap: () {
          // Add functionality to handle notification tap
          Provider.of<NotificationProvider>(context, listen: false).markAsRead(notification.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationDetailsScreen(notification: notification),
            ),
          );
        },
      ),
    );
  }
}
