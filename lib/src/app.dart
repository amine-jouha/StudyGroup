import 'package:flutter/material.dart';
import 'package:studygroup/src/for_event_calendar/add_event.dart';
import 'package:studygroup/src/screens/home.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:studygroup/src/screens/login.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyGroup',
      theme: ThemeData(
        accentColor: Colors.lightBlueAccent,
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/studygroup.png'),
        nextScreen: HomeWelcome(),
        splashTransition: SplashTransition.fadeTransition,
      ),

      // routes: {
      //   // When navigating to the "/second" route, build the SecondScreen widget.
      //   '/add_event': (context) => AddEvent(selectedDate: settings.arguments, ),
      // },

    );
  }
}
