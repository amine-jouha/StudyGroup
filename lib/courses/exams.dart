import 'package:flutter/material.dart';


class Exams extends StatefulWidget {
  const Exams({Key? key}) : super(key: key);

  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Exams'),
        centerTitle: true,
      ),
    );
  }
}
