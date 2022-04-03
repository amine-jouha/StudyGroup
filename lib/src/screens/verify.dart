import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studygroup/src/screens/dashboard.dart';
import 'package:studygroup/src/screens/login.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();

    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar :AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.blue,),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
        title: Text('Dashboard', style: TextStyle(color: Colors.blue,),),
      ),
      body: Center(child: Text('An email has been sent to ${user.email} please verify'),),

    );
  }
  Future<void> checkEmailVerified() async{
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified){
      //ici on cancel le timer qui nous a fait attendre aprés avoir validé l'adresse email
      timer.cancel();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }
}
