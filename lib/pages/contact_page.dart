import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ติดต่อเรา'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Contact'),
            RaisedButton(
                child: Text('กลับหน้าหลัก'),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'homestack/home', (Route<dynamic> route) => false);
                }),
          ],
        ),
      ),
    );
  }
}
