import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studygroup/FB_calendar/app_event.dart';
import 'package:studygroup/FB_calendar/event_firebase_services.dart';
import 'package:studygroup/model/user_model.dart';
import 'package:validators/validators.dart';

class AddEvent extends StatefulWidget {

  final DateTime selectedDay;


  const AddEvent({required this.selectedDay,});

  // AddEvent(DateTime selectedDay);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool? validated ;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

 @override
  void initState() {
   FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((value) {
    this.loggedInUser = UserModel.fromMap(value.data());
   });}

  // @override
  // void initState() {
  //   super.initState();
  //   FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((value) {
  //     this.loggedInUser = UserModel.fromMap(value.data());
  //     setState(() {});
  //   });





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.blueAccent,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                //save event
                validated = _formKey.currentState!.validate();
                if (validated!) {
                _formKey.currentState?.save();
                final data = Map<String, dynamic>.from(_formKey.currentState!.value);
                data['date'] = (data['date'] as DateTime).millisecondsSinceEpoch;
                print(data);
                  data['user_id'] = loggedInUser.uid.toString();
                  print(loggedInUser.uid);
                  await eventDBS.create(data);

                  Navigator.pop(context);

                }

              },
              child: Text('Save'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(15.0),
        children: [
          FormBuilder(
            key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                  name: 'title',
                      decoration: InputDecoration(
                        hintText: 'Add Title',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 48.0)
                      ),
                  ),
                  Divider(),
                  FormBuilderTextField(name: 'description', maxLines: 5, minLines: 1,
                      decoration: InputDecoration(border: InputBorder.none,
                      hintText: 'Add Details',
                        prefixIcon: Icon(Icons.short_text),
                      )
                  ),
                  Divider(),
                  FormBuilderSwitch(
                      name: 'public',
                      title: Text('Public'),
                      initialValue: false,
                      controlAffinity: ListTileControlAffinity.leading,
                      decoration: InputDecoration(border: InputBorder.none),

                  ),
                  Divider(),
                  FormBuilderDateTimePicker(
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                      name: 'date',
                    initialValue: widget.selectedDay,
                        // ?? DateTime.now(),
                    fieldHintText: 'Add Date',
                    inputType: InputType.date,
                    format: DateFormat('EEEE, dd MMMM, yyyy'),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.calendar_today_sharp)
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }
}


