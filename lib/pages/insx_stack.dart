import 'package:flutter/material.dart';
import 'package:psinsx/pages/insx_detail_page.dart';
import 'package:psinsx/pages/insx_page.dart';

class InsxStack extends StatefulWidget {
  @override
  _InsxStackState createState() => _InsxStackState();
}

class _InsxStackState extends State<InsxStack> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'insxstack/insx',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'insxstack/insx':
            builder = (BuildContext _) => InsxPage();
            break;
          case 'insxstack/insxdetail':
            builder = (BuildContext _) => InsxDetailPage();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
