import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:first_flutter/apps/WhatsappNavigations.dart';

class WhatsappLoginApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Whatsapp Login",
        theme: new ThemeData(
            primaryIconTheme: new IconThemeData(color: Colors.white),
            primaryColor: Color(0xff075e54),
            accentColor: Color(0xff25d366),
            fontFamily: "Vazir"
        ),
        home: new Directionality(
            textDirection: TextDirection.rtl,
            child: new WhatsappLoginBody()
        )
    );
  }
}

class WhatsappLoginBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WhatsappLoginBodyState();
  }
}

class WhatsappLoginBodyState extends State<WhatsappLoginBody> with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 2500)
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.8;
    final pageSize = MediaQuery.of(context).size;

    return new Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [
              const Color(0xff2c5364),
              const Color(0xff0f2027)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: new Stack(
          children: <Widget>[
            new Opacity(
              opacity: 0.15,
              child: new Container(
                width: pageSize.width,
                height: pageSize.height,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/icon_bg.png"),
                    repeat: ImageRepeat.repeatY
                  )
                )
              )
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  //width: 100,
                  //height: 200,
                  child: new Form(
                      child: new Column(
                        children: <Widget>[
                          new MyInputField(
                              hint: "شماره تلفن خود را وارد کنید",
                              obscure: false,
                              iconData: Icons.person_outline
                          ),
                          new MyInputField(
                              hint: "پسورد خود را وارد کنید",
                              obscure: false,
                              iconData: Icons.lock_outline
                          )
                        ]
                      )
                  )
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: new FlatButton(
                      onPressed: null,
                      child: new Text(
                        "هیچ اکانتی ندارید؟‌ عضویت",
                        style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 14
                        )
                      )
                  )
                )
              ]
            ),
            new GestureDetector(
              child: new Align(
                alignment: Alignment.bottomCenter,
                child: new SignInAnimation(controller: animationController)
              ),
              onTap: () async {
                await animationController.forward();
                Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(
                        builder: (context) => new WhatsappNavigationsApp()
                    )
                );
              }
            )
          ]
        )
      )
    );
  }
}

class MyInputField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData iconData;
  MyInputField({this.hint , this.obscure , this.iconData});

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            color: Colors.white,
            //zekhamate border
            width: 0.8
          )
        )
      ),
      child: new TextFormField(
        obscureText: obscure,
        style: new TextStyle(color: Colors.white),
        decoration: new InputDecoration(
          icon: new Icon(iconData, color: Colors.white),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: new TextStyle(
            color: Colors.white
          )
        )
      )
    );
  }
}

class SimpleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 40),
        width: 230,
        height: 60,
        decoration: new BoxDecoration(
            color: new Color(0xff075E54),
            borderRadius: new BorderRadius.all(Radius.circular(20))
        ),
        child: new Text(
            "ورود",
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20
            )
        )
    );
  }
}

class SignInAnimation extends StatelessWidget {
  final Animation<double> controller;
  final Animation<double> buttonSqueezeAnimation;
  final Animation<double> buttonZoomOut;
  SignInAnimation({@required this.controller}) :

    buttonSqueezeAnimation = new Tween(
      begin: 280.0,
      end: 60.0
    ).animate(
      new CurvedAnimation(
        parent: controller,
        curve: new Interval(0.0, 0.150)
      )
    ),

    buttonZoomOut = new Tween(
      begin: 70.0,
      end: 1000.0
    ).animate(
      new CurvedAnimation(
        parent: controller,
        curve: new Interval(0.800, 0.999 , curve: Curves.bounceOut)
      )
    );

  Widget _animationBuilder(BuildContext context , Widget child) {
    return buttonZoomOut.value <= 300 ?  new Container(
      margin: const EdgeInsets.only(bottom: 30),
      width: buttonZoomOut.value == 70 ? buttonSqueezeAnimation.value
          : buttonZoomOut.value,
      height: buttonZoomOut.value == 70 ? 60
          : buttonZoomOut.value,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: buttonZoomOut.value < 400 ? new BorderRadius.all(const Radius.circular(30))
              : new BorderRadius.all(const Radius.circular(0))
      ),
      child: buttonSqueezeAnimation.value > 75 ? new Text(
        "ورود",
        style: new TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300,
            letterSpacing: .3
        ),
      )
      : buttonZoomOut.value < 300.0 ? new CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      )
      : null
    )
    :  new Container(
      width: buttonZoomOut.value,
      height: buttonZoomOut.value,
      decoration: new BoxDecoration(
          shape: buttonZoomOut.value < 500 ? BoxShape.circle
              : BoxShape.rectangle,
          color: Theme.of(context).primaryColor
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
        animation: controller ,
        builder: _animationBuilder
    );
  }
}

