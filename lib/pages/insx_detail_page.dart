import 'package:flutter/material.dart';

class InsxDetailPage extends StatefulWidget {
  @override
  _InsxDetailPageState createState() => _InsxDetailPageState();
}

class _InsxDetailPageState extends State<InsxDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียด insx'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Detail Page'),
          ],
        ),
      ),
    );
  }
}
