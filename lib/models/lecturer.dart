class Lecturer{
  final String id;
  final List lectures;
  final String email;
  final String username;
  final String name;

  Lecturer({this.id, this.lectures, this.email, this.username, this.name});

  factory Lecturer.fromJson(Map<String, dynamic> json){
    return Lecturer(
      id: json['_id'],
      lectures: json['lectures'],
      email: json['email'],
      username: json['username'],
      name: json['name']
    );
  }

}