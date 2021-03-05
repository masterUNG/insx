import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psinsx/models/insx_model2.dart';
import 'package:psinsx/pages/insx_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapInsx extends StatefulWidget {
  final List<InsxModel2> insxModel2s;
  MapInsx({@required this.insxModel2s});

  @override
  _MapInsxState createState() => _MapInsxState();
}

class _MapInsxState extends State<MapInsx> {
  List<InsxModel2> insxModel2s;

  LatLng startMapLatLng = LatLng(16.753188, 101.203616);

  @override
  void initState() {
    super.initState();
    insxModel2s = widget.insxModel2s;
  }

  Future<Null> myReadAPI() async {
    print('myReadAPI work ===:>>>');
    insxModel2s.clear();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String workername = preferences.getString('staffname');

    String url =
        'https://pea23.com/apipsinsx/getInsxWhereUser.php?isAdd=true&worker_name=$workername';

    await Dio().get(url).then((value) {
      for (var item in json.decode(value.data)) {
        InsxModel2 model2 = InsxModel2.fromMap(item);
        insxModel2s.add(model2);
      }
      setState(() {
        myAllMarker();
      });
    });
  }

  Set<Marker> myAllMarker() {
    List<Marker> markers = List();
    List<double> hues = [80.0, 60.0, 150.0, 20.0];
    for (var item in insxModel2s) {
      Marker marker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(
            calculageHues(item.noti_date)),
        markerId: MarkerId('id${item.id}'),
        position: LatLng(double.parse(item.lat), double.parse(item.lng)),
        infoWindow: InfoWindow(
          title: item.cus_name,
          snippet: 'pea: ${item.pea_no}',
          onTap: () {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => InsxEdit(
                insxModel2: item,
                fromMap: true,
              ),
            );
            Navigator.push(context, route).then(
              (value) {
                //print('Back Form insx');
                myReadAPI();
              },
            );
          },
        ),
      );
      markers.add(marker);
    }
    return markers.toSet();
  }

  double calculageHues(String notidate) {
    List<double> hues = [80.0, 60.0, 200.0, 20.0];
    List<String> strings = notidate.split(" ");
    List<String> dateTimeInts = strings[0].split('-');
    DateTime notiDateTime = DateTime(
      int.parse(dateTimeInts[0]),
      int.parse(dateTimeInts[1]),
      int.parse(dateTimeInts[2]),
    );

    DateTime currentDateTime = DateTime.now();
    int diferDate = currentDateTime.difference(notiDateTime).inDays;
    double result = hues[0];

    if (diferDate >= 7) {
      result = hues[3];
    } else if (diferDate >= 4) {
      result = hues[2];
    } else if (diferDate >= 2) {
      result = hues[1];
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          toolbarHeight: 100,
          title: Center(
            child: Text(
              insxModel2s.length == 0
                  ? 'ข้อมูล : ? รายการ'
                  : 'ข้อมูล : ${insxModel2s.length} รายการ',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
      body: insxModel2s.length == 0 ? buildSecondMap() : buildMainMap(),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.purple,
      //   onPressed: () async {
      //     await LaunchApp.openApp(
      //       androidPackageName: 'com.pea.INSx',
      //     );
      //   },
      //   child: Text('PEA'),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // backgroundColor: Colors.purple,
      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.white,
      // ),
    );
  }

  GoogleMap buildMainMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: startMapLatLng,
        zoom: 6,
      ),
      mapType: MapType.normal,
      onMapCreated: (controller) => {},
      markers: myAllMarker(),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
    );
  }

  GoogleMap buildSecondMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: startMapLatLng,
        zoom: 6,
      ),
      mapType: MapType.normal,
      onMapCreated: (controller) => {},
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
    );
  }

  Future<Null> confirmDialog(InsxModel2 insxModel2) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Icon(
            Icons.pin_drop,
            size: 36,
          ),
          title: Text(
            insxModel2.cus_name,
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(insxModel2.pea_no, style: TextStyle(fontSize: 14)),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'เกิน 300 เมตร ให้ถ่ายภาพมิเตอร์',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    //chooseCamera(index);
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
}
