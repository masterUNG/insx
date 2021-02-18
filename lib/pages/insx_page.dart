import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/insx_model.dart';
import 'package:psinsx/pages/map_insx.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsxPage extends StatefulWidget {
  InsxPage({Key key}) : super(key: key);

  @override
  _InsxPageState createState() => _InsxPageState();
}

class _InsxPageState extends State<InsxPage> {
  bool loadStatus = true; //โหลด
  bool status = true; //มีข้อมูล
  List<InsxModel> insxModels = List();

  @override
  void initState() {
    super.initState();
    readInsx();
  }

  Future<Null> readInsx() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String workername = preferences.getString('staffname');
    //print('workername === $workername');

    String url =
        'https://pea23.com/apipsinsx/getInsxWhereUser.php?isAdd=true&worker_name=$workername';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        //print('value ====>>> $value');

        var result = json.decode(value.data);

        print('result ===>>> $result');

        for (var map in result) {
          InsxModel insxModel = InsxModel.fromJson(map);
          setState(() {
            insxModels.add(insxModel);
            //print('map $map');
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                title: Text('จำนวน : 123 รายการ'),
                trailing: IconButton(icon: Icon(Icons.map), onPressed: (){
                  MaterialPageRoute materialPageRoute = MaterialPageRoute(
                      builder: (context) => MapInsx(),
                    );
                    Navigator.push(context, materialPageRoute);
                })
               
              ),
            ),
            loadStatus ? MyStyle().showProgress() : showContent(),
          ],
        ));
  }

  Widget showContent() {
    return status
        ? showListInsx()
        : Center(
            child: Text('No Data'),
          );
  }

  Widget showListInsx() => Text('มีข้อมูล');
}
