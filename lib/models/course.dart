import 'package:cloud_firestore/cloud_firestore.dart';

class Course{

  final String id;
  final String title;
  final String courseCode;
  final String creditLoad;
  final String lecturerName;
  final String courseId;

  Course({this.id, this.title, this.courseCode, this.creditLoad, this.lecturerName, this.courseId});

  factory Course.fromJson(Map<String, dynamic> json){
    return Course(
      id: json['id'],
      title: json['title'],
      courseCode: json['course_code'],
      creditLoad: json['credit_load'],
      lecturerName: json['lecturer_name'],
      courseId: json['course_id']
    );

  }
  factory Course.fromSnap(Map<String,dynamic> json){
    return Course(
        id: json['id'],
        title: json['title'],
        courseCode: json['course_code'],
        creditLoad: json['credit_load'],
        lecturerName: json['lecturer_name'],
        courseId: json['course_id']
    );

  }

}