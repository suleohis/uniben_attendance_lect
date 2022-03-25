import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uniben_attendance_lect/home/api_requests.dart';
class LectureAttendees extends StatefulWidget {
  final List attendees;
  LectureAttendees({this.attendees});

  @override
  _LectureAttendeesState createState() => _LectureAttendeesState();
}

class _LectureAttendeesState extends State<LectureAttendees> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Lecture Attendees'),
            leading: BackButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
        ),
        body: widget.attendees.isEmpty ? Center(
          child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: Text('No students have attended this lecturer yet')
          ),
        ) : ListView.builder(
          itemCount: widget.attendees.length,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return FutureBuilder(
              future:  FirebaseFirestore.instance
                    .collection('students')
                .doc(widget.attendees[index])
                .get(),
              builder: (context, snap){
                if(snap.hasData){
                  return ListTile(
                    title: Text('${snap.data['firstname']} ${snap.data['lastname']}'),
                    subtitle: Text('Mat No: ${snap.data['matricNo']}'),
                  );
                }else if(snap.hasError){
                  return Text('${snap.error}');
                }

                // show a default loading indicator
                return Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    height: 20,
                    width: 20,
                    child: const CircularProgressIndicator()
                  ),
                );
              }
            );
          },
        )
    );
  }
}

