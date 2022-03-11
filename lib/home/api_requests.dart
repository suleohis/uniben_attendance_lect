import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniben_attendance_lect/models/Lecture.dart';
import 'package:uniben_attendance_lect/models/course.dart';
import 'package:http/http.dart' as http;
import 'package:uniben_attendance_lect/models/student.dart';

Future<List<Course>> fetchCourses() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String token = pref.getString('token');

  http.Client client = http.Client();
  try{
    http.Response response = await client.post(
        Uri.https('serene-harbor-85025.herokuapp.com', '/lecturers/courses'),
        body: json.encode({
          "token": token
        }),
        headers: {
          'Content-Type': 'application/json'
        }
    );
    dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //print(decodedResponse);

    List<Course> courses = [];
    if(decodedResponse['status'] == 'ok'){
      decodedResponse['courses'].forEach((course) {
        courses.add(Course.fromJson(course));
      });
      return courses;
    }else{
      print(decodedResponse['msg']);
      return null;
    }

  }catch(e){
    print(e);
  }
}

// function to fetch the code from db
fetchCode(setStateCallback, selectedCourse, duration, context, session, semester) async {
  setStateCallback();
  // handle error checks
  SharedPreferences pref = await SharedPreferences.getInstance();
  String token = pref.getString('token');

  http.Client client = http.Client();
  try{
    http.Response response = await client.post(
        Uri.https('serene-harbor-85025.herokuapp.com', '/lecturers/generatelecture'),
        body: json.encode({
          "token": token,
          "course_id": selectedCourse.courseId,
          "duration": duration,
          "course_name": selectedCourse.title,
          "course_code": selectedCourse.courseCode,
          "session": session,
          "semester": semester
        }),
        headers: {
          'Content-Type': 'application/json'
        }
    );
    dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(decodedResponse['status'] == 'ok'){
      Navigator.of(context).pop({
        'lectureToken': decodedResponse['lectureToken'],
        'duration': duration
      });
    }else{
      print(decodedResponse['msg']);
    }
    //print(decodedResponse);
  }catch(e){
    print(e);
  }
}

Future<List<Lecture>> fetchLectures(session, semester) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String token = pref.getString('token');

  http.Client client = http.Client();
  try{
    http.Response response = await client.post(
        Uri.https('serene-harbor-85025.herokuapp.com', '/lecturers/getlectures'),
        body: json.encode({
          "token": token,
          "semester": semester,
          "session": session
        }),
        headers: {
          'Content-Type': 'application/json'
        }
    );
    dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //print(decodedResponse);

    List<Lecture> lectures = [];
    if(decodedResponse['status'] == 'ok'){
      decodedResponse['lectures'].forEach((lecture) {
        lectures.add(Lecture.fromJson(lecture));
      });
      return lectures;
    }else{
      print(decodedResponse['msg']);
      return null;
    }

  }catch(e){
    print(e);
  }
}

//async function to get an individual student's data
fetchStudent(studentId) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String token = pref.getString('token');

  http.Client client = http.Client();
  try{
    http.Response response = await client.post(
        Uri.https('serene-harbor-85025.herokuapp.com', '/lecturers/getstudent'),
      body: json.encode({
        "token": token,
        "student_id": studentId
      }),
      headers: {
          'Content-Type': 'application/json'
      }
    );
    dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(decodedResponse['status'] == 'ok'){
        Student student = Student.fromJson(decodedResponse['student']);
        return student;
    }else{
      print(decodedResponse['msg']);
    }
  }catch(e){
    print(e);
  }

}
