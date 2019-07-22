import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirstGoogleMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapBody(),
    );
  }
}

class MapBody extends StatefulWidget {
  @override
  State<MapBody> createState() => MapBodyState();
}

class MapBodyState extends State<MapBody> {
  final bushehrCameraPosition = new CameraPosition(
    target: LatLng(28.9234, 50.8203),
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Google Map"),
      ),
      body: new GoogleMap(
        initialCameraPosition: bushehrCameraPosition,
        onMapCreated: (GoogleMapController controller) {},
      )
    );
  }
}