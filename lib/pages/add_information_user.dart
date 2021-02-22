import 'dart:convert';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/user_model.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInformationUser extends StatefulWidget {
  @override
  _AddInformationUserState createState() => _AddInformationUserState();
}

class _AddInformationUserState extends State<AddInformationUser> {
  UserModel userModel;
  String userAddress,
      userEmail,
      userPhone,
      userBankName,
      userBankNumber,
      userImg;

  @override
  void initState() {
    super.initState();
    readCurrentInfo();
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    String url =
        '${MyConstant().domain}/apipsinsx/getUserWhereId.php?isAdd=true&user_id=$id';
    Response response = await Dio().get(url);

    var result = json.decode(response.data);

    for (var map in result) {
      setState(() {
        userModel = UserModel.fromJson(map);
        userAddress = userModel.userAdress;
        userEmail = userModel.userEmail;
        userPhone = userModel.userPhone;
        userBankName = userModel.userBankName;
        userBankNumber = userModel.userBankNumber;
        userImg = userModel.userImg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null ? MyStyle().showProgress() : showContent(),
      appBar: AppBar(
        title: Text(
          'อัพเดทข้อมูล',style: TextStyle(fontSize: 14,),
        ),
      ),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            showImage(),
            eamilFrom(),
            addressFrom(),
            phoneFrom(),
          ],
        ),
      );

  Widget showImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: Icon(
              Icons.camera_alt,
              color: Colors.grey,
            ),
            onPressed: () {}),
        CircularProfileAvatar(
          '${userModel.userImg}',
          borderWidth: 4.0,
        ),
        IconButton(
            icon: Icon(
              Icons.photo_album_rounded,
              color: Colors.grey,
            ),
            onPressed: () {}),
      ],
    );
  }

  Widget phoneFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            width: 300,
            child: TextFormField(
              onChanged: (value) => userPhone = value,
              initialValue: userPhone,
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'เบอร์มือถือ'),
            ),
          ),
        ],
      );

  Widget eamilFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            width: 300,
            child: TextFormField(
              onChanged: (value) => userEmail = value,
              initialValue: userEmail,
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Email'),
            ),
          ),
        ],
      );

  Widget addressFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            width: 300,
            child: TextFormField(
              onChanged: (value) => userAddress = value,
              initialValue: userAddress,
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ที่อยู่'),
            ),
          ),
        ],
      );
}
