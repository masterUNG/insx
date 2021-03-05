import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/pages/dashbord.dart';
import 'package:psinsx/pages/help_page.dart';
import 'package:psinsx/pages/information_user.dart';
import 'package:psinsx/pages/insx_page.dart';
import 'package:psinsx/pages/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  //HomePage({Key key}) : super(key: key);
  bool statusINSx; // false => Non Back frome edit INSx
  HomePage({Key key, this.statusINSx}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nameUser, userEmail, userImge, userId;
  bool status;

  Widget currentWidget = Dashbord();

  @override
  void initState() {
    super.initState();
    status = widget.statusINSx;
    if (status != null) {
      if (status) {
        currentWidget = InsxPage();
      }
    }
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('staffname');
      userEmail = preferences.getString('user_email');
      userImge = preferences.getString('user_img');
      userId = preferences.getString('id');

    });
    print('nameUser ==== $nameUser');
    print('userImage === $userImge');
    //print('userId === $userId');
    print('userEmail === $userEmail');
  }

  Future<Null> signOutProcess() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    //exit(0);
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => SignIn());
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> signOutProcess() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      //exit(0);
      MaterialPageRoute route =
          MaterialPageRoute(builder: (context) => SignIn());
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    }

    Widget showDrawerHeader() {
      return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bird.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        currentAccountPicture: CircularProfileAvatar(
          '$userImge',
          borderWidth: 4.0,
        ),
        accountName: Text('$nameUser'),
        accountEmail: Text('$userEmail'),
      );
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            showDrawerHeader(),
            ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                subtitle: Text(
                  'หน้าหลัก',
                  style: TextStyle(fontSize: 8),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  setState(() {
                    currentWidget = Dashbord();
                  });
                  Navigator.pop(context);
                }),
            ListTile(
                leading: Icon(Icons.image_search),
                title: Text('INSx'),
                subtitle: Text(
                  'งานแจ้งเตือน',
                  style: TextStyle(fontSize: 8),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  setState(() {
                    currentWidget = InsxPage();
                  });
                  Navigator.pop(context);
                }),
            ListTile(
                leading: Icon(Icons.person_pin),
                title: Text('Information'),
                subtitle: Text(
                  'ข้อมูลส่วนตัว',
                  style: TextStyle(fontSize: 8),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  setState(() {
                    currentWidget = InformationUser();
                  });
                  Navigator.pop(context);
                }),
            ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                subtitle: Text(
                  'ช่วยเหลือ',
                  style: TextStyle(fontSize: 8),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  setState(() {
                    currentWidget = HelpPage();
                  });
                  Navigator.pop(context);
                }),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('SignOut'),
              subtitle: Text(
                'ออกจากระบบ',
                style: TextStyle(fontSize: 8),
              ),
              onTap: () => signOutProcess(),
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          toolbarHeight: 100,
     
          title: Center(
            child: Text(
              'บริษัท สดุดียี่สิบสาม จำกัด',
              //nameUser == null ? 'User' : '$nameUser login',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.red[100],
                ),
                onPressed: () {})
          ],
        ),
      ),
      body: currentWidget,
    );
  }
}
