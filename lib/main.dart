import 'package:flutter/material.dart';
import 'package:thrill_quest/app/app.dart';
import 'package:thrill_quest/app/service_locator/service_locator.dart';
// import 'package:thrill_quest/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // await HiveService().init();
  runApp(const App());
}