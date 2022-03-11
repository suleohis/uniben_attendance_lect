import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:uniben_attendance_lect/home/homepage.dart';

import 'home/homepage.dart';

class OnboardingPage extends StatelessWidget {

  List<PageViewModel> listOfPages = [
    PageViewModel(
      title: "Never miss a class",
      body: "Sign your class attendance sheets from your phone and never miss a class again",
      image: Image.asset("./assets/screen1.png", fit: BoxFit.fill, scale: 1,),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey),
        imageFlex:2,
        imageAlignment: Alignment.center,
        imagePadding: const EdgeInsets.only(top: 100),
        //titlePadding: const EdgeInsets.only(top: 0)
      ),
    ),
    PageViewModel(
      title: "Class attendance history",
      body: "Keep track of all of your class attendance history the easiest way.",
      image: Image.asset("./assets/screen2.png", fit: BoxFit.fill, scale: 1,),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey),
        imageFlex: 2,
        imageAlignment: Alignment.center,
        imagePadding: const EdgeInsets.only(top: 100),
      ),
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
        pages: listOfPages,
        color: Colors.green,
        next: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
          child: Text('Next', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.green
          ),
        ),
        showNextButton: true,
        showSkipButton: true,
        showDoneButton: true,
        skip: const Text('Skip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        done: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.green
          ),
        ),
        onDone: ()=>Navigator.of(context).push(CupertinoPageRoute(builder: (_)=> HomePage()))
    );
  }
}



