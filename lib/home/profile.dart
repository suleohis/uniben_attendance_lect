import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniben_attendance_lect/auth/loginpage.dart';
import 'package:uniben_attendance_lect/home/change_password.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      firstnameController.text = prefs.getString('name')!;
    });
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              TextButton(
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // save edited data
                  setState(() {
                    loading = true;
                  });
                  editProfile(firstnameController.text, lastnameController.text,
                          context)
                      .then((val) {
                    setState(() {
                      loading = false;
                    });
                  });
                },
              )
            ],
            title: const Text('Edit Student Profile'),
            automaticallyImplyLeading: false,
            leading: BackButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                margin: const EdgeInsets.only(
                    top: 16, left: 16, right: 16, bottom: 16),
                child: Column(
                  children: [
                    SizedBox(
                        height: 50,
                        child: TextField(
                          controller: firstnameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Full Name'),
                        )),
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: TextButton(
                                  child: const Text('Change Password'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChangePassword()));
                                  },
                                )),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 16),
                            child: TextButton(
                              child: const Text('Log Out'),
                              onPressed: () async {
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                pref.remove(
                                  'name',
                                );
                                pref.remove(
                                  'username',
                                );
                                pref.remove('id');
                                pref.remove('email');
                                pref.remove('logged_in');
                                FirebaseAuth.instance.signOut();
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
                              },
                            )),
                      ],
                    )
                  ],
                )));
  }
}

editProfile(
  firstname,
  lastname,
  context,
) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    FirebaseFirestore.instance
        .collection('lecturers')
        .doc(auth.currentUser!.uid.toString())
        .update({
      'name': firstname,
    }).then((value) {
      pref.setString('name', firstname);
      Navigator.pop(context);
    });
  } catch (e) {
    print(e);
  }
}
