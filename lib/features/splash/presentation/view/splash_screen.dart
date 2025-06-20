import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4),(
    ){
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/login');

    });
    return Scaffold(
      body:Padding(padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Lottie.asset("assets/animation/trillsplash.json"),
      ),),
    );
  }
}