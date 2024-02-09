class Age{
  final String name;
  final int from;
  final int to;
  final String? id;

  Age({required this.name, required this.from, required this.to, this.id});

  factory Age.fromJson(Map data){
    return Age(
      name: data['name'],
      from: data['from'],
      to: data['to'],
      id: data['_id']
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