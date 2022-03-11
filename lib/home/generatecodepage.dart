import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uniben_attendance_lect/models/course.dart';
import 'api_requests.dart';

class GenerateCode extends StatefulWidget {
  @override
  _GenerateCodeState createState() => _GenerateCodeState();
}

class _GenerateCodeState extends State<GenerateCode> {

  Future<List<Course>> futureCourses;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCourses = fetchCourses();
  }

  Course selectedCourse;
  String duration = '1';
  String semester = '1';
  String session = '2020/2021';
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Create Lecture'),
        leading: BackButton(
          onPressed: isLoading ? null : (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
            child: Row(
              children: [
                Text('Select course:   '),
                FutureBuilder<List<Course>>(
                    future: futureCourses,
                    builder: (context, snapshot){
                      if (snapshot.hasData) {
                        return DropdownButton<Course>(
                          // set default text to be the most recent selction
                          items: snapshot.data.map((Course value) {
                            return DropdownMenuItem<Course>(
                              value: value,
                              child: Text(value.title),
                            );
                          }).toList(),
                          onChanged: (course) {
                            selectedCourse = course;
                            // save the selected course details to shared preferences
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    }
                )
              ],
            )
          ),

          Container(
              margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
              child: Row(
                children: [
                  Text('lecture code duration:   '),
                  DropdownButton<String>(
                    value: duration,
                    items: <String>['1', '2', '3', '4', '5'].map((String value) {
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
              )
          ),

          Container(
            margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
            child: Row(
              children: [
                Text('Session:  '),
                DropdownButton<String>(
                  value: session,
                  items: <String>['2019/2020', '2020/2021', '2021/2022', '2022/2023', '2023/2024'].map((String value) {
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
                  value: semester == '1' ? '${semester}st' : '${semester}nd',
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
            )
          ),

          isLoading ? CircularProgressIndicator() : Container(
            margin: const EdgeInsets.only(top: 16),
            child: MaterialButton(
              color: Colors.green,
              onPressed: (){
                fetchCode((){
                  setState(() {
                    isLoading = true;
                  });
                }, selectedCourse, duration, context, session, semester);
              },
              child: Text('Finish', style: TextStyle(color: Colors.white)),
            )
          )
        ],
      )
    );
  }




}
