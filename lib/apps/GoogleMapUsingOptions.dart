import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:first_flutter/general/Snackbars.dart';

class GoogleMapOptionsApp extends StatelessWidget {
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
  static final bushehrCameraPosition = new CameraPosition(
    target: LatLng(28.9234, 50.8203),
    zoom: 15,
  );

  final mapTypesMap = {
    "Normal": MapType.normal.index,
    "Satellite": MapType.satellite.index,
    "Terrain": MapType.terrain.index,
    "Hybird": MapType.hybrid.index
  };

  final locationsMap = {
    "Bushehr": bushehrCameraPosition,
    "PersianGulfUniversity": new CameraPosition(
      target: new LatLng(28.9084384, 50.8193873),
      zoom: 15
    ),
    "UniversityOfKashan": new CameraPosition(
      target: new LatLng(34.0136234, 51.3639472),
      zoom: 15
    ),
    "UOKBoysDormitory": new CameraPosition(
      target: new LatLng(34.0053612, 51.3666138),
      zoom: 16
    )
  };

  GoogleMapController mapController;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Marker marker;
  bool checkingFinished = false;
  int currentMaptype = MapType.normal.index;
  CameraPosition lastSelectedCameraPosition = bushehrCameraPosition;
  CameraPosition lastUpdatedCameraPosition;
  LatLng chosenTarget;

  @override
  void initState() {
    super.initState();
    checkLocationStatus();
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
                lastSelectedCameraPosition = locationsMap[selected];
                lastUpdatedCameraPosition = lastSelectedCameraPosition;
                mapController.animateCamera(
                    CameraUpdate.newCameraPosition(lastSelectedCameraPosition)
                );
              },
            ),
            new PopupMenuButton(
                icon: new Icon(Icons.style),
                itemBuilder: (context){
                  final keys = mapTypesMap.keys.toList();
                  final values = mapTypesMap.values.toList();
                  return [
                    for(int i=0; mapTypesMap.length>i; i++) new PopupMenuItem(
                        value: values[i],
                        child: new Text(keys[i])
                    )
                  ];
                },
                onSelected: (selected) => setState(() => currentMaptype = selected)
            )
          ]
        ),
        body: !checkingFinished ? new Center(child: new CircularProgressIndicator()) : new Stack(
          children: <Widget>[
            new GoogleMap(
              initialCameraPosition: lastSelectedCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                lastUpdatedCameraPosition = lastSelectedCameraPosition;
              },
              onCameraMove: (cameraPosition) {
                lastUpdatedCameraPosition = cameraPosition;
                if(marker != null) setState(updateMarker);
              },
              markers: Set<Marker>.of([if(marker != null) marker]),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.values[currentMaptype]
            ),
            new Align(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: new FloatingActionButton(
                              onPressed: (){
                                Navigator.pushReplacement(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new GoogleMapOptionsApp()
                                    )
                                );
                              },
                              child: new Icon(Icons.refresh)
                          )
                      ),
                      new Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: new FloatingActionButton(
                              onPressed: (){
                                setState(updateMarker);
                              },
                              child: new Icon(Icons.add_location)
                          )
                      ),
                      if(marker != null) new Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: new FloatingActionButton(
                              onPressed: (){
                                setState((){
                                  marker = null;
                                  chosenTarget = null;
                                });
                              },
                              child: new Icon(Icons.remove_circle_outline)
                          )
                      ),
                      if(marker != null) new Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: new FloatingActionButton(
                              onPressed: () => setState(() => chosenTarget = marker.position),
                              child: new Icon(Icons.flag)
                          )
                      )
                    ]
                  ),
                  new Padding(
                    padding: EdgeInsets.symmetric(vertical: 4)
                  ),
                  if(chosenTarget != null) new Container(
                    height: 45,
                    width: pageSize.width,
                    decoration: new BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.8)
                    ),
                    alignment: Alignment.center,
                    child: new Text(
                      "${chosenTarget.latitude.toStringAsFixed(4)} - ${chosenTarget.longitude.toStringAsFixed(4)}",
                      style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                  )
                ]
              ),
              alignment: Alignment.bottomCenter
            )
          ]
        )
    );

  }

  checkLocationStatus(){
    PermissionHandler permissionHandler = new PermissionHandler();
    permissionHandler.checkServiceStatus(PermissionGroup.location).then((serviceStatus) async {
      if(serviceStatus.value == ServiceStatus.disabled.value){
        showSnackbar(
            scaffoldKey,
            "Location is unavailable!",
            Icons.location_off,
            backgroundColor: Colors.redAccent,
            duration: new Duration(hours: 1),
            onTap: (){
              scaffoldKey.currentState.hideCurrentSnackBar();
              checkLocationStatus();
            }
        );
      }
      else {
        PermissionStatus permissionStatus =
        await permissionHandler.checkPermissionStatus(PermissionGroup.location);

        if(permissionStatus.value == PermissionStatus.denied.value){
          Map<PermissionGroup, PermissionStatus> permissions =
          await permissionHandler.requestPermissions([PermissionGroup.location]);

          if(permissions[PermissionGroup.location].value == PermissionStatus.granted.value) {
            print("Yuuuup Granted!");
          }
        }
      }
      setState(() => checkingFinished = true);
    });
  }

  updateMarker(){
    /*mapController.animateCamera(
      CameraUpdate.newCameraPosition(lastUpdatedCameraPosition)
    );*/
    marker = new Marker(
      markerId: new MarkerId("marker_id"),
      draggable: false,
      position: lastUpdatedCameraPosition.target,
    );
  }
}