class StoryData{
  final String pdf;
  final String title;
  final String image;
  final String category;
  final String age;
  final String? id;

  StoryData({
    required this.pdf, 
    required this.title, 
    required this.image,
    required this.category,
    required this.age,
    this.id
  });

  Map<String,String> toJson(){
    return {
      'pdf': pdf,
      'title': title,
      'image': image,
      'category': category,
      'age': age
    };
  }
}