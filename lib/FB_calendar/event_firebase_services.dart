import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';
import 'package:studygroup/FB_calendar/app_event.dart';
import 'data_constants.dart';

final eventDBS = DatabaseService<AppEvent>(
    AppDBConstants.eventsCollection,
    fromDS: (uid, data) => AppEvent.fromDS(uid, data!),
  toMap: (event) => event.toMap(),
);