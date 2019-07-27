import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:first_flutter/general/Snackbars.dart';
import 'package:first_flutter/general/ViewMediaScreen.dart';

class CameraWithPlayMediaApp extends StatelessWidget {
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
  String recordingVideoFilePath;
  List<Map> takenFiles = new List<Map>();
  int lastShowingPreviewsTime = 0;
  bool showingPreviews = false;
  final showingPreviewsDurationSeconds = 12;

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
        if(cameraController.value.errorDescription == "The camera device is in use already."){
          //because bug in camera library in android 6
          selectCamera(selectedCameraDescription);
        }
        else {
          showSnackbar(
            scaffoldKey,
            cameraController.value.errorDescription,
            Icons.error,
            direction: TextDirection.ltr
          );
          print("CameraExListener: ${cameraController.value.errorDescription}");
          setState(() {});
        }
      }
    });

    try {
      cameraController.initialize().then((nullResult){
        setState(() {});
      });
    }
    on CameraException catch(e) {
      cameraExceptionOnSnackbar(e, description: "CameraExControllerInit");
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
    return new Center(
      child: AspectRatio(
        aspectRatio: cameraController.value.aspectRatio ,
        child: new CameraPreview(cameraController),
      ),
    );
  }

  Widget getCameraControlWidgets(){
    final screenSize = MediaQuery.of(context).size;

    return new Align(
      alignment: Alignment.bottomCenter,
      child: new Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
             showingPreviews ? new Padding(
              padding : EdgeInsetsDirectional.only(bottom: 10, start: 5),
              child: new SizedBox(
                width: screenSize.width,
                height: 60,
                child: new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: takenFiles.length,
                  reverse: false,
                  itemBuilder: (BuildContext context, int index) {
                    Map file = takenFiles[takenFiles.length - 1 - index];
                    String type = file['type'];

                    return new GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new ViewMediaScreen(file: file)
                          )
                        );
                      },
                      child: new Padding(
                        padding: const EdgeInsetsDirectional.only(end: 5),
                        child: new SizedBox(
                          width: 70,
                          child: new Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Image.file(new File(file['thumb']), fit: BoxFit.cover),
                              type == 'video' ? new Align(
                                alignment: Alignment.bottomLeft,
                                child: new Padding(
                                  padding: EdgeInsets.only(left: 2 , bottom: 2),
                                  child : Icon(Icons.camera_alt , size: 18 , color: Colors.white)
                                )
                              ) : new SizedBox()
                            ]
                          )
                        )
                      )
                    );
                  }
                ),
              ),
            ) : new SizedBox(),
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
                    if(takenPicPath == null) return;
                    String takenPicName = takenPicPath.substring(
                      takenPicPath.lastIndexOf("/") + 1
                    );
                    showSnackbar(
                      scaffoldKey,
                      takenPicName,
                      Icons.image,
                      direction: TextDirection.ltr,
                      duration: new Duration(seconds: 2),
                      hideCurrentSnackbar: true
                    );

                    final Directory tempDir = await getTemporaryDirectory();
                    final thumbsTempDir = tempDir.path + "/camera";
                    final targetThumbPath =
                        thumbsTempDir + "/${DateTime.now().millisecondsSinceEpoch}.jpg";

                    final thumbFile = await FlutterImageCompress.compressAndGetFile(
                      new File(takenPicPath).absolute.path, targetThumbPath,
                      format: CompressFormat.jpeg,
                      minHeight: 180,
                      minWidth: 180,
                      quality: 60
                    );

                    setState(() {
                      takenFiles.add({
                        'type': 'image',
                        'image_path': takenPicPath,
                        'thumb': thumbFile.path
                      });
                      showPreviews();
                    });
                  },
                  onLongPress: () async {
                    await startVideoRecording();
                    setState(() {});
                  },
                  onLongPressUp: () async {
                    String takenVidPath = await stopVideoRecording();
                    if(takenVidPath == null){
                      setState(() {});
                      return;
                    }
                    String takenVidName = takenVidPath.substring(
                      takenVidPath.lastIndexOf("/") + 1
                    );
                    showSnackbar(
                      scaffoldKey,
                      takenVidName,
                      Icons.videocam,
                      direction: TextDirection.ltr,
                        duration: new Duration(seconds: 2),
                      hideCurrentSnackbar: true
                    );

                    final Directory tempDir = await getTemporaryDirectory();
                    final thumbsTempDir = tempDir.path + "/camera";

                    String thumbFile = await Thumbnails.getThumbnail(
                      videoFile: takenVidPath,
                      thumbnailFolder: thumbsTempDir,
                      imageType: ThumbFormat.JPEG,
                      quality: 50
                    );

                    setState(() {
                      takenFiles.add({
                        'type': 'video',
                        'video_path': takenVidPath,
                        'thumb': thumbFile
                      });
                      showPreviews();
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
                  icon: new Icon(Icons.camera, size: 36, color: Colors.white),
                  onPressed: showPreviews
                )
              ],
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 10),
              child: new Text('نگه دارید فیلم بگیرید، بزنید تا عکس بگیرید' , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  void showPreviews(){
    lastShowingPreviewsTime = DateTime.now().millisecondsSinceEpoch;
    setState(() => showingPreviews = true);
    new Future.delayed(new Duration(seconds: showingPreviewsDurationSeconds)).then((nullResult){
      int now = DateTime.now().millisecondsSinceEpoch;
      if((now - lastShowingPreviewsTime) > (showingPreviewsDurationSeconds * 1000 - 500))
        setState(() => showingPreviews = false);
    });
  }

  void cameraSwitch(){
    if(cameras.length >= 2) {
      selectCamera(selectedCameraDescription == cameras[0] ? cameras[1] : cameras[0]);
    }
    else {
      showSnackbar(
        scaffoldKey,
        'شما قادر به تغییر دوربین نیستید !',
        Icons.info,
        duration: new Duration(seconds: 2)
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
      cameraExceptionOnSnackbar(e, description: "CameraExTakePicture");
      return null;
    }
  }

  Future<void> startVideoRecording() async {
    if(cameraController.value.isRecordingVideo) return;

    final Directory extDir = await getExternalStorageDirectory();
    final String dirPath = '${extDir.path}/Movies/FirstFlutter';
    await Directory(dirPath).create(recursive: true);
    int now = DateTime.now().millisecondsSinceEpoch;
    final filePath = '$dirPath/$now.mp4';

    try {
      await cameraController.startVideoRecording(filePath);
      recordingVideoFilePath = filePath;
    }
    on CameraException catch (e) {
      cameraExceptionOnSnackbar(e, description: "CameraExStartVideRecording");
    }
  }

  Future<String> stopVideoRecording() async {
    if(!cameraController.value.isRecordingVideo) return null;
    String tempVidPath = recordingVideoFilePath;

    try {
      await cameraController.stopVideoRecording();
      recordingVideoFilePath = null;
      return tempVidPath;
    }
    on CameraException catch (e) {
      if(e.description == "The camera device has encountered a serious error"){
        //because bug in camera library in android 6
        recordingVideoFilePath = null;
        return tempVidPath;
      }
      cameraExceptionOnSnackbar(e, description: "CameraExStopVideoRecording");
    }

    return null;
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

  cameraExceptionOnSnackbar(CameraException e, {String description = null}){
    showSnackbar(
      scaffoldKey,
      e.description,
      Icons.error_outline,
      direction: TextDirection.ltr
    );

    if(description != null) print('$description: ${e.code}\nErrorMessage : ${e.description}');
  }
}