import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psinsx/pages/check_login.dart';

void main() {
   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
 ));

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
            headline5: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 18),
          )),
      home: CheckLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}
