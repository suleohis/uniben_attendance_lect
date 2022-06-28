
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uniben_attendance_lect/models/course.dart';
import 'package:uuid/uuid.dart';
import 'api_requests.dart';

class GenerateCode extends StatefulWidget {
  const GenerateCode({Key? key}) : super(key: key);

  @override
  _GenerateCodeState createState() => _GenerateCodeState();
}

class _GenerateCodeState extends State<GenerateCode> {
  List<Course>? futureCourses = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCourses();
    fetch();
  }

  Course? selectedCourse;
  String duration = '1';
  String semester = '1';
  String semesterD= '1st Semester';
  String initialLevel = '100';
  String level = '100 Level';
  String session = '2020/2021';
  bool isLoading = false;
  List<Map<String,dynamic>> generateLecture = [];
   fetchCourses() {
     FirebaseFirestore.instance.collection('courses')
        .doc('300 Level ')
        .collection('1st Semester').get().then((snapshot){
          print(snapshot.docs.length);
    });
    List<Course> course = [];
    // course.add(Course.fromSnap(snapshot));
    // snapshot.docs.map((e) {
    // }).toList();
    // return course;
  }
  fetch() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    setState(() {
      isLoading  = true;

    });

     fetchCourses();
    print('here');
    FirebaseFirestore.instance
        .collection('lecturers')
        .doc(auth.currentUser!.uid)
        .get().then((DocumentSnapshot value) {
          print(value);

          List va = value['generateLecture'];
          for (var element in va) {
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
          }
          print(generateLecture);
          ///work ont course
          ///

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
          title: const Text('Create Lecture'),
          leading: BackButton(
            onPressed: isLoading
                ? null
                : () {
                    Navigator.of(context).pop();
                  },
          ),
        ),
        body: isLoading ? const Center(child: CircularProgressIndicator(),):Column(
          children: [

            Container(
                margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                child: Row(
                  children: [
                    const Text('Level:   '),
                    DropdownButton<String>(
                      value: initialLevel,
                      items:
                      <String>['100','200','300','400'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          level = value! + ' Level';
                          initialLevel = value;
                        });

                        // save the selected course details to shared preferences
                      },
                    ),

                  ],
                )),
            Container(
                margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                child: Row(
                  children: [
                    const Text('Select course:   '),
                  selectedCourse == null ?  StreamBuilder(
                      stream:  FirebaseFirestore.instance.collection('courses')
                          .doc(level)
                          .collection(semesterD).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                        if(snapshot.hasData ){
                          futureCourses!.clear();
                          snapshot.data!.docs.map((elemnt){
                            print(elemnt.data());
                            futureCourses!.add(Course.fromSnap(elemnt));
                            print(futureCourses!.last.courseCode);
                          }).toList();
                          return DropdownButton<Course>(
                            value: selectedCourse,
                            // set default text to be the most recent selction
                            // items: [
                            // DropdownMenuItem<Course>(
                            //   value: futureCourses![0],
                            //   child: Text(futureCourses![0].title.toString()),
                            // )
                            // ],
                            items:futureCourses!.map((e) => DropdownMenuItem<Course>(
                              value: e,
                              child: Text(e.title.toString()),
                            )).toList(),
                            onChanged: (course) {
                              selectedCourse = course;
                              setState(() {});
                              // save the selected course details to shared preferences
                            },
                          );
                        }else{
                          return const SizedBox();
                        }

                      },

                    )
                      : GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedCourse = null;
                        });
                      },
                      child: Text(selectedCourse!.title!,))
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                child: Row(
                  children: [
                    const Text('lecture code duration:   '),
                    DropdownButton<String>(
                      value: duration,
                      items:
                          <String>['1', '2', '3', '4', '5','10','15','30','60'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          duration = value!;
                        });

                        // save the selected course details to shared preferences
                      },
                    ),
                    const Text('   Min(s)')
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                child: Row(
                  children: [
                    const Text('Session:  '),
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
                          session = value!;
                        });
                        // save the selected course details to shared preferences
                      },
                    ),
                    const Text('    Semester  '),
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
                          semester = value![0];
                          semesterD = value == '1st' ? '1st Semester' : '2nd Semester';
                        });
                        // save the selected course details to shared preferences
                      },
                    ),
                  ],
                )),
            isLoading
                ? const CircularProgressIndicator()
                : Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: MaterialButton(
                      color: Colors.green,
                      onPressed: () {
                        generateLecture.add(
                            {
                              "course_id": selectedCourse!.courseId,
                              'generatedUI':const Uuid().v4(),
                              "duration": duration,
                              "course_name": selectedCourse!.title,
                              "course_code": selectedCourse!.courseCode,
                              "session": session,
                              "semester": semester,
                              'attendees':[],
                              'lecturerId':auth.currentUser!.uid,
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
                          const Text('Finish', style: TextStyle(color: Colors.white)),
                    )),
          ],
        ));
  }
}
