import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

//Access Token With My Account in MapBox.com
final String accessToken = "pk.eyJ1Ijoic2FkZWdoYjk3IiwiYSI6ImNqeWoyMnE0eTBnb24zYm8yY25mMjQyZDMifQ.eW-Dg8xveBj1_RJW7d-lIw";

class FlutterMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map For Alternative',
      home: MapBody(),
    );
  }
}

class MapBody extends StatefulWidget {
  @override
  State<MapBody> createState() => MapBodyState();
}

class MapBodyState extends State<MapBody> {
  MapController mapController = new MapController();
  static final bushehrLatLng = new LatLng(28.9234, 50.8203);
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Marker marker;
  LatLng lastSelectedLocation = bushehrLatLng;

  final locationsMap = {
    "Bushehr": bushehrLatLng,
    "PersianGulfUniversity": new LatLng(28.9084384, 50.8193873),
    "UniversityOfKashan": new LatLng(34.0136234, 51.3639472),
    "UOKBoysDormitory": new LatLng(34.0053612, 51.3666138)
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageSize = MediaQuery.of(context).size;

    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text("Flutter Google Map"),
          actions: <Widget>[
            new PopupMenuButton(
              icon: new Icon(Icons.location_city),
              itemBuilder: (context) {
                final keys = locationsMap.keys.toList();
                return [
                  for(int i=0; keys.length>i; i++) new PopupMenuItem(
                      value: keys[i],
                      child: new Text(keys[i])
                  )
                ];
              },
              onSelected: (selected){
                setState(() {
                  lastSelectedLocation = locationsMap[selected];
                  updateMarker(locationsMap[selected]);
                  mapController.move(lastSelectedLocation, 15);
                });
              },
            )
          ]
        ),
        body: new Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            new FlutterMap(
              mapController: mapController,
              options: new MapOptions(
                  center: lastSelectedLocation,
                  zoom: 15,
                  onTap: (LatLng point) {
                    print("TapPos: ${point.latitude} - ${point.longitude}");
                    setState(() => updateMarker(point));
                  }
              ),
              layers: [
                new TileLayerOptions(
                  urlTemplate: "https://api.tiles.mapbox.com/v4/"
                      "{id}/{z}/{x}/{y}@2x.png?access_token=${accessToken}",
                  additionalOptions: {
                    'accessToken': accessToken,
                    'id': 'mapbox.streets',
                  },
                ),
                new MarkerLayerOptions(
                    markers: <Marker>[
                      if(marker != null) marker
                    ]
                ),
              ],
            ),
            if(marker != null) new Container(
              height: 45,
              width: pageSize.width,
              decoration: new BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.8)
              ),
              alignment: Alignment.center,
              child: new Text(
                "${marker.point.latitude.toStringAsFixed(4)} - ${marker.point.longitude.toStringAsFixed(4)}",
                style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              ),
            )
          ]
        )
    );
  }

  updateMarker(LatLng point){
    marker = new Marker(
      point: point,
      builder: (ctx){
        return new Container(
            child: new Icon(Icons.location_on, color: Colors.redAccent, size: 40)
        );
      },
    );
  }
}