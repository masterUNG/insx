import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:psinsx/models/insx_model2.dart';
import 'package:psinsx/pages/home_page.dart';
import 'package:psinsx/utility/my_constant.dart';
import 'package:psinsx/utility/normal_dialog.dart';

class InsxEdit extends StatefulWidget {
  final InsxModel2 insxModel2;
  InsxEdit({Key key, this.insxModel2}) : super(key: key);

  @override
  _InsxEditState createState() => _InsxEditState();
}

class _InsxEditState extends State<InsxEdit> {
  InsxModel2 insxModel2;
  File file;
  String urlImage;
  Location location = Location();
  double lat, lng;

  @override
  void initState() {
    insxModel2 = widget.insxModel2;

    location.onLocationChanged.listen((event) {
      setState(() {
        lat = event.latitude;
        lng = event.longitude;
        //print('lat=== $lat, lng == $lng');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('บันทึกข้อมูล'),
      ),
      body: Column(
        children: [
          nameCus(),
          ca(),
          peaNo(),
          writeId(),
          address(),
          showLocation(),
          SizedBox(
            height: 30,
          ),
          groupImage(),
        ],
      ),
    );
  }

  Widget showLocation() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 16),
              child: Text(
                'พิกัดมือถือ:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 16),
              child: Text(
                '$lat, $lng',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ),
          ),
        ],
      );

  Widget nameCus() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 16),
              child: Text(
                'ชื่อ-นามสกุล:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 16),
              child: Text(
                '${insxModel2.cus_name}',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      );

  Widget ca() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'CA:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              '${insxModel2.ca}',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      );

  Widget peaNo() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'PEA:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              '${insxModel2.pea_no}',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      );

  Widget writeId() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'Line:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              '${insxModel2.write_id}',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      );

  Widget address() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'ที่อยู่:',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(8),
              child: Text(
                '${insxModel2.address}',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      );

  Widget groupImage() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 30,
            ),
            onPressed: () => chooseCamera(ImageSource.camera),
          ),
          Container(
            width: 160,
            height: 160,
            child: file == null
                ? Image.asset(
                    'assets/images/meter.png',
                    fit: BoxFit.cover,
                  )
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(
              Icons.no_photography,
              size: 30,
            ),
            onPressed: () => editDataInsx(insxModel2),
          ),
        ],
      );

  Future<Null> chooseCamera(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxHeight: 800,
        maxWidth: 800,
      );
      setState(() {
        file = File(object.path);
        uploadImage();
      });
    } catch (e) {}
  }

  Future<Null> uploadImage() async {
    String apiSaveFile = '${MyConstant().domain}/apipsinsx/saveFile.php';
    String fileName = 'insx${Random().nextInt(1000000)}${insxModel2.ca}.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: fileName);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveFile, data: data).then((value) {
        //print('====>>> $value');
        //print('Success url Image ==>> https://pea23.com/apipsinsx/upload/$fileName');
        urlImage = '${MyConstant().domain}/apipsinsx/upload/$fileName';
        print('=== usrlImage == $urlImage');
        editDataInsx(insxModel2);
      });
    } catch (e) {}
  }

  Future<Null> editDataInsx(InsxModel2 insxModel2) async {
    String url =
        '${MyConstant().domain}/apipsinsx/editDataWhereId.php?isAdd=true&id=${insxModel2.id}&invoice_status=ดำเนินการเสร็จสมบูรณ์&work_image=$urlImage';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
          builder: (context) => HomePage(),
        );
        Navigator.push(context, materialPageRoute);
      } else {
        normalDialog(context, 'ผิดพลาด กรุณาลองใหม่');
      }
    });
  }
}
