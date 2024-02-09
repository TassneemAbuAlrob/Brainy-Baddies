class Category{
  final String name;
  final String? id;

  Category({required this.name, this.id});

  factory Category.fromJson(Map json){
    return Category(
      name: json['name'],
      id: json['_id'],
    );
  }

  Map toJson(){
    return {
      'name': name
    };
  }
}