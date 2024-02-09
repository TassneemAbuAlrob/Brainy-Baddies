class Age{
  final String name;
  final int from;
  final int to;
  final String? id;

  Age({required this.name, required this.from, required this.to, this.id});

  factory Age.fromJson(Map json){
    return Age(
      name: json['name'],
      from: json['from'],
      to: json['to'],
      id: json['_id']
    );
  }

  Map toJson(){
    return {
      'name': name,
      'from': from,
      'to': to
    };
  }
}