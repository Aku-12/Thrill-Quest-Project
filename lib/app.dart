import 'package:flutter/material.dart';
import 'package:thrill_quest/View/login_screen.dart';
import 'package:thrill_quest/View/splash_screen.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context)=>SplashScreen(),
        '/login':(context)=>LoginScreen(),

      },
      debugShowCheckedModeBanner: false,
    );     
  }
}