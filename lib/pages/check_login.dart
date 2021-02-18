import 'package:flutter/material.dart';
import 'package:psinsx/pages/signin_page.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class CheckLogin extends StatefulWidget {
  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  @override
  void initState() {
    super.initState();
    checkPreferance();
  }

  Future<Null> checkPreferance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String string = preferences.getString('id');
      if (string != null && string.isNotEmpty) {
        MaterialPageRoute route =
            MaterialPageRoute(builder: (context) => HomePage());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      } else {
        MaterialPageRoute route =
            MaterialPageRoute(builder: (context) => SignIn());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notification_important,
              size: 120,
              color: Colors.red[900],
            ),
            Text(
              'PSinsx',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
            //MyStyle().showProgress(),
          ],
        ),
      ),
    );
  }
}
