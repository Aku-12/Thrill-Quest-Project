import 'package:flutter/material.dart';

ThemeData getTheme(){
  return ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.amber,
        fontFamily: "Poppins Black",
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 210, 160, 86),
          centerTitle: false,
          elevation: 2,
        ),
      );
}