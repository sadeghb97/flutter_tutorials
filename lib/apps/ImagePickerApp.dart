import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ImagePickerApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Image Picker",
        theme: new ThemeData(
            fontFamily: "Vazir"
        ),
        home: new Directionality(
            textDirection: TextDirection.rtl,
            child: new ImagePickerBody()
        )
    );
  }
}

class ImagePickerBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ImagePickerBodyState();
}

class ImagePickerBodyState extends State<ImagePickerBody> {
  VideoPlayerController videoPlayerController;
  File imageFile;
  bool firstLoad = true;
  bool isImage = true;
  bool fullScreenMode = true;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs){
      if(prefs.containsKey("image_picker_app_full_screen"))
        setState(() => fullScreenMode = prefs.getBool("image_picker_app_full_screen"));
    });
  }

  @override
  void dispose() {
    if(videoPlayerController != null) {
      videoPlayerController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('مدیا لودر'),
          actions: <Widget>[
            new PopupMenuButton<String>(
              itemBuilder: (context){
                return [
                  new PopupMenuItem(
                    value: "toggle_mode",
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        fullScreenMode ? new Icon(Icons.check_box)
                          : new Icon(Icons.check_box_outline_blank),
                        new Text("فول اسکرین"),
                      ],
                    )
                  )
                ];
              },
              onSelected: (selected){
                if(selected == "toggle_mode") {
                  SharedPreferences.getInstance().then((prefs){
                    prefs.setBool("image_picker_app_full_screen", !fullScreenMode);
                  });
                  setState(() => fullScreenMode = !fullScreenMode);
                }
              }
            )
          ]
      ),
      body: Center(
          child: isImage ? getImageWidget() : getVideoWidget(context)
      ),
      floatingActionButton: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              pickMedia(ImageSource.gallery, true);
            },
            child: Icon(Icons.photo_library),
          ),
          new SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              pickMedia(ImageSource.camera, true);
            },
            child: Icon(Icons.camera_alt),
          ),
          new SizedBox(height: 16),
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              pickMedia(ImageSource.gallery, false);
            },
            child: Icon(Icons.video_library),
          ),
          new SizedBox(height: 16),
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              pickMedia(ImageSource.camera, false);
            },
            child: Icon(Icons.videocam),
          ),
        ],
      ),
    );
  }

  pickMedia(ImageSource source, bool isImageType){
    if(videoPlayerController != null) {
      videoPlayerController.pause();
    }
    if(!isImageType) {
      ImagePicker.pickVideo(source: source).then((File file) {
        if (file != null) {
          videoPlayerController = VideoPlayerController.file(file)
            ..addListener(() => setState((){}))
            ..initialize()
            ..setLooping(true)
            ..play();

          isImage = false;
          firstLoad = false;
          if(mounted) setState(() {});
        }
      });
    }
    else {
      ImagePicker.pickImage(source: source).then((file){
        if(file != null) {
          isImage = true;
          firstLoad = false;
          setState(() => imageFile = file);
        }
      });
    }
  }

  getImageWidget(){
    if(firstLoad) return new Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Expanded(
          child: new Image.asset("assets/images/nice_wallpaper.jpg", fit: BoxFit.cover)
        )
      ]
    );
    if(imageFile == null) return new Text(
      "تصویری لود نشده است!",
      textAlign: TextAlign.center
    );

    if(fullScreenMode) return new Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Expanded(
          child: new Image.file(imageFile, fit: BoxFit.cover)
        )
      ]
    );

    return new Image.file(imageFile, fit: BoxFit.cover);
  }

  getVideoWidget(BuildContext context){
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height - AppBar().preferredSize.height;
    final screenWidth = screenSize.width;
    final double fullScreenScale = videoPlayerController.value.aspectRatio > 1
        ? screenHeight / (screenWidth / videoPlayerController.value.aspectRatio)
        : screenWidth / (screenHeight * videoPlayerController.value.aspectRatio);
    print("AspectRatio: ${videoPlayerController.value.aspectRatio}");

    if(videoPlayerController == null) return new Text(
      "ویدیویی لود نشده است!",
      textAlign: TextAlign.center
    );
    if(videoPlayerController.value.hasError) return new Text(
      "لود ویدیو با مشکل مواجه شده است!",
      textAlign: TextAlign.center
    );
    if(videoPlayerController.value.initialized) return new GestureDetector(
      child: new Transform.scale(
        scale: fullScreenMode ? fullScreenScale : 1,
        child: new AspectRatio(
          aspectRatio: videoPlayerController.value.aspectRatio,
          child: VideoPlayer(videoPlayerController)
        )
      ),
      onTap: (){
        if(videoPlayerController.value.isPlaying) videoPlayerController.pause();
        else videoPlayerController.play();
      },
    );

    return new Text(
        "ویدیویی لود نشده است!",
        textAlign: TextAlign.center
    );
  }
}