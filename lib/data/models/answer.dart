class Answer{
  final String title;

  Answer({required this.title});

  factory Answer.fromJson(Map data){
    return Answer(
      title: data['title'],
    );
  }
}