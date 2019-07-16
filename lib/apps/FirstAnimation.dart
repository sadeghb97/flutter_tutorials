import 'package:flutter/material.dart';

class FirstAnimationApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "FirstAnimation",
        home: new FirstAnimationBody()
    );
  }
}

class FirstAnimationBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FirstAnimationBodyState();
}

class FirstAnimationBodyState extends State<FirstAnimationBody> with SingleTickerProviderStateMixin {
  final double finalHeight = 360;

  AnimationController animationController;
  Animation<double> animation;

  Map<String, Curve> curvesMap = {
    "linear": Curves.linear,
    "decelerate": Curves.decelerate,
    "fastLinearToSlowEaseIn": Curves.fastLinearToSlowEaseIn,
    "ease": Curves.ease,
    "easeIn": Curves.easeIn,
    "easeInToLinear": Curves.easeInToLinear,
    "easeInSine": Curves.easeInSine,
    "easeInQuad": Curves.easeInQuad,
    "easeInCubic": Curves.easeInCubic,
    "easeInQuart": Curves.easeInQuart,
    "easeInQuint": Curves.easeInQuint,
    "easeInExpo": Curves.easeInExpo,
    "easeInCirc": Curves.easeInCirc,
    "easeInBack": Curves.easeInBack,
    "easeOut": Curves.easeOut,
    "linearToEaseOut": Curves.linearToEaseOut,
    "easeOutSine": Curves.easeOutSine,
    "easeOutQuad": Curves.easeOutQuad,
    "easeOutCubic": Curves.easeOutCubic,
    "easeOutQuart": Curves.easeOutQuart,
    "easeOutQuint": Curves.easeOutQuint,
    "easeOutExpo": Curves.easeOutExpo,
    "easeOutCirc": Curves.easeOutCirc,
    "easeOutBack": Curves.easeOutBack,
    "easeInOut": Curves.easeInOut,
    "easeInOutSine": Curves.easeInOutSine,
    "easeInOutQuad": Curves.easeInOutQuad,
    "easeInOutCubic": Curves.easeInOutCubic,
    "easeInOutQuart": Curves.easeInOutQuart,
    "easeInOutQuint": Curves.easeInOutQuint,
    "easeInOutExpo": Curves.easeInOutExpo,
    "easeInOutCirc": Curves.easeInOutCirc,
    "easeInOutBack": Curves.easeInOutBack,
    "fastOutSlowIn": Curves.fastOutSlowIn,
    "slowMiddle": Curves.slowMiddle,
    "bounceIn": Curves.bounceIn,
    "bounceOut": Curves.bounceOut,
    "bounceInOut": Curves.bounceInOut,
    "elasticIn": Curves.elasticIn,
    "elasticOut": Curves.elasticOut,
    "elasticInOut": Curves.elasticInOut
  };

  Map<String, MyImageModel> imagesMap = {
    "MaxOnFire": new MyImageModel("assets/images/max_payne.png", 417 / 260),
    "LegendMaxPayne": new MyImageModel("assets/images/legend_max_payne.png", 600 / 358),
    "YoungMax": new MyImageModel("assets/images/young_max.jpg", 623 / 460),
    "MonaSax": new MyImageModel("assets/images/mona_sax.jpg", 1000 / 554),
    "MaxAndMona": new MyImageModel("assets/images/max_and_mona.jpg", 545 / 400)
  };

  String currentCurve = "easeInOut";
  String currentImage = "MaxOnFire";

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 2000)
    );

    animationController.addListener(
      (){
        //if(animationController.isCompleted) animationController.reverse();
        //else if(animationController.isDismissed) animationController.forward();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    animation = Tween(begin: 0.0, end: finalHeight).animate(
        new CurvedAnimation(
            parent: animationController,
            curve: curvesMap[currentCurve]
        )
    );

    MyImageModel imageModel = imagesMap[currentImage];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("First Animation"),
        actions: <Widget>[
          new PopupMenuButton(
            icon: new Icon(Icons.image),
            itemBuilder: (context) {
              final keys = imagesMap.keys.toList();
              return [
                for(int i=0; keys.length>i; i++) new PopupMenuItem(
                    value: keys[i],
                    child: new Text(keys[i])
                )
              ];
            },
            onSelected: (selected){
              animationController.reset();
              setState(() => currentImage = selected);
            },
          ),
          new PopupMenuButton(
            itemBuilder: (context) {
              final keys = curvesMap.keys.toList();
              return [
                for(int i=0; keys.length>i; i++) new PopupMenuItem(
                    value: keys[i],
                    child: new Text(keys[i])
                )
              ];
            },
            onSelected: (selected){
              animationController.reset();
              setState(() => currentCurve = selected);
            },
          )
        ]
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Center(
            child: new AnimatedBuilder(
              animation: animationController,
              builder: (context, child){
                return new Container(
                    height: animation.value > 0 ? animation.value : 0,
                    width: animation.value > 0 ? animation.value / imageModel.heightOnWidth : 0,
                    child: new Image.asset(imageModel.path)
                );
              }
            )
          ),
          new SizedBox(
            height: 20,
          ),
          new RaisedButton(
            onPressed: () => {animationController.forward()},
            child: new Text("Fire"),
            color: Theme.of(context).primaryColor,
            elevation: 4.0,
            textColor: Colors.white,
          ),
          new RaisedButton(
            onPressed: () => {animationController.reverse()},
            child: new Text("Fade"),
            color: Theme.of(context).primaryColor,
            elevation: 4.0,
            textColor: Colors.white,
          )
        ]
      )
    );
  }
}

class MyImageModel {
  String path;
  double heightOnWidth;
  MyImageModel(this.path, this.heightOnWidth);
}