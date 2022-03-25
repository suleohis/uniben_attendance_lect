import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniben_attendance_lect/models/course.dart';
import 'package:uuid/uuid.dart';
import 'api_requests.dart';

class GenerateCode extends StatefulWidget {
  @override
  _GenerateCodeState createState() => _GenerateCodeState();
}

class _GenerateCodeState extends State<GenerateCode> {
  List<Course> futureCourses;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // futureCourses = fetchCourses();
    fetch();
  }

  Course selectedCourse;
  String duration = '1';
  String semester = '1';
  String session = '2020/2021';
  bool isLoading = false;
  List<Map<String,dynamic>> generateLecture = [];
  fetch() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    setState(() {
      isLoading  = true;

    });
    print('here');
    FirebaseFirestore.instance
        .collection('lecturers')
        .doc(auth.currentUser.uid)
        .get().then((DocumentSnapshot value) {
          print(value);

          List va = value['generateLecture'];
          va.forEach((element) {
            generateLecture.add ({
              "course_id": element['course_id'],
              "duration": element['duration'],
              "course_name": element['course_name'],
              "course_code": element['course_code'],
              'generatedUI': element['generatedUI'],
              "session": element['session'],
              "semester": element['semester'],
              'attendees':element['attendees'],
              'createdAt':element['createdAt'],
              'lecturerId':element['lecturerId']
            });
          });
          print(generateLecture);
          Course course = Course.fromSnap(value['courses'][0]);
          futureCourses = [course];
          setState(() {
            isLoading = false;
          });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Create Lecture'),
          leading: BackButton(
            onPressed: isLoading
                ? null
                : () {
                    Navigator.of(context).pop();
                  },
          ),
        ),
        body: isLoading ? Center(child: const CircularProgressIndicator(),):Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                child: Row(
                  children: [
                    Text('Select course:   '),
                    DropdownButton<Course>(
                      value: selectedCourse,
                      // set default text to be the most recent selction
                      items:[
                     DropdownMenuItem<Course>(
                    value: futureCourses[0],
                      child: Text(futureCourses[0].title.toString()),
                    )
                      ],
                      onChanged: (course) {
                        selectedCourse = course;
                        setState(() {});
                        // save the selected course details to shared preferences
                      },
                    )
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                child: Row(
                  children: [
                    Text('lecture code duration:   '),
                    DropdownButton<String>(
                      value: duration,
                      items:
                          <String>['1', '2', '3', '4', '5'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          duration = value;
                        });

                        // save the selected course details to shared preferences
                      },
                    ),
                    Text('   Min(s)')
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                child: Row(
                  children: [
                    Text('Session:  '),
                    DropdownButton<String>(
                      value: session,
                      items: <String>[
                        '2019/2020',
                        '2020/2021',
                        '2021/2022',
                        '2022/2023',
                        '2023/2024'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          session = value;
                        });
                        // save the selected course details to shared preferences
                      },
                    ),
                    Text('    Semester  '),
                    DropdownButton<String>(
                      value:
                          semester == '1' ? '${semester}st' : '${semester}nd',
                      items: <String>['1st', '2nd'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          semester = value[0];
                        });
                        // save the selected course details to shared preferences
                      },
                    ),
                  ],
                )),
            isLoading
                ? CircularProgressIndicator()
                : Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: MaterialButton(
                      color: Colors.green,
                      onPressed: () {
                        generateLecture.add(
                            {
                              "course_id": selectedCourse.courseId,
                              'generatedUI':const Uuid().v4(),
                              "duration": duration,
                              "course_name": selectedCourse.title,
                              "course_code": selectedCourse.courseCode,
                              "session": session,
                              "semester": semester,
                              'attendees':[],
                              'lecturerId':auth.currentUser.uid,
                              'createdAt':DateTime.now().millisecondsSinceEpoch
                            }
                        );
                        fetchCode(() {
                          setState(() {
                            isLoading = true;
                          });
                        },generateLecture, selectedCourse
                            ,duration, context, session,
                            semester);
                      },
                      child:
                          Text('Finish', style: TextStyle(color: Colors.white)),
                    ))
          ],
        ));
  }
}
