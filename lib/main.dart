import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:studygroup/src/app.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting();
  runApp(App());
}





