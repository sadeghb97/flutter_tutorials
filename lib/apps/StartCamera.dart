import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:first_flutter/general/Snackbars.dart';

class FirstCameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "My Camera",
        theme: new ThemeData(
            fontFamily: "Vazir",
            primaryColor: Color(0xff075e54),
            accentColor: Color(0xff25d366),
            primaryIconTheme: new IconThemeData(color: Colors.white)
        ),
        home: new Directionality(textDirection: TextDirection.rtl, child: new CameraAppBody())
    );
  }
}

class CameraAppBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CameraAppBodyState();
}

class CameraAppBodyState extends State<CameraAppBody>{
  CameraController cameraController;
  CameraDescription selectedCameraDescription;
  List<CameraDescription> cameras;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool checkingStoragePermission = true;
  List<Map> takenFiles = new List<Map>();

  @override
  void initState() {
    super.initState();
    checkPermissions();
    initCamera();
  }

  initCamera() async {
    cameras = await availableCameras();
    selectCamera(cameras[0]);
  }

  selectCamera(CameraDescription cameraDescription) async {
    setState(() {
      cameraController = null;
    });

    cameraController = new CameraController(cameraDescription , ResolutionPreset.high);
    selectedCameraDescription = cameraDescription;

    cameraController.addListener(() {
      if(cameraController.value.hasError) {
        showSnackbar(
          scaffoldKey,
          cameraController.value.errorDescription,
          Icons.error,
          direction: TextDirection.ltr
        );
      }
    });

    try {
      cameraController.initialize().then((nullResult){
        setState(() {});
      });
    }
    on CameraException catch(e) {
      showSnackbar(
        scaffoldKey,
        e.description,
        Icons.error_outline,
        direction: TextDirection.ltr
      );
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      body: checkingStoragePermission || cameraController == null || !cameraController.value.isInitialized
        ? new Center(child: new CircularProgressIndicator())
        : new Stack(
          children: <Widget>[
            cameraController.value.hasError
              ? new Container(
                child: new Center(
                  child: new Text(
                    "مشکلی پیش آمده است",
                    style: new TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    )
                  )
                ),
                color: Colors.black45,
              )
              : getCameraViewWidget(),
            getCameraControlWidgets()
          ]
        )
    );
  }

  Widget getCameraViewWidget(){
    return new Transform.scale(
      scale: 1 / cameraController.value.aspectRatio ,
      child: Center(
        child: AspectRatio(
          aspectRatio: cameraController.value.aspectRatio ,
          child: new CameraPreview(cameraController),
        ),
      ),
    );
  }

  Widget getCameraControlWidgets(){
    return new Align(
      alignment: Alignment.bottomCenter,
      child: new Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.switch_camera, size: 36, color: Colors.white),
                  onPressed: cameraSwitch
                ),
                new GestureDetector(
                  onTap: () async {
                    String takenPicPath = await takePicture();
                    String takenPicName = takenPicPath.substring(
                      takenPicPath.lastIndexOf("/") + 1
                    );
                    showSnackbar(
                      scaffoldKey,
                      takenPicName,
                      Icons.image,
                      direction: TextDirection.ltr
                    );

                    takenFiles.add({
                      'type': 'image',
                      'path': takenPicPath
                    });
                  },
                  child: new Container(
                    width: 65,
                    height: 65,
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      border: new Border.all(
                        width: 4,
                        color : cameraController != null && cameraController.value.isRecordingVideo
                          ? Colors.redAccent
                          : Colors.white
                      ),
                      shape: BoxShape.circle
                    ),
                    child: new Icon(Icons.fiber_manual_record, color:Colors.white)
                  )
                ),
                new IconButton(
                    icon: new Icon(Icons.flash_off , size: 36 , color: Colors.white ),
                    onPressed: () {}
                )
              ],
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 16),
              child: new Text('نگه دارید فیلم بگیرید، بزنید تا عکس بگیرید' , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  void cameraSwitch(){
    if(cameras.length >= 2) {
      selectCamera(selectedCameraDescription == cameras[0] ? cameras[1] : cameras[0]);
    }
    else {
      showSnackbar(
        scaffoldKey,
        'شما قادر به تغییر دوربین نیستید !',
        Icons.info
      );
    }
  }

  Future<String> takePicture() async {
    final Directory extDir = await getExternalStorageDirectory();
    final String dirPath = '${extDir.path}/Pictures/FirstFlutter';
    await Directory(dirPath).create(recursive: true);
    int now = DateTime.now().millisecondsSinceEpoch;
    final filePath = '$dirPath/$now.jpg';

    try {
      await cameraController.takePicture(filePath);
      return filePath;
    }
    on CameraException catch(e) {
      showSnackbar(
        scaffoldKey,
        e.description,
        Icons.error_outline,
        direction: TextDirection.ltr
      );
      return null;
    }
  }

  checkPermissions() async {
    PermissionHandler permissionHandler = new PermissionHandler();

    PermissionStatus storagePermissionStatus =
      await permissionHandler.checkPermissionStatus(PermissionGroup.storage);

    PermissionStatus cameraPermissionStatus =
      await permissionHandler.checkPermissionStatus(PermissionGroup.camera);

    PermissionStatus microphonePermissionStatus =
      await permissionHandler.checkPermissionStatus(PermissionGroup.microphone);

    if(storagePermissionStatus.value == PermissionStatus.denied.value ||
      cameraPermissionStatus.value == PermissionStatus.denied.value ||
      microphonePermissionStatus.value == PermissionStatus.denied.value){

      List<PermissionGroup> deniedPermissions = new List<PermissionGroup>();
      if(storagePermissionStatus.value == PermissionStatus.denied.value)
        deniedPermissions.add(PermissionGroup.storage);

      if(cameraPermissionStatus.value == PermissionStatus.denied.value)
        deniedPermissions.add(PermissionGroup.camera);

      if(microphonePermissionStatus.value == PermissionStatus.denied.value)
        deniedPermissions.add(PermissionGroup.microphone);

      Map<PermissionGroup, PermissionStatus> permissions =
          await permissionHandler.requestPermissions(deniedPermissions);

      if(permissions[PermissionGroup.storage].value == PermissionStatus.granted.value)
        print("Yup Storage Granted!");

      if(permissions[PermissionGroup.camera].value == PermissionStatus.granted.value)
        print("Yup Camera Granted!");

      if(permissions[PermissionGroup.microphone].value == PermissionStatus.granted.value)
        print("Yup Microphone Granted!");
    }

    setState(() => checkingStoragePermission = false);
  }
}