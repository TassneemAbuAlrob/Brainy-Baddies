class NotificationData {
  final String title;
  final String body;
  final String type;

  NotificationData({required this.title, required this.body, required this.type});

  factory NotificationData.fromJson(Map data){
    return NotificationData(
      title: data['title'],
      body: data['body'],
      type: data['type']
    );
  }
}