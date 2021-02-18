import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapInsx extends StatefulWidget {
  @override
  _MapInsxState createState() => _MapInsxState();
}

class _MapInsxState extends State<MapInsx> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          showMap(),
        ],
      ),
    );
  }

  Container showMap() {
    LatLng latLng = LatLng(16.753209, 101.203873);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    return Container(
      height: 300,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
      ),
    );
  }
}
