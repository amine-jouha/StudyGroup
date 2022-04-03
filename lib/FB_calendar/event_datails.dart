
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studygroup/FB_calendar/add_event2.dart';
import 'package:studygroup/FB_calendar/app_event.dart';
import 'package:studygroup/FB_calendar/event_firebase_services.dart';

class EventDetails extends StatelessWidget {
  final AppEvent event;
  final DateTime selectedDay;

  const EventDetails({required this.event, required this.selectedDay}) : super();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AddEvent2(event: event, selectedDay: selectedDay,),
                  settings: RouteSettings(name: '')
              ));
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Warning!"),
                  content: Text("Are you sure you want to delete?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("Delete")),
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
              ) ??
                  false;

              if (confirm) {
                await eventDBS.removeItem(event.id);
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(event.public ? "Public" : "Private"),
          ListTile(
            leading: Icon(Icons.event),
            title: Text(
              event.title,
              style: Theme.of(context).textTheme.headline5,
            ),
            subtitle:
            Text(DateFormat("EEEE, dd MMMM, yyyy").format(event.date)),
          ),
          const SizedBox(height: 10.0),
          ListTile(
            leading: Icon(Icons.short_text),
            title: Text(event.description),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}