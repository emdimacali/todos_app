import 'package:flutter/material.dart';
import 'package:hive_tasks_api/hive_tasks_api.dart';
import 'package:todos_app/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(const App());
}
