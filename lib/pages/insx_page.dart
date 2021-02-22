import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psinsx/models/insx_model.dart';
import 'package:psinsx/models/insx_model2.dart';
import 'package:psinsx/pages/insx_edit.dart';
import 'package:psinsx/pages/map_insx.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/my_style.dart';
import 'package:psinsx/utility/normal_dialog.dart';
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
  List<InsxModel2> insxModel2s = [];
  List<Color> colorIcons = List();
  List<File> files = List();
  String urlImage;

  @override
  void initState() {
    super.initState();
    readInsx();
  }

  Future<Null> readInsx() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String workername = preferences.getString('staffname');

    String url =
        'https://pea23.com/apipsinsx/getInsxWhereUser.php?isAdd=true&worker_name=$workername';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        var result = json.decode(value.data);
        for (var map in result) {
          InsxModel2 insxModel2 = InsxModel2.fromMap(map);
          setState(() {
            insxModel2s.add(insxModel2);
            colorIcons.add(calculageHues(insxModel2.noti_date));
            files.add(null);
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
      body:
          loadStatus ? Center(child: MyStyle().showProgress()) : showContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (context) => MapInsx(
              insxModel2s: insxModel2s,
            ),
          );
          Navigator.push(context, materialPageRoute);
        },
        child: Icon(Icons.map_sharp),
      ),
    );
  }

  Widget showContent() {
    return status
        ? showListInsx()
        : Container(
            child: Center(
              child: Text(
                'No Data',
                style: TextTheme().bodyText1,
              ),
            ),
          );
  }

  Color calculageHues(String notidate) {
    List<Color> colors = [Colors.green, Colors.yellow, Colors.blue, Colors.red];
    List<String> strings = notidate.split(" ");
    List<String> dateTimeInts = strings[0].split('-');
    DateTime notiDateTime = DateTime(
      int.parse(dateTimeInts[0]),
      int.parse(dateTimeInts[1]),
      int.parse(dateTimeInts[2]),
    );

    DateTime currentDateTime = DateTime.now();
    int diferDate = currentDateTime.difference(notiDateTime).inDays;
    Color result = colors[0];

    if (diferDate >= 7) {
      result = colors[3];
    } else if (diferDate >= 4) {
      result = colors[2];
    } else if (diferDate >= 2) {
      result = colors[1];
    }
    return result;
  }

  Future<Null> confirmDialog(
      InsxModel2 insxModel2, Color color, int index) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Icon(
            Icons.pin_drop,
            size: 36,
            color: color,
          ),
          title: Text(insxModel2.cus_name),
          subtitle: Text(insxModel2.pea_no),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('กรุณาเลือก Camera'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    chooseCamera(index);
                    Navigator.pop(context);
                  }),
              IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget showListInsx() => SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text(insxModel2s.length == 0
                    ? 'ข้อมูล : ? รายการ'
                    : 'ข้อมูล : ${insxModel2s.length} รายการ'),
              ),
            ),
            ListView.builder(
              itemCount: insxModel2s.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (context) => InsxEdit(
                      insxModel2: insxModel2s[index],
                    ),
                  );
                  Navigator.push(context, route);
                },

                //=> confirmDialog(insxModel2s[index], colorIcons[index], index),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.pin_drop,
                        size: 36,
                        color: colorIcons[index],
                      ),
                      title: Text(
                        insxModel2s[index].cus_name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${insxModel2s[index].write_id} \n${insxModel2s[index].pea_no} ',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Future<Null> chooseCamera(int index) async {
    try {
      var object = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        files[index] = File(object.path);
        uploadImage(files[index], index);
      });
    } catch (e) {}
  }

  Future<Null> uploadImage(File file, int index) async {
    String apiSaveFile = '${MyConstant().domain}/apipsinsx/saveFile.php';

    //TimeOfDay timeOfDay = TimeOfDay.now();
    String fileName =
        'insx${Random().nextInt(1000000)}${insxModel2s[index].ca}.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: fileName);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveFile, data: data).then((value) {
        //print('====>>> $value');
        //print('Success url Image ==>> https://pea23.com/apipsinsx/upload/$fileName');
        urlImage = '${MyConstant().domain}/apipsinsx/upload/$fileName';
        print('=== usrlImage == $urlImage');

        editDataInsx(insxModel2s[index]);
      });
    } catch (e) {}
  }

  Future<Null> editDataInsx(InsxModel2 insxModel2) async {
    print('id insx == ${insxModel2.id}');

    String url =
        '${MyConstant().domain}/apipsinsx/editDataWhereId.php?isAdd=true&id=${insxModel2.id}&invoice_status=ดำเนินการเสร็จสมบูรณ์&work_image=$urlImage';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        readInsx();
        print('readInsx==>>> $value');
      } else {
        normalDialog(context, 'ผิดพลาด กรุณาลองใหม่');
      }
    });
  }
}
