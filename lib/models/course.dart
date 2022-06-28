
import 'package:cloud_firestore/cloud_firestore.dart';

class Course{

  final String? title;
  final String? courseCode;
  final String? creditLoad;
  final String? courseStatus;
  final String? courseId;

  Course({ this.title, this.courseCode, this.creditLoad, this.courseStatus, this.courseId});

  factory Course.fromJson(Map<String, dynamic> json){
    return Course(
      title: json['title'],
      courseCode: json['course_code'],
      creditLoad: json['credit_load'],
      courseStatus: json['course_status'],
      courseId: json['course_id']
    );

  }
  factory Course.fromSnap(DocumentSnapshot json){
    return Course(
        title: json['title'],
        courseCode: json['course_code'],
        creditLoad: json['credit_load'] ?? '',
        courseStatus: json['course_status'],
        courseId: json['course_id']
    );

  }

}