class Message{
  final String sender;
  final String message;
  final String sendDate;

  Message({required this.sender, required this.message, required this.sendDate});

  factory Message.fromJson(Map json){
    return Message(
      sender: json["sender"],
      message: json["message"],
      sendDate: json["send_date"]
    );
  }

  Map<String,String> toJson(){
    return {
      'sender': sender,
      'message': message,
      'send_date': sendDate
    };
  }
}