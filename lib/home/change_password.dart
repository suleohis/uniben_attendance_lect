import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  bool seePassword = false;
  bool validate = false;
  bool oldValidate = false;
  String email = '';
  final currentUser = FirebaseAuth.instance.currentUser;

  changePassword() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(),)
    );
    try{
      FirebaseAuth auth = FirebaseAuth.instance;
      auth
          .signInWithEmailAndPassword(email: email,
          password: oldPasswordController.text).then((value) async{
        await currentUser!.updatePassword(passwordController.text).then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('Your Password Has Been Changed') ,
        )
        );
        });
      });

    } on FirebaseAuthException catch (error){
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text(error.message.toString()) ,
          )
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      email= prefs.getString('email')!;
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    oldPasswordController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Container(
        margin: const EdgeInsets.only(
            top: 16, left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: !seePassword,
              onChanged: (value){
                if(value.length > 7){
                  setState(() {
                    oldValidate = false;
                  });
                }
              },
              decoration: InputDecoration(
                  hintText: 'Old Password',
                  border: const OutlineInputBorder(),
                  labelText: 'Old Password',
                  errorText: oldValidate ? 'Password Must be more than 8' : null,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          seePassword = !seePassword;
                        });
                      },
                      icon: Icon(
                        seePassword ?
                        Icons.visibility_off
                            :
                        Icons.visibility,
                        size: 30,
                      ))),
            ),
            const SizedBox(height: 15,),
            TextField(
              controller: passwordController,
              obscureText: !seePassword,
              onChanged: (value){
                if(value.length > 7){
                  setState(() {
                    validate = false;
                  });
                }
              },
              decoration: InputDecoration(
                  hintText: 'Change Password',
                  border: const OutlineInputBorder(),
                  labelText: 'Change Password',
                  errorText: validate ? 'Password Must be more than 8' : null,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          seePassword = !seePassword;
                        });
                      },
                      icon: Icon(
                        seePassword ?
                        Icons.visibility_off
                            :
                        Icons.visibility,
                        size: 30,
                      ))),
            ),
            ElevatedButton(
                onPressed: (){
                  if(passwordController.text.length > 7 && oldPasswordController.text.length > 7){
                    changePassword();
                  }else{
                    if(!oldValidate){
                      setState(() {
                        oldValidate = true;
                      });
                    }
                    if(validate){
                      print('e');
                      setState(() {
                        validate = true;
                      });
                    }

                  }
                },
                child: const Text('Change Password', style: TextStyle(fontSize: 22),)
            )
          ],
        ),
      ),
    );
  }
}
