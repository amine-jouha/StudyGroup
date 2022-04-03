import 'dart:collection';
// import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studygroup/FB_calendar/add_event2.dart';
import 'package:studygroup/FB_calendar/app_event.dart';
import 'package:studygroup/FB_calendar/event_datails.dart';
import 'package:studygroup/FB_calendar/event_firebase_services.dart';
import 'package:studygroup/model/user_model.dart';
import 'package:studygroup/src/for_event_calendar/add_event.dart';
import 'package:studygroup/src/for_event_calendar/event.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {


  @override
  _CalendarState createState() => _CalendarState();

}


//pour faire la popWarning de logout
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

class _CalendarState extends State<Calendar> {
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
    });
    selectedEvents = {};
  }
  Map<DateTime, List<Event>>? selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  // TextEditingController _eventController = TextEditingController();
  LinkedHashMap<DateTime, List<AppEvent>>? _groupedEvents;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();








  int getHashCode(DateTime key){
    return key.day * 1000000 + key.month * 10000 + key.year;
  }


  void _groupEvents(List<AppEvent> events) async {

   _groupedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    events.forEach((event) {
      DateTime date = DateTime.utc(event.date.year, event.date.month, event.date.day, 12);
      if(_groupedEvents?[date]==null) _groupedEvents?[date] = [];
      _groupedEvents?[date]!.add(event);
    });
  }
  List<dynamic> _getEventsForDay(DateTime date){
    return _groupedEvents?[date] ?? [];
  }








  //
  // List<Event> _getEventsfromDay(DateTime date) {
  //   return selectedEvents[date] ?? [];
  // }






  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Calendar'),
            centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.all(8.0),
              child: TableCalendar(
                  focusedDay: DateTime.now(),
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2050),
                eventLoader: _getEventsForDay,
                  calendarFormat: format,
                  headerStyle: HeaderStyle(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.blue,
                          Colors.purpleAccent,
                        ],
                      ),
                    ),
                    headerMargin: EdgeInsets.only(bottom: 10.0),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    formatButtonDecoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    formatButtonTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    leftChevronIcon: Icon(Icons.chevron_left,color: Colors.white,),
                    rightChevronIcon: Icon(Icons.chevron_right,color: Colors.white,),
                  ),

                  onFormatChanged: (CalendarFormat _format) {
                    setState(() {
                      format = _format;
                    });
                  },
                startingDayOfWeek: StartingDayOfWeek.monday,
                daysOfWeekVisible: true,

                //Day Changed
                onDaySelected: (DateTime selectDay, DateTime focusDay) {
                  setState(() {
                    selectedDay = selectDay;
                    focusedDay = focusDay;
                  });
                  print(focusedDay);
                  print(selectDay);
                },
                selectedDayPredicate: (DateTime date) {
                  return isSameDay(selectedDay, date);
                },


                  // eventLoader: _getEventsfromDay,

              ),
            ),
            StreamBuilder(
              stream: eventDBS.streamQueryList(
                args: [
                  QueryArgsV2('user_id',
                      isEqualTo: loggedInUser.uid.toString(),)
                ],
              ),
              builder: (BuildContext context,AsyncSnapshot snapshot) {
                // if (snapshot.hasError) {
                //   return Container(
                //     child: Text("Error"),
                //   );
                // }

                if (snapshot.hasData) {
                  List<AppEvent>? events = snapshot.data as List<AppEvent>?;
                  _groupEvents(events!);
                  return SingleChildScrollView(
                    child: Container(
                      // width: 300,
                      height: 300,
                      child: ListView.builder(
                        itemCount: events.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final  event = events[index];
                          return ListTile(
                            title: Text(event.title),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AddEvent2(event: event, selectedDay: selectedDay,),
                                    settings: RouteSettings(name: '')
                                ));



                              }
                              // => Navigator.pushNamed(
                              //     context, AppRoutes.editEvent,
                              //     arguments: event
                              // ),
                            ),




                            subtitle: Text(DateFormat("EEEE, dd MMMM, yyyy")
                                .format(event.date)),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => EventDetails(event: event, selectedDay: selectedDay,),
                                  settings: RouteSettings(name: '')
                              ));
                              // Navigator.pushNamed(
                              //   context,
                              //   AppRoutes.viewEvent,
                              //   arguments: event,
                              // );
                            },
                          );
                        },
                      ),
                    ),
                  );
                }
                return CircularProgressIndicator();
              },

            ),


            // ..._getEventsfromDay(selectedDay).map(
            //       (Event event) => ListTile(
            //     title: Text(
            //       event.title,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          label: Text('Add event', style: TextStyle(color: Colors.white),),
          icon:Icon(Icons.add, color: Colors.white,) ,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddEvent(selectedDay: selectedDay,)));
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (context) => AddEvent(selectedDay: selectedDay, event: null,),
            //     settings: RouteSettings(name: '')
            // ));
          },),
          // onPressed: () => showDialog(
          //     context: context,
          //     builder: (context)
              // builder: (context) => AlertDialog(
              //   title: Text('Add Event'),
              //   content: TextFormField(
              //     controller: _eventController,
              //   ),
              //   actions: [
              //     TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
              //     TextButton(
              //       child: Text('ok'),
              //       onPressed:() {
              //         if (_eventController.text.isEmpty) {
              //
              //         } else {
              //           if (selectedEvents[selectedDay] != null) {
              //             selectedEvents[selectedDay]!.add(
              //               Event(title: _eventController.text),
              //             );
              //           } else {
              //             selectedEvents[selectedDay] = [
              //               Event(title: _eventController.text)
              //             ];
              //           }
              //         }
              //         Navigator.pop(context);
              //         _eventController.clear();
              //         setState(() {});
              //         return;
              //       },
              //     ),
              //   ],
              // ),

        ),


      );

  }
}
