import 'package:flutter/material.dart';
import 'package:thrill_quest/View/login_screen.dart';
import 'package:thrill_quest/View/splash_screen.dart';
import 'package:thrill_quest/theme/mytheme.dart';
import 'package:thrill_quest/view/home_screen.dart';
import 'package:thrill_quest/view/signup_screen.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context)=>SplashScreen(),
        '/login':(context)=>LoginScreen(),
        '/signup':(context)=>SignupScreen(),
        '/homeScreen':(context)=>HomeScreen()

      },
      debugShowCheckedModeBanner: false,
      theme: getTheme(),
    );     
  }
}