class NotificationModel {
  final String title;
  final String body;
  final String date;
  final String type;

  NotificationModel({required this.title, required this.body, required this.date, required this.type});

  factory NotificationModel.fromJson(Map data){
    return NotificationModel(
      title: data['title'],
      body: data['body'],
      type: data['type'],
      date: data['date']
    );
  }
}