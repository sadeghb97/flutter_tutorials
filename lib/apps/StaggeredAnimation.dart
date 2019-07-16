import 'package:flutter/material.dart';

class StaggeredAnimationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Staggered Animation",
      home: new StaggeredAnimationBody()
    );
  }
}

class StaggeredAnimationBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new StaggeredAnimationBodyState();
}

class StaggeredAnimationBodyState extends State<StaggeredAnimationBody> with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 2500)
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  playAnimation() async {
    try {
      await animationController.forward();
      await animationController.reverse();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Staggered Animation")
      ),
      body: new GestureDetector(
        onTap: () {
          playAnimation();
        },
        child: new Center(
          child: new Container(
            width: 300,
            height: 300,
            decoration: new BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                border: Border.all(
                    color: Colors.black.withOpacity(0.5)
                )
            ),
            child: new StaggeredAnimation(
                //chun nemikhahim an az tarighe an animation ra control konim
                //faghat view ra gerefte im
                //albate agar khode animationController ra ham pas dahim
                //natije tafavoti nadarad
                controller : animationController.view
            ),
          ),
        ),
      ),
    );
  }
}

class StaggeredAnimation extends StatelessWidget {
  final Animation<double> controller;
  final Animation<double> opacityAnimation;
  final Animation<double> widthAnimation;
  final Animation<double> heightAnimation;
  final Animation<EdgeInsets> paddingAnimation;
  final Animation<BorderRadius> borderRadiusAnimation;
  final Animation<Color> colorAnimation;

  StaggeredAnimation({@required this.controller}) :
      opacityAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0
      ).animate(
          new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.100 , curve: Curves.ease))
      ),

      widthAnimation = Tween<double>(
          begin: 50.0,
          end: 150.0
      ).animate(
          new CurvedAnimation(parent: controller, curve: new Interval(0.125, 0.250 , curve: Curves.ease))
      ),

      heightAnimation = Tween<double>(
          begin: 50.0,
          end: 150.0
      ).animate(
          new CurvedAnimation(parent: controller, curve: new Interval(0.250, 0.375 , curve: Curves.ease))
      ),

      paddingAnimation = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 16),
          end: const EdgeInsets.only(bottom: 75)
      ).animate(
          new CurvedAnimation(parent: controller, curve: new Interval(0.250, 0.375 , curve: Curves.ease))
      ),

      borderRadiusAnimation = BorderRadiusTween(
          begin: BorderRadius.circular(4),
          end: BorderRadius.circular(75)
      ).animate(
          new CurvedAnimation(parent: controller, curve: new Interval(0.375, 0.500 , curve: Curves.ease))
      ),

      colorAnimation = ColorTween(
          begin: Colors.indigo[100],
          end: Colors.orange[400]
      ).animate(
          new CurvedAnimation(parent: controller, curve: new Interval(0.500, 0.750 , curve: Curves.ease))
      );

  Widget animationBuiler(BuildContext context, Widget child) {
    return new Container(
      padding: paddingAnimation.value,
      alignment: Alignment.bottomCenter,
      child: new Opacity(
        opacity: opacityAnimation.value,
        child: new Container(
          width: widthAnimation.value,
          height: heightAnimation.value,
          decoration: new BoxDecoration(
              color: colorAnimation.value,
              border: Border.all(
                  color : Colors.indigo[300],
                  width: 3
              ),
              borderRadius: borderRadiusAnimation.value
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: animationBuiler
    );
  }
}