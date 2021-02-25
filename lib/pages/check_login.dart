import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info/package_info.dart';
import 'package:psinsx/pages/signin_page.dart';
import 'package:psinsx/pages/version_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class CheckLogin extends StatefulWidget {
  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  @override
  void initState() {
    super.initState();
    checkPreferance();
    //checkVersion();
    //checkNewVersion();
    //checkBuildNumber();
  }

  Future<Null> checkBuildNumber() async {
    await PackageInfo.fromPlatform().then((value) {
      String buildNumber = value.buildNumber;
      print('buildNumber +++++ $buildNumber');
    });
  }

  Future<Null> checkNewVersion() async {
    NewVersion newVersion = await NewVersion(
      context: context,
      iOSId: 'pea23.com.psinsx',
      androidId: 'pea23.com.psinsx',
    ).showAlertIfNecessary();
    print('>>>>>>>>>>> version ${newVersion.getVersionStatus()}');
  }

  Future checkVersion() async {
    String version = '';
    String storeVersion = '';
    String storeUrl = '';
    String packageName = '';

    final versionCheck = VersionCheck(
      packageName: Platform.isIOS ? 'pea23.com.psinsx' : 'pea23.com.psinsx',
      packageVersion: '1.0.1',
      //showUpdateDialog: customShowUpdateDialog,
    );

    await versionCheck.checkVersion(context);
    setState(() {
      version = versionCheck.packageVersion;
      packageName = versionCheck.packageName;
      storeVersion = versionCheck.storeVersion;
      storeUrl = versionCheck.storeUrl;

      print('=====>>>> \n version $version \n packageName $packageName');
    });
  }

  void customShowUpdateDialog(BuildContext context, VersionCheck versionCheck) {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        title: Text('NEW Update Available'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Do you REALLY want to update to ${versionCheck.storeVersion}?'),
              Text('(current version ${versionCheck.packageVersion})'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Update'),
            onPressed: () async {
              await versionCheck.launchStore();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<Null> checkPreferance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String string = preferences.getString('id');
      if (string != null && string.isNotEmpty) {
        MaterialPageRoute route =
            MaterialPageRoute(builder: (context) => HomePage());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      } else {
        MaterialPageRoute route =
            MaterialPageRoute(builder: (context) => SignIn());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //MyStyle().showLogo(),
            ],
          ),
        ),
      ),
    );
  }
}
