import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:psinsx/models/data_location_model.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<DataLocationModel> dataLocationModels = [];
  List<DataLocationModel> filterDataLocationModels = List();
  final debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    readAllData();
  }

  Future<Null> readAllData() async {
    String url = 'https://pea23.com/apipsinsx/getAllDataLocation.php';

    Response response = await get(url);
    var result = json.decode(response.body);
    print('result ====>>> $result');
    for (var map in result) {
      DataLocationModel dataLocationModel = DataLocationModel.fromJson(map);
      print('name ====>>> ${dataLocationModel.ca}');
      setState(() {
        dataLocationModels.add(dataLocationModel);
        filterDataLocationModels = dataLocationModels;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ค้นหา'),
        ),
        body: Column(
          children: [
            searchText(),
            showListView(),
          ],
        ));
  }

  Widget searchText() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'กรอกชื่อ'),
        onChanged: (value) {
          debouncer.run(() {
            setState(() {
              filterDataLocationModels = dataLocationModels
                  .where((u) =>
                      (u.cusName.toLowerCase().contains(value.toLowerCase())))
                  .toList();
            });
          });
        },
      ),
    );
  }

  Widget showListView() {
    return Expanded(
      child: ListView.builder(
          itemCount: filterDataLocationModels.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                print('clik.... ${filterDataLocationModels[index].ptcInsx}');
              },
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text(filterDataLocationModels[index].ca),
                  subtitle: Text(
                    filterDataLocationModels[index].cusName,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
