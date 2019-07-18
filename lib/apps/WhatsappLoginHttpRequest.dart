import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:validators/validators.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_flutter/apps/WhatsappNavigations.dart';

final String LOGIN_REQUEST_URL = "http://roocket.org/api/login";

class WhatsappLoginHttpRequestApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Send Http Requests",
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
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //agar ruye yek textfield controller set konim
  //bedune seda zadane setState mitavanim meghdare an text filed ra taghir dahim
  //az tarighe property text dar controller mitavanim meghdare textfield ra begirim ya taghir dahim
  //in behtarin rah baraye taghire meghdare textfield hast
  //zira estefade az setState mitavanad baes shavad ke meghdare textfield dar
  //sharayete nakhaste ham taghir konad
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  String emailValue;
  String passwordValue;
  bool wrongEmail = false;
  bool wrongPassword = false;

  @override
  void initState() {
    animationController = new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 2500)
    );

    emailEditingController.addListener(() {
      if(wrongEmail) formKey.currentState.validate();
    });

    passwordEditingController.addListener(() {
      if(wrongPassword) formKey.currentState.validate();
    });

    SharedPreferences.getInstance().then((prefs){
      final String storedEmail = prefs.containsKey("whatsapp_login_email")
          ? prefs.getString("whatsapp_login_email")
          : "";

      final String storedPassword = prefs.containsKey("whatsapp_login_password")
          ? prefs.getString("whatsapp_login_password")
          : "";

      emailEditingController.text = storedEmail;
      passwordEditingController.text = storedPassword;

      print("prefsEmail: $storedEmail");
      print("prefsPassword: $storedPassword");
    });

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
      key: scaffoldKey,
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
                  child: new Form(
                      key: formKey,
                      child: new Column(
                        children: <Widget>[
                          new MyInputField(
                            //example for correct email:
                            //hesammoousavi@gmail.com
                            hint: "ایمیل خود را وارد کنید",
                            obscure: false,
                            iconData: Icons.person_outline,
                            validatorCallback: (value){
                              if(!isEmail(value)) {
                                wrongEmail = true;
                                return "ایمیل معتبر نیست!";
                              }
                              wrongEmail = false;
                            },
                            onSavedCallback: (value) => emailValue = value,
                            onEditingCompleteCallback: (){
                              if(wrongEmail) formKey.currentState.validate();
                            },
                            editingController: emailEditingController,
                          ),
                          new MyInputField(
                            //example for correct password:
                            //123456789
                            hint: "پسورد خود را وارد کنید",
                            obscure: false,
                            iconData: Icons.lock_outline,
                            validatorCallback: (value){
                              if(!isAlphanumeric(value)) {
                                wrongPassword = true;
                                return "پسورد باید فقط شامل حروف و اعداد باشد!";
                              }
                              if(value.length < 6) {
                                wrongPassword = true;
                                return "حداقل طول پسورد باید 6 باشد!";
                              }
                              wrongPassword = false;
                            },
                            onSavedCallback: (value) => passwordValue = value,
                            onEditingCompleteCallback: (){
                              if(wrongPassword) formKey.currentState.validate();
                            },
                            editingController: passwordEditingController
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
                ),
                new FlatButton(
                  onPressed: (){
                    SharedPreferences.getInstance().then((prefs){
                      prefs.remove("whatsapp_login_email");
                      prefs.remove("whatsapp_login_password");
                      emailEditingController.text = "";
                      passwordEditingController.text = "";
                      //storedEmail = "";
                      //storedPassword = "";
                    });
                  },
                  child: new Text(
                    "پاک کردن اطلاعات ورود",
                    style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 14
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
                formKey.currentState.save();
                print("Email Value: $emailValue");
                print("Password Value: $passwordValue");

                bool validated = formKey.currentState.validate();

                if(validated) {
                  await animationController.animateTo(0.150);
                  
                  http.post(
                    LOGIN_REQUEST_URL,
                    body: {
                      'email': emailValue,
                      'password': passwordValue
                    }
                  ).then((response) async {
                    print("Request Status Code: ${response.statusCode}");
                    print("Response Body: ${response.body}");
                    final responseMap = json.decode(response.body);
                    if(responseMap['status'] == 'success'){
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString("whatsapp_login_email", emailValue);
                      prefs.setString("whatsapp_login_password", passwordValue);
                      prefs.setString(
                          "whatsapp_api_token",
                          responseMap['data']['api_token']
                      );

                      await animationController.animateTo(1);
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (context) => new WhatsappNavigationsApp()
                          )
                      );
                    }
                    else {
                      showErrorSnackbar(context, "اطلاعات لاگین نامعتبر است!");
                      animationController.reset();
                    }
                  }).catchError((exception){
                    showErrorSnackbar(context, "مشکلی در احراز هویت شما پیش آمده است!");
                    animationController.reset();
                  });
                }
              }
            )
          ]
        )
      )
    );
  }

  showErrorSnackbar(BuildContext context, String message){
    //ba raveshi ke ghablan dar barname whatsapp baraye tamase mamuli
    //ya tamase video ei snack bar namayesh dadim inja nemitavanim snackbar namayesh dahim
    //zira be context motabar dastresi nadarim
    //dar anja dar builder be contexte motabar dastresi dashtim
    scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                  message,
                  style: new TextStyle(
                      fontFamily: "Vazir"
                  )
              ),
              new Icon(Icons.lock)
            ]
          ),
          backgroundColor: Colors.redAccent
        )
    );
  }
}

class MyInputField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData iconData;
  final Function(String value) validatorCallback;
  final Function(String value) onSavedCallback;
  final Function() onEditingCompleteCallback;
  final TextEditingController editingController;

  MyInputField({
    this.hint , this.obscure , this.iconData, this.validatorCallback,
    this.onSavedCallback, this.onEditingCompleteCallback, this.editingController
  });

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      obscureText: obscure,
      style: new TextStyle(color: Colors.white),
      decoration: new InputDecoration(
          icon: new Icon(iconData, color: Colors.white),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: new TextStyle(
            color: Colors.white
          ),
          errorStyle: new TextStyle(
            color: Colors.amber
          ),
          errorBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(
              color: Colors.amber
            )
          ),
          disabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(
              color: Colors.blueGrey
            )
          ),
          enabledBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(
              color: Colors.cyanAccent
            )
          ),
          focusedBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(
              color: Colors.cyanAccent
            )
          ),
          focusedErrorBorder: new UnderlineInputBorder(
            borderSide: new BorderSide(
              color: Colors.amber
            )
          )
      ),
      validator: validatorCallback,
      onSaved: onSavedCallback,
      controller: editingController,
      onEditingComplete: onEditingCompleteCallback,
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

