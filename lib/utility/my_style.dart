import 'package:flutter/material.dart';

class MyStyle {
  Widget showProgress(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Colors.redAccent,
            strokeWidth: 10,
            valueColor: AlwaysStoppedAnimation(Colors.blue),
          ),
        ],
      ),
    );
  }
}