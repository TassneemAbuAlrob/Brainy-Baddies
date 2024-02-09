import 'package:flutter/material.dart';
import 'package:log/core/constants/colors.dart';
import 'package:log/data/models/notification_model.dart';
import 'package:log/presentation/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class NotificationsList extends StatefulWidget {
  const NotificationsList({super.key});

  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  Widget _buildNotification(
      {required String title,
      required String message,
      required IconData icon,
      required String time}) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 48.0, color: secondaryColor),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Text(message),
                  SizedBox(height: 8.0),
                  Text(time,
                      style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  void initializeNotifications() async {
    await context.read<NotificationProvider>().getAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 152, 150, 150),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: Consumer<NotificationProvider>(
            builder: (BuildContext context,
                NotificationProvider notificationProvider, Widget? child) {
              if (notificationProvider.errorState) {
                return Center(
                  child: Text(notificationProvider.errorMessage),
                );
              }

              List<NotificationModel> notifications =
                  notificationProvider.notifications;

              if (notifications.isEmpty) {
                return Center(
                  child: Text('No Notifications'),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  NotificationModel notification = notifications[index];

                  return _buildNotification(
                    title: notification.title,
                    message: notification.body,
                    icon: Icons.notification_important,
                    time: notification.date,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
