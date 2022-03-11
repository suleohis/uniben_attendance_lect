import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniben_attendance_lect/home/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:uniben_attendance_lect/models/lecturer.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String username = 'motejon272';
  String password = 'U5lDHd';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: Stack(
          children: [
            Container(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Align(
                          child: Text('Login', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                          alignment: Alignment.centerLeft,
                        ),
                        margin: const EdgeInsets.only(bottom: 25),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (val){
                                username = val;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Username',
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.email)
                              ),
                              enabled: !isLoading,
                            ),

                            Container(
                                height: 0.5,
                                color: Colors.grey,
                                margin: const EdgeInsets.only(top: 4)
                            ),

                            TextField(
                              onChanged: (val){
                                password = val;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.lock)
                              ),
                              enabled: !isLoading,
                            ),
                          ],
                        ),
                      ),

                      Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: Material(
                            borderRadius: BorderRadius.circular(8),
                            elevation: 4,
                            color: Colors.amber,
                            child: InkWell(
                                splashColor: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                                onTap: isLoading ? null : (){
                                  login(context, username, password);
                                },
                                child: Container(

                                  width: MediaQuery.of(context).size.width / 1.2,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Center(
                                      child: Text('login'.toUpperCase(), style: TextStyle(color: Colors.black))
                                  ),
                                )
                            ),
                          )
                      ),

                      // Container(
                      //   width: MediaQuery.of(context).size.width / 1.2,
                      //   margin: const EdgeInsets.only(top: 12),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Text('Don\'t have an account?', style: TextStyle()),
                      //       TextButton(
                      //           onPressed: () {
                      //             Navigator.of(context).push(MaterialPageRoute(builder: (_)=> SignUp()));
                      //           },
                      //           child: Text('Sign Up', style: TextStyle(color: Colors.yellow))
                      //       )
                      //     ],
                      //   ),
                      // ),


                    ],
                  ),
                )
            ),
            isLoading ? Container(
              color: Colors.black26,
              child: Center(
                  child: CircularProgressIndicator()
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ) : Container(height: 0, width: 0,)
          ],
        )
    );
  }



  login(context, username, password) async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });

    if((username == '') || (password == '')){
      print('enter fields');
      return;
    }

    // make http login request
    http.Client client = http.Client();
    try{
      http.Response response = await client.post(
        Uri.https('serene-harbor-85025.herokuapp.com', '/lecturers/login'),
          body: json.encode({
            "username": username,
            "password": password
          }),
        headers: {
          'Content-Type': 'application/json'
        }
      );
      dynamic decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      Lecturer lecturer = Lecturer.fromJson(decodedResponse['lecturer']);
      //save token and other fields to shared prefs
      pref.setString('token', decodedResponse['token']);
      pref.setString('name', lecturer.name);
      pref.setString('username', lecturer.username);
      pref.setString('id', lecturer.id);
      pref.setString('email', lecturer.email);
      pref.setBool('logged_in', true);

      Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomePage()));
    }catch(e){
      print(e);
    }
  }
}
