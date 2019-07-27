import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:validators/validators.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:first_flutter/apps/WhatsappNavigations.dart';

final String LOGIN_REQUEST_URL = "http://roocket.org/api/login";

//az in file dar do barname digar ta konun estefade shode ast
//WhatsappFullComplementWithCamera.dart
//va
//WhatsappFullNavigations.dart
//dar do faile namborde in file import shode ast
//va az WhatsappCheckConnectionLoginBody dar in file be onvane yeki az route ha estefade shode ast
//nokte mohem in hast ke agar mostaghiman appe in file baz shavad
//zamani ke mikhahim be route main beravim route main barnameye hamin file
//baz mishavad. vali agar barname haye an do file baz shode bashad
//va sepas vared screene WhatsappCheckConnectionLoginBody in file shavim
//dar zamane raftan be /main be route maine an do barname khahim raft
//zira dar ane vahed yek barname dar hale ejra darim
//va vaghti mikhahim az route ha estefade konim in route ha haman haei hastand
//ke dar classe extend shode az material app tarif karde im va barname an ham aknun dar hale ejrast
//faghat in nokte mohem ast ke name route main dar har se in file ha yeki ast
//agar file sevomi ham in file ra import konad hamin ghaede pabarjast

//tozihate bala ghablan raayat nashode bud ke hala dar akharin commit
//dorost shode ast

class WhatsappCheckConnectionLoginApp extends StatelessWidget {
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
        routes: {
          '/': (context) => new Directionality(
            textDirection: TextDirection.rtl,
            child: new WhatsappCheckConnectionLoginBody()
          ),
          '/main': (context) => new Directionality(
            textDirection: TextDirection.rtl,
            child: new WhatsappBody()
          )
        },
    );
  }
}

class WhatsappCheckConnectionLoginBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WhatsappCheckConnectionLoginBodyState();
  }
}

class WhatsappCheckConnectionLoginBodyState extends State<WhatsappCheckConnectionLoginBody>
    with SingleTickerProviderStateMixin {

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

  Connectivity connectivity = new Connectivity();
  String emailValue;
  String passwordValue;
  bool wrongEmail = false;
  bool wrongPassword = false;
  bool loading = false;

  @override
  void initState() {
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

    checkConnectivity();

    super.initState();
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
                    child: new Column(
                      children: <Widget>[
                        new Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
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
                      decoration: new BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 3,
                              style: BorderStyle.solid
                          )
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 20)
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: new ButtonTheme(
                      height: 60,
                      minWidth: 230,
                      child: new RaisedButton(
                          color: Theme.of(context).primaryColor,
                          elevation: 4.0,
                          textColor: Colors.white,
                          child: !loading ? new Text(
                            "ورود",
                            style: new TextStyle(
                              fontSize: 20
                            )
                          ) : new CircularProgressIndicator(),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20)
                          ),
                          onPressed: () async {
                            formKey.currentState.save();
                            print("Email Value: $emailValue");
                            print("Password Value: $passwordValue");

                            bool validated = formKey.currentState.validate();

                            if(validated && await checkConnectivity()) {
                              setState(() => loading = true);
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

                                  Navigator.of(context).pushReplacementNamed("/main");
                                }
                                else {
                                  showErrorSnackbar(
                                      "اطلاعات لاگین نامعتبر است!",
                                      Icons.sentiment_dissatisfied
                                  );
                                }

                                setState(() => loading = false);
                              }).catchError((exception){
                                print(exception.message);
                                showErrorSnackbar("مشکلی در احراز هویت شما پیش آمده است!", Icons.error);
                                setState(() => loading = false);
                              });
                            }
                          }
                      )
                    )
                  )
                ]
            )
          ]
        )
      )
    );
  }

  checkConnectivity () async {
    final ConnectivityResult connectivityResult = await connectivity.checkConnectivity();
    print("MobileNet: ${connectivityResult == ConnectivityResult.mobile}");
    print("WifiNet: ${connectivityResult == ConnectivityResult.wifi}");
    scaffoldKey.currentState.hideCurrentSnackBar();

    if(connectivityResult == ConnectivityResult.none){
      print("No Connection");
      showErrorSnackbar(
          "از اتصال دستگاه خود به اینترنت مطمئن شوید !",
          Icons.wifi_lock,
          onTap: (){
            checkConnectivity();
          },
          duration: new Duration(hours: 1)
      );
      return false;
    }
    return true;
  }

  showErrorSnackbar(String message, IconData iconData, {
    Duration duration = const Duration(milliseconds: 4000), //dafault duration of snackbar
    VoidCallback onTap
  })
  {
    //ba raveshi ke ghablan dar barname whatsapp baraye tamase mamuli
    //ya tamase video ei snack bar namayesh dadim inja nemitavanim snackbar namayesh dahim
    //zira be context motabar dastresi nadarim
    //dar anja dar builder be contexte motabar dastresi dashtim
    scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          duration: duration,
          content: new GestureDetector(
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                      message,
                      style: new TextStyle(
                          fontFamily: "Vazir"
                      )
                  ),
                  new Icon(iconData)
                ]
            ),
            onTap: onTap != null ? onTap : (){},
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

