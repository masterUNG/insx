import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psinsx/models/insx_model.dart';
import 'package:psinsx/models/insx_model2.dart';
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
  List<InsxModel2> insxModel2s = [];
  List<Color> colorIcons = List();
  List<File> files = List();

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
        body: ListView(
      children: <Widget>[
        Card(
          child: ListTile(
              title: Text(insxModel2s.length == 0
                  ? 'จำนวน : ? รายการ'
                  : 'จำนวน : ${insxModel2s.length} รายการ'),
              trailing: IconButton(
                  icon: Icon(Icons.map),
                  onPressed: () {
                    MaterialPageRoute materialPageRoute = MaterialPageRoute(
                      builder: (context) => MapInsx(
                        insxModel2s: insxModel2s,
                      ),
                    );
                    Navigator.push(context, materialPageRoute);
                  })),
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

  Widget showListInsx() => ListView.builder(
        itemCount: insxModel2s.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () =>
              confirmDialog(insxModel2s[index], colorIcons[index], index),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ListTile(
                      leading: Icon(
                        Icons.pin_drop,
                        size: 36,
                        color: colorIcons[index],
                      ),
                      title: Text(insxModel2s[index].cus_name),
                      subtitle: Text(
                        '${insxModel2s[index].write_id} \n${insxModel2s[index].pea_no}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: files[index] == null
                        ? Text('No Image')
                        : Container(
                            height: 90,
                            child: Image(
                              fit: BoxFit.cover,
                              image: FileImage(files[index]),
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Future<Null> chooseCamera(int index) async {
    try {
      var object = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        files[index] = File(object.path);
        uploadImage(files[index], index);
      });
    } catch (e) {}
  }

  Future<Null> uploadImage(File file, int index) async {
    String apiSaveFile = 'https://pea23.com/apipsinsx/saveFile.php';
    
    TimeOfDay timeOfDay = TimeOfDay.now();
    String fileName = 'image${Random().nextInt(1000000)}${insxModel2s[index].ca}.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: fileName);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveFile, data: data).then((value) {
        print('====>>> $value');
        print(
          '===== Success url Image ==>> https://pea23.com/apipsinsx/upload/$fileName');
      });
    } catch (e) {}
  }
}
