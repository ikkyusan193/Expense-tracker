import 'package:eTracker/page/launcher.dart';
import 'package:flutter/material.dart';

void main() {  runApp(const MyApp());}

// ส่วนของ Stateless widget
class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Flutter App',
      initialRoute: 'home',
      routes: {
        Launcher.routeName: (context) => const Launcher(),
      },
    );
  }
}