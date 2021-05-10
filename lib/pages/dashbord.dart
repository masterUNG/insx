import 'package:flutter/material.dart';
import 'package:psinsx/pages/doc_page.dart';
import 'package:psinsx/pages/insx_page.dart';
import 'package:psinsx/pages/map.dart';
import 'package:psinsx/pages/oil_page.dart';
import 'package:psinsx/pages/report_page.dart';
import 'package:psinsx/pages/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: Stack(
        children: [
          MyMap(),
          Positioned(
            top: 10,
            left: 10,
            child: showLoadData(),
          ),
          Positioned(
            top: 75,
            left: 10,
            child: showReport(),
          ),
          Positioned(
            top: 140,
            left: 10,
            child: showSearchDataLocation(context),
          ),

        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   elevation: 0.0,
      //   onPressed: () => Navigator.pushNamed(context, '/insxPage'),
      // ),
    );
  }

  Container buildContent(BuildContext context) {
    return Container(
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
                //showLoadData(),
                //showSearchDataLocation(context),
                //showReport(),
                //showDocuments(),
                //showValueOil(),
              ],
            ),
          ),
        ],
      ),
    );
  }

 

  Widget showValueOil() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OilPage()));
      },
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pedal_bike,
                size: 80,
                color: Colors.red,
              ),
              Text(
                'เติมน้ำมัน',
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              )
            ],
          ),
          color: Colors.red[100]),
    );
  }

  Future<Null> launchURL() async {
    const url = 'https://pea23.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget showDocuments() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DocPage()));
      },
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.dashboard_customize,
                size: 40,
                color: Colors.red,
              ),
            ],
          ),
          color: Colors.red[100]),
    );
  }

  Widget showReport() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ReportPage()));
      },
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_outlined,
                size: 40,
                color: Colors.red,
              ),
            ],
          ),
          color: Colors.red[100]),
    );
  }

  Widget showSearchDataLocation(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SearchPage()));
      },
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 40,
                color: Colors.red,
              ),
            ],
          ),
          color: Colors.red[100]),
    );
  }

  Widget showLoadData() {
    return GestureDetector(
      onTap: launchURL,
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.download_sharp,
                size: 40,
                color: Colors.red,
              ),
           
            ],
          ),
          color: Colors.red[100]),
    );
  }
}
