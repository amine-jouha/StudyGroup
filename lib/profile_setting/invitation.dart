import 'package:flutter/material.dart';

class Invitation extends StatefulWidget {
  const Invitation({Key? key}) : super(key: key);

  @override
  _InvitationState createState() => _InvitationState();
}

class _InvitationState extends State<Invitation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitation'),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}