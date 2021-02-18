import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashbord extends StatefulWidget {
  Dashbord({Key key}) : super(key: key);

  @override
  _DashbordState createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  String nameUser;

  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('staffname');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 2,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 80,
                            color: Colors.red,
                          ),
                          Text(
                            'ค้นหา',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      color: Colors.red[100]),
                  Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.red,
                          ),
                          Text(
                            'ส่วนตัว',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      color: Colors.red[100]),
                  Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.report,
                            size: 80,
                            color: Colors.red,
                          ),
                          Text(
                            'รายงาน',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      color: Colors.red[100]),
                  Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dashboard_customize,
                            size: 80,
                            color: Colors.red,
                          ),
                          Text(
                            'เอกสาร',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      color: Colors.red[100]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
