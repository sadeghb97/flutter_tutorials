import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ViewMediaScreen extends StatefulWidget {
  final Map file;
  ViewMediaScreen({@required this.file});

  @override
  State<StatefulWidget> createState() => new ViewMediaScreenState();
}

class ViewMediaScreenState extends State<ViewMediaScreen> {
  VideoPlayerController videoPlayerController;
  int lastControlsAppearTime = 0;
  bool controlsActive = false;
  final controlsActivePeriod = 10;

  @override
  void initState() {
    super.initState();
    print("videoPath: ${widget.file['video_path']}");
    print("thumb: ${widget.file['thumb']}");

    if(widget.file['type'] == 'video') {
      videoPlayerController = VideoPlayerController.file(File(widget.file['video_path']));

      videoPlayerController.addListener(() async {
        if(videoPlayerController.value.position >= videoPlayerController.value.duration) {
          await videoPlayerController.seekTo(new Duration(milliseconds: 0));
          await videoPlayerController.pause();
        }

        //in dar har setState false mishavad bad az har setState hargah meghdari dar
        //video controller [ya ehtemalan baghie motheghayyer ha taghir konad]
        //mounted true mishavad
        if(mounted) setState((){});
      });

      videoPlayerController.initialize().then((_){
        setState(() => showControls());
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: widget.file['type'] == 'image'
            ? getImageWidget()
            : getVideoWidget()
        ),
      )
    );
  }

  getImageWidget() {
    return new Image.file(File(widget.file['image_path']) , fit: BoxFit.cover);
  }

  getVideoWidget() {
    return videoPlayerController != null && videoPlayerController.value.initialized ? new Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        new GestureDetector(
          child: new AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: VideoPlayer(videoPlayerController),
          ),
          onTap: showControls,
        ),
        controlsActive ? new Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: new IconButton(
                  icon: Icon(
                    videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 60,
                    color: Colors.white
                  ),
                  onPressed: () async {
                    if(videoPlayerController.value.isPlaying)
                      await videoPlayerController.pause();
                    else await videoPlayerController.play();
                  }
                )
              ),
              new Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: new IconButton(
                  icon: Icon(
                    Icons.stop,
                    size: 60,
                    color: Colors.white
                  ),
                  onPressed: () async {
                    await videoPlayerController.pause();
                    await videoPlayerController.seekTo(new Duration(milliseconds: 0));
                  }
                )
              )
            ],
          )
        ) : new SizedBox()
      ],
    ) : new CircularProgressIndicator();
  }

  showControls(){
    setState(() => controlsActive = !controlsActive);
    if(controlsActive){
      lastControlsAppearTime = DateTime.now().millisecondsSinceEpoch;
      new Future.delayed(new Duration(seconds: controlsActivePeriod)).then((_){
        int now = DateTime.now().millisecondsSinceEpoch;
        if(controlsActive && (now - lastControlsAppearTime) > (controlsActivePeriod * 1000 - 500))
          setState(() => controlsActive = false);
      });
    }
  }
}