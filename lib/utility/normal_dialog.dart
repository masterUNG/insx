import 'package:flutter/material.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(message, style: TextStyle(fontSize: 18, ),),
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK')),
          ],
        )
      ],
    ),
  );
}
