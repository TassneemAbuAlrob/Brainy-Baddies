class Answer{
  final String title;

  Answer({required this.title});

  factory Answer.fromJson(Map json){
    return Answer(
      title: json['title'],
    );
  }

  Map toJson(){
    return {
      'title': title
    };
  }
}