import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thrill Quest"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 175, 216, 176),
      ), 
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Hey, Akash Good Morning!"),
        )
      ],),     
    );
  }
}
