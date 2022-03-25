import 'package:cloud_firestore/cloud_firestore.dart';

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
  factory Lecturer.fromSnap(DocumentSnapshot snapshot){
    return Lecturer(
        id: snapshot['id'],
        lectures: snapshot['lectures'],
        email: snapshot['email'],
        username: snapshot['username']??'',
        name: snapshot['name']??''
    );
  }
}