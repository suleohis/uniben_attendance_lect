import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniben_attendance_lect/auth/forget%20password.dart';
import 'package:uniben_attendance_lect/auth/signuppage.dart';
import 'package:uniben_attendance_lect/home/homepage.dart';
import 'package:uniben_attendance_lect/models/lecturer.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  bool seePassword = false;
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
                        child: const Align(
                          child: Text('Login',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          alignment: Alignment.centerLeft,
                        ),
                        margin: const EdgeInsets.only(bottom: 25),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (val) {
                                email = val;
                              },
                              decoration: const InputDecoration(
                                  hintText: 'email',
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.email)),
                              enabled: !isLoading,
                            ),
                            Container(
                                height: 0.5,
                                color: Colors.grey,
                                margin: const EdgeInsets.only(top: 4)),
                            TextField(
                              onChanged: (val) {
                                password = val;
                              },
                              obscureText: !seePassword,
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          seePassword = !seePassword;
                                        });
                                      },
                                      icon: Icon(
                                        seePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 30,
                                      ))),
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
                                onTap: isLoading
                                    ? null
                                    : () {
                                        login(context, email, password);
                                      },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                      child: Text('login'.toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.black))),
                                )),
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        margin: const EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?', style: TextStyle()),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder:
                                      (_)=> const SignUp()));
                                },
                                child: const Text('Sign Up', style: TextStyle(color: Colors.yellow))
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        margin: const EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('I Forgot Must Password? ',
                                style: TextStyle()),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => const ForgetPassword()));
                                },
                                child: const Text('Forget Password',
                                    style: TextStyle(
                                        color: Colors.yellow, )))
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            isLoading
                ? Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  )
          ],
        ));
  }

  login(context, email, password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });

    if ((email == '') || (password == '')) {
      print('enter fields');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        FirebaseFirestore.instance
            .collection('students')
            .doc(auth.currentUser!.uid)
            .get()
            .then((value) {
          if (value.exists == false) {
            FirebaseFirestore.instance
                .collection('lecturers')
                .doc(auth.currentUser!.uid)
                .get()
                .then((DocumentSnapshot val) {
              print(auth.currentUser!.displayName);
              if (val.exists == false) {
                FirebaseFirestore.instance
                    .collection('lecturers')
                    .doc(auth.currentUser!.uid.toString())
                    .set({
                  'email': email,
                  'id': auth.currentUser!.uid,
                  'username': auth.currentUser!.displayName ?? '',
                  'name': auth.currentUser!.displayName ?? '',
                  'isLecturer': true,
                  'lectures': [],
                  'courses': [],
                  'generateLecture': []
                }).then((docSnap) {
                  FirebaseFirestore.instance
                      .collection('lecturers')
                      .doc(auth.currentUser!.uid.toString())
                      .get()
                      .then((DocumentSnapshot docSnap) {
                    Lecturer lecturer = Lecturer.fromSnap(docSnap);
                    pref.setString(
                      'name',
                      lecturer.name!,
                    );
                    pref.setString(
                      'username',
                      lecturer.username!,
                    );
                    pref.setString('id', lecturer.id!);
                    pref.setString('email', lecturer.email!);
                    pref.setBool('logged_in', true);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePage()));
                  }).catchError((e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login Failed'))
                    );
                  });
                }).then((value) {
                  setState(() {
                    isLoading = false;
                  });
                });
              } else {
                Lecturer lecturer = Lecturer.fromSnap(val);
                pref.setString(
                  'name',
                  lecturer.name!,
                );
                pref.setString(
                  'username',
                  lecturer.username!,
                );
                pref.setString('id', lecturer.id!);
                pref.setString('email', lecturer.email!);
                pref.setBool('logged_in', true);

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              }
            }).catchError((e) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login Failed'))
              );
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Failed'))
          );
        });
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Failed'))
        );
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Failed'))
      );
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }
}
