import 'package:app_sedekah_rw14/pages/Home.dart';
import 'package:app_sedekah_rw14/pages/Login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Sedekah RW 14",
        initialRoute: "/",
        theme: ThemeData(
          primarySwatch: Colors.green,
          backgroundColor: Colors.greenAccent,
        ),
        routes: {
          "/": (context) => Home(),
          "/login": (context) => Login(),
        });
  }
}
