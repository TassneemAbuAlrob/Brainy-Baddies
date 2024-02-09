import 'package:log/core/helpers/sqfilte_helper.dart';
import 'package:log/data/entities/notification_data.dart';
import 'package:log/data/models/notification_model.dart';

class NotificationService{
  static Future<bool> storeNotification(NotificationData notification) async{
    try{
      int result = await DatabaseHelper.instance.insertData('notifications', {
        'title': notification.title,
        'body': notification.body,
        'type': notification.type,
        'date': DateTime.now().toLocal().toString()
      });

      return result > 0;
    }catch(error){
      rethrow;
    }
  }

  static Future<List<NotificationModel>> getAllNotifications() async{
    try{
      List decoded = await DatabaseHelper.instance.getAllData('notifications');
      List<NotificationModel> notifications = decoded.map((e){
        return NotificationModel.fromJson(e);
      }).toList();

      return notifications;
    }catch(error){
      rethrow;
    }
  }
}