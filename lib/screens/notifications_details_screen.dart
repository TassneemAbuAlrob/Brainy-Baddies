// notification_details_screen.dart
import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final NotificationModel notification;

  NotificationDetailsScreen({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              notification.content,
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${notification.isRead ? 'Read' : 'Unread'}',
                  style: TextStyle(fontSize: 16, color: notification.isRead ? Colors.green : Colors.red),
                ),
                if (!notification.isRead)
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality to mark the notification as read
                    },
                    child: Text('Mark as Read'),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Received on: ${notification.timestamp.toLocal()}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
