import 'package:flutter/material.dart';
import 'package:psinsx/pages/about_page.dart';
import 'package:psinsx/pages/contact_page.dart';
import 'package:psinsx/pages/home_page.dart';

class HomeStack extends StatefulWidget {
  @override
  _HomeStackState createState() => _HomeStackState();
}

class _HomeStackState extends State<HomeStack> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'homestack/home',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'homestack/home':
            builder = (BuildContext _) => HomePage();
            break;
          case 'homestack/about':
            builder = (BuildContext _) => AboutPage();
            break;
          case 'homestack/contact':
            builder = (BuildContext _) => ContactPage();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
