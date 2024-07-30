// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const _initialCameraPosition = CameraPosition(
    target: LatLng(
      11.3096241,
      77.7553,
    ),
    zoom: 50);

class Mapshow extends StatefulWidget {
  const Mapshow({super.key});

  @override
  State<Mapshow> createState() => _MapshowState();
}

class _MapshowState extends State<Mapshow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        markers: {
          Marker(
            markerId: MarkerId('marker_id'),
            position: LatLng(
              11.3096241,
              77.7553,
            ),
          ),
        },
      ),
    );
  }
}
