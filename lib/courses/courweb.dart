import 'package:flutter/material.dart';

class CourWeb extends StatefulWidget {
  const CourWeb({Key? key}) : super(key: key);

  @override
  _CourWebState createState() => _CourWebState();
}

class _CourWebState extends State<CourWeb> {
  List leson = [
    'Introduction',
    'Python',
    'Javascript basics',
    'Html/Css Begin',
  ];

  List subleson = [
    'Introduction to the course',
    'Detailed information on Python',
    'Javascript beginner to expert series',
    'Html/Css from basic to advanced',
  ];

  //for linear gradien color text 'MY Courses'

  final Shader linearGradient = LinearGradient(
    colors: [Colors.pink, Colors.blue],
  ).createShader(
    Rect.fromLTWH(0.0, 10.0, 200.0, 70.0),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Cours Web'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Web Development Bundle'.toUpperCase(),
              style: TextStyle(
                  foreground: Paint()..shader = linearGradient,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
            ListTile(
              contentPadding:EdgeInsets.all(0) ,
              leading: CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
                backgroundColor: Colors.grey[300],
              ),
              title: Text('Amine Jouha',
                style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Lead Instructor', style: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 12,
              ),),

            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Expanded(
              child: ListView.builder(
                  itemCount: leson.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 13),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color:Colors.grey,
                              offset: Offset(0,0),
                              blurRadius: 5,
                            )
                          ]
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text(
                            '$index',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          leson[index],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          subleson[index].toString(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: Colors.blueAccent,
                        ),
                      ),
                    );
                  }
              ),
            ),
            SizedBox(height:10,),
            Column(
                children:[ Center(child: Image.asset('assets/webDev.png', fit: BoxFit.contain, height: 220,)),]
            ),
          ],
        ),
      ),
    );
  }
}


