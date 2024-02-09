class VideoData{
  final String title;
  final String description;
  final String video;
  final String? id;
  final String category;
  final String age;

  VideoData({
    required this.description, 
    required this.title,
    required this.video,
    required this.category,
    required this.age,
    this.id
  });

  Map<String,String> toJson(){
    return {
      'description': description,
      'video': video,
      'title': title,
      'age': age,
      'category': category
    };
  }
}