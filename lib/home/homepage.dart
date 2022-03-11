import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniben_attendance_lect/auth/loginpage.dart';
import 'package:uniben_attendance_lect/home/generatecodepage.dart';
import 'package:uniben_attendance_lect/home/profile.dart';
import 'package:uniben_attendance_lect/models/Lecture.dart';
import 'package:uniben_attendance_lect/models/lecturer.dart';
import '../onboardingpage.dart';
import 'api_requests.dart';
import 'lectureattendees.dart';

Lecturer user;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<Lecture>> futureLectures;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserLoginStatus();
  }

  ///This function checks whether the user is logged in
  ///or its the first time the user is launching the app
  ///if this is the first time the user is logged in, the user
  ///is sent to the onboarding page, its not, but the user is
  ///still not logged in, the user is sent to the sign in page
  ///if the user is logged in, the user remains on the homepage

  bool isLoading = true;
  checkUserLoginStatus(){
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      bool firstTime = prefs.getBool('is_first_time') ?? true;
      if(firstTime){
        // navigate to the onboarding page
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => OnboardingPage()));
        prefs.setBool('is_first_time', false);
      }else{
        // check if the user is logged in
        if(prefs.getBool('logged_in') ?? false){

          String name = prefs.getString('name');
          String username = prefs.getString('username');
          String id = prefs.getString('id');
          String email = prefs.getString('email');

          user = new Lecturer(name: name, id: id, username: username, email: email);
          setState(() {
            isLoading = false;
          });
          // fetch lecturers
          futureLectures = fetchLectures(session, semester);
          // get user data from api using data in shared preferences also
          // store most basic data for homepage in sharedPreferences
          // then fetch extra data for other areas as needed
        }else{
          // navigate to login page
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => Login()));
        }
      }
    });
  }

  String lectureToken;
  String duration;
  bool showQRCode = false;
  int durationCountdown = 60;

  Timer mTimer;
  String timeLeft = '60';

  bool fetchingData = false;
  countdownTimer(){
    mTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        --durationCountdown;
        timeLeft = '$durationCountdown';
        if(durationCountdown <= 0){
          timeLeft = '00';
          timer.cancel();
          showQRCode = false;
        }
      });
    });
  }

  String semester = '1';
  String session = '2020/2021';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: isLoading ? Center(
            child: CircularProgressIndicator()
        ) : DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                    actions: [
                      IconButton(
                          icon: Icon(Icons.person, color: Colors.white, size: 30),
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_)=> Profile()));
                          }
                      )
                    ],
                    title: Text('Hi ${user.name},'),
                    bottom: const TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.qr_code_rounded), text: 'Create Lecture',),
                        Tab(icon: Icon(Icons.list), text: 'My Lectures')
                      ],
                    ),
                ),
                body: TabBarView(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(
                            bottom: 10,
                            top: 20
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 4,
                                child: showQRCode ? QrImage(
                                  data: lectureToken,
                                  version: QrVersions.auto,
                                  size: MediaQuery.of(context).size.width / 1.2,
                                  gapless: false,
                                ) :
                                Icon(Icons.qr_code_scanner, size: MediaQuery.of(context).size.width / 1.4, color: Colors.grey,)
                            ),
                            Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    showQRCode ?
                                      CircleAvatar(
                                        child: Text(timeLeft, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700)),
                                        radius: 60,
                                      ) :
                                    Container(
                                        height: 50,
                                        margin: const EdgeInsets.only(top: 12),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(8),
                                          elevation: 4,
                                          color: Colors.amber,
                                          child: InkWell(
                                              splashColor: Colors.green,
                                              borderRadius: BorderRadius.circular(8),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => GenerateCode())).then((obj){
                                                  setState(() {
                                                    if(obj == null)
                                                      return;
                                                    lectureToken = obj['lectureToken'];
                                                    duration = obj['duration'];
                                                    if(duration == '1'){
                                                      durationCountdown = 60;
                                                    }else if(duration == '2'){}

                                                    switch(duration){
                                                      case '1':
                                                        durationCountdown = 60;
                                                        break;
                                                      case '2':
                                                        durationCountdown = 120;
                                                        break;
                                                      case '3':
                                                        durationCountdown = 180;
                                                        break;
                                                      case '4':
                                                        durationCountdown = 240;
                                                        break;
                                                      case '5':
                                                        durationCountdown = 300;
                                                        break;
                                                      default:
                                                        print('not a valid countdown');
                                                    }

                                                    print(lectureToken);
                                                    if(lectureToken != null){
                                                      showQRCode = true;
                                                      countdownTimer();
                                                    }

                                                  });
                                                });
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.width / 1.2,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8)
                                                ),
                                                child: Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text('Generate Lecture Code'.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 18)),
                                                        Container(
                                                          margin: const EdgeInsets.only(left: 6),
                                                        ),
                                                        Icon(Icons.qr_code_scanner, size: 40, color: Colors.white,),
                                                      ],
                                                    )
                                                ),
                                              )
                                          ),
                                        )
                                    ),
                                  ],
                                )
                            ),
                          ],
                        )
                    ),
                    Container(
                        child: Column(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                                  child: Row(
                                    children: [
                                      Text('Session:   '),
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
                                            futureLectures = fetchLectures(session, semester);
                                            fetchingData = true;
                                          });
                                          // save the selected course details to shared preferences
                                        },
                                      ),

                                      Container(margin: const EdgeInsets.only(
                                        left: 20
                                      )),

                                      Text('Semester:   '),
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
                                            futureLectures = fetchLectures(session, semester);
                                            fetchingData = true;
                                          });
                                          // save the selected course details to shared preferences
                                        },
                                      ),

                                      fetchingData ? Align(
                                        alignment: Alignment.topRight,
                                        child: Center(
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 20),
                                            height: 20,
                                            width: 20,
                                            // child: CircularProgressIndicator()
                                          )
                                        )
                                      ) : Container(height: 0, width: 0)
                                    ],
                                  )
                              ),
                              Expanded(
                                  child: FutureBuilder<List<Lecture>>(
                                    future: futureLectures,
                                    builder: (context, snapshot){
                                      if(snapshot.data != null && snapshot.data.isEmpty){
                                        fetchingData = false;
                                        return Center(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                            ),
                                            child: Text('You had no lecturers in the $semester${semester == '1' ? 'st' : 'nd'} semester of $session session',
                                                textAlign: TextAlign.center,
                                                style: TextStyle())
                                          )
                                        );
                                      }
                                      if(snapshot.hasData){
                                        fetchingData = false;
                                        return ListView.builder(
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, index){
                                            return ListTile(
                                              title: Text(snapshot.data[index].courseCode),
                                              subtitle: Text(snapshot.data[index].courseName),
                                              trailing: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('${DateFormat.yMEd().add_jms().format(DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data[index].createdAt)))}',
                                                  style: TextStyle(fontSize: 12),),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.group, color: Colors.green,),
                                                      Container(margin: const EdgeInsets.only(left: 8),),
                                                      Text('${snapshot.data[index].attendees.length}')
                                                    ],
                                                  )
                                                ],
                                              ),
                                              onTap: (){
                                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> LectureAttendees(attendees: snapshot.data[index].attendees)));
                                              },
                                            );
                                          },
                                        );
                                      } else if (snapshot.hasError) {
                                        setState(() {
                                          fetchingData = false;
                                        });
                                        return Text('${snapshot.error}');
                                      }

                                      // By default, show a loading spinner.
                                      return Center(
                                        child: const CircularProgressIndicator(),
                                      );
                                    }
                                  )
                              )
                            ],
                        )
                    )
                  ],
                )
            )
        )
    );
  }

}
