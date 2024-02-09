class VideoData{
  final String title;
  final String description;
  final String video;
  final String? id;
  final String? category;
  final String? age;
  final String poster;

  VideoData({
    required this.description, 
    required this.title,
    required this.video,
    required this.category,
    required this.age,
    required this.poster,
    this.id
  });

  Map<String,String> toJson(){
    return {
      'description': description,
      'video': video,
      'title': title,
      'age': age ?? 'null',
      'category': category ?? 'null',
      'poster': poster
    };
  }
}