class StoryData{
  final String pdf;
  final String title;
  final String image;
  String? category;
  String? age;
  final String? id;

  StoryData({
    required this.pdf, 
    required this.title, 
    required this.image,
    this.category,
     this.age,
    this.id
  });

  Map<String,String> toJson(){
    return {
      'pdf': pdf,
      'title': title,
      'image': image,
      'category': category ?? 'null',
      'age': age ?? 'null'
    };
  }
}