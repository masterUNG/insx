import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psinsx/models/insx_model2.dart';

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
    // TODO: implement initState
    super.initState();
    insxModel2s = widget.insxModel2s;
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
        infoWindow: InfoWindow(title: item.cus_name, snippet: item.pea_no),
      );
      markers.add(marker);
    }
    return markers.toSet();
  }

  double calculageHues(String notidate) {
    List<double> hues = [80.0, 60.0, 150.0, 20.0];
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
      appBar: AppBar(),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: startMapLatLng,
          zoom: 6,
        ),
        mapType: MapType.normal,
        onMapCreated: (controller) => {},
        markers: myAllMarker(),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
      ),
    );
  }
}
