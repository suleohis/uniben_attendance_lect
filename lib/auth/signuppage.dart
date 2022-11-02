// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uniben_attendance_lect/home/api_requests.dart';
import 'package:uniben_attendance_lect/models/lecture.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: Container(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: const Align(
                        child: Text('Sign Up',
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
                            enabled: !isLoading,
                            onChanged: (val) {
                              email = val;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Email',
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.email)),
                          ),
                          Container(
                              height: 0.5,
                              color: Colors.grey,
                              margin: const EdgeInsets.only(bottom: 4)),
                          TextField(
                            enabled: !isLoading,
                            onChanged: (val) {
                              firstName = val;
                            },
                            decoration: const InputDecoration(
                                hintText: 'First Name.',
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.person)),
                          ),
                          Container(
                              height: 0.5,
                              color: Colors.grey,
                              margin: const EdgeInsets.only(top: 4)),
                          TextField(
                            enabled: !isLoading,
                            onChanged: (val) {
                              lastName = val;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Last Name.',
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.person)),
                          ),
                          Container(
                              height: 0.5,
                              color: Colors.grey,
                              margin: const EdgeInsets.only(top: 4)),
                          TextField(
                            enabled: !isLoading,
                            obscureText: true,
                            onChanged: (val) {
                              password = val;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Password',
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.lock)),
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
                                  : () async {
                                      await signUp(
                                          email, password, firstName, lastName);
                                    },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: CircularProgressIndicator())
                                        : Text('sign up'.toUpperCase(),
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
                          const Text('Already have an account?',
                              style: TextStyle()),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Login',
                                  style: TextStyle(color: Colors.yellow)))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  // FirebaseAuth auth = FirebaseAuth.instance;
  List<Lecture> gLectures = [];
  signUp(email, password, firstName, lastName) async {
    setState(() {
      isLoading = true;
    });
    if ((email == null || email == '') ||
        (firstName == null || firstName == '') ||
        (lastName == null || lastName == '') ||
        (password == null || password == '')) {
      if (kDebugMode) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('All fields must be properly entered')));
      }
      setState(() {
        isLoading = false;
      });
      return;
    }
    print('start');
    signUpRequest(email, password, firstName, lastName, context).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    setState(() {
      isLoading = false;
    });

    print('failed to signUp');
  }
}
