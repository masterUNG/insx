import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {

    Map company = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('เกี่ยวกับเรา'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('About As'),
            SizedBox(height: 30,),
            Text('Email : ${company['email']}'),
            Text('Phone : ${company['phone']}'),
            RaisedButton(
                child: Text('กลับหน้าหลัก'),
                onPressed: () {
                  Navigator.pop(context, 'About Page');
                }),
            RaisedButton(
                child: Text('หน้าติดต่อเรา'),
                onPressed: () {
                  Navigator.pushNamed(context, 'homestack/contact');
                }),
           
          ],
        ),
      ),
    );
  }
}
