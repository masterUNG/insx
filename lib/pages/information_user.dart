import 'package:flutter/material.dart';
import 'package:psinsx/pages/add_information_user.dart';

class InformationUser extends StatefulWidget {
  @override
  _InformationUserState createState() => _InformationUserState();
}

class _InformationUserState extends State<InformationUser> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: Text('ข้อมูลพนักงาน')),
        editButton(),
      ],
    );
  }

  Row editButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16, bottom: 16),
              child: FloatingActionButton(
                  child: Icon(Icons.edit),
                  onPressed: () {
                    MaterialPageRoute materialPageRoute = MaterialPageRoute(
                      builder: (context) => AddInformationUser(),
                    );
                    Navigator.push(context, materialPageRoute);
                  }),
            ),
          ],
        ),
      ],
    );
  }
}
