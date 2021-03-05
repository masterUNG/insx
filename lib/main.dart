import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psinsx/pages/check_login.dart';

void main() {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'สดุดียี่สิบสาม',
      theme: ThemeData(
          fontFamily: 'Prompt',
          brightness: Brightness.dark,
          //primarySwatch: Colors.red,
          primaryColor: Colors.red[900],
          accentColor: Colors.redAccent,
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 18),
          )),
      home: CheckLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}
