class Category {
  final String name;
  final String id;

  Category({required this.name, required this.id});

  factory Category.fromJson(Map data) {
    return Category(
        // name: data['name'],
        // id: data['_id']
        name: data['name'] ?? '',
        id: data['_id'] ?? '');
  }
}
