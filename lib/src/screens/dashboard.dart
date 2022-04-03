import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:studygroup/courses/courdesign.dart';
import 'package:studygroup/courses/courweb.dart';
import 'package:studygroup/courses/exams.dart';
import 'package:studygroup/model/user_model.dart';
import 'package:studygroup/src/screens/login.dart';
// import 'package:studygroup/src/screens/predashboard.dart';
// import 'package:studygroup/src/screens/profile.dart';


class Dashboard extends StatefulWidget {

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();


  List courses = [
    'Design Tool Bundles',
    'Web Development Bundle',
    'Exams & Event',
  ];
  List per = [
    0.4,
    0.7,
    0.5
  ];
  List perstr = [
    '40 %',
    '70 %',
    '50 %'
  ];

  List fonc = [
    CourDesign(),
    CourWeb(),
    Exams(),
  ];

  List subtitle = [
    'Adobe XD, Photoshop, Figma',
    'Python, Javascript, Html/Css',
    'Exams Development And Design, Events Groups Teach ',
  ];
//for linear gradien color text 'MY Courses'

  final Shader linearGradient = LinearGradient(
    colors: [Colors.pink, Colors.blue],
  ).createShader(
    Rect.fromLTWH(0.0, 10.0, 200.0, 70.0),
  );

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }
  Future<Widget> _getImageFB(BuildContext context, String imageName) async {
    late Image image;
    await FireStorageService.loadImage(context, imageName).then((value) => {
      image = Image.network(
        value.toString(),
        fit: BoxFit.cover,
        width: 40,

      ),
    });
    return image;
  }

  Future<bool?> showWarning(BuildContext context) async {
    return showDialog<bool>(
    context : context,
    builder : (context) => AlertDialog(
      title: Text("Warning!"),
      content: Text("Do you want to logout?!"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Yes")),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            "Nop",
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
      ],
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard',
            style:TextStyle(
              color: Colors.white,
            ) ,
          ),
          backgroundColor: Colors.lightBlue,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications),
                color: Colors.white,
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.all(8),
                child: FutureBuilder<Widget>(
                  future: _getImageFB(context, '${loggedInUser.uid.toString()}'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      if (snapshot.connectionState == ConnectionState.done) {
                        print('le voici');
                        print(snapshot.data);
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 60,
                            child: snapshot.data,

                          ),
                        );

                      }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return InkWell(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Container(
                              child: Image.asset('assets/pp.png')
                          ),
                        ),
                      );
                    }
                    else {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Container(
                              child: Image.asset('assets/pp.png')
                    ),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Courses'.toUpperCase(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = linearGradient),
                ),

              Padding(
                  padding: EdgeInsets.only(top: 15),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                    shrinkWrap: true,
                    itemBuilder:(BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Material(
                          child: InkWell(
                            highlightColor: Colors.white.withAlpha(50),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => fonc[index]));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: Image.asset('assets/$index.png',
                                  fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        courses[index].toString().toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 5),
                                      ),
                                      Text(
                                        subtitle[index].toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey[300],
                                        height: 25,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(right: 15),
                                                child: LinearPercentIndicator(
                                                  animation: true,
                                                  lineHeight:5.0,
                                                  animationDuration:2500,
                                                  percent: per[index],
                                                  backgroundColor: Colors.grey[300],
                                                  linearStrokeCap: LinearStrokeCap.roundAll,progressColor: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(perstr[index].toString()),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    },
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }


}
class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}

