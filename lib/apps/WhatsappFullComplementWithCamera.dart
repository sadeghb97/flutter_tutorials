import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_flutter/general/ChatModel.dart';
import 'package:first_flutter/general/RoundAvatar.dart';
import 'package:first_flutter/general/SingletoneObject.dart';
import 'MainMenuApp.dart';
import 'WhatsappPrivateChat.dart';
import 'WhatsappCheckConnectionLogin.dart';
import 'CameraWithPlayMedia.dart';

final String CHECK_API_TOKEN_URL = "http://roocket.org/api/user?api_token=";

class WhatsappFullComplementWithCameraApp extends StatelessWidget {
  static final String SPLASH_SCREEN_ROUTE = "/";
  static final String MAIN_ROUTE = "/main";
  static final String LOGIN_ROUTE = "/login";
  static final String SETTINGS_ROUTE = "/settings";
  static final String NEW_GROUP_ROUTE = "/new_group";
  static final String CAMERA_SCREEN_ROUTE = "/camera";

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Whatsapp",
        theme: new ThemeData(
            primaryIconTheme: new IconThemeData(color: Colors.white),
            primaryColor: Color(0xff075e54),
            accentColor: Color(0xff25d366),
            fontFamily: "Vazir"
        ),
        //agar be yek seri az route ha nakhahim dade pas dahim behtar ast inja
        //yekbar route ha tarif shavad va sepas baraye navigation az pushNamed estefade shavad
        //baraye route private chat chun mikhastim be an dade ersal konim
        //az pushe mamuli estefade kardim ke mesale an mojud ast
        routes: {
          MAIN_ROUTE: (context) => new Directionality(
              textDirection: TextDirection.rtl,
              child: new WhatsappFullComplementWithCameraBody()
          ),
          SPLASH_SCREEN_ROUTE: (context) => new Directionality(
              textDirection: TextDirection.rtl,
              child: new WhatsappSplashScreenBody()
          ),
          LOGIN_ROUTE: (context) => new Directionality(
              textDirection: TextDirection.rtl,
              child: new WhatsappCheckConnectionLoginBody()
          ),
          SETTINGS_ROUTE: (context) => new SettingsScreen(),
          NEW_GROUP_ROUTE: (context) => new NewGroupScreen(),
          CAMERA_SCREEN_ROUTE: (context) => new Directionality(
            textDirection: TextDirection.rtl,
            child: new CameraAppBody()
          )
        },
    );
  }
}

class WhatsappSplashScreenBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new WhatsappSplashScreenBodyState();
}

class WhatsappSplashScreenBodyState extends State<WhatsappSplashScreenBody> {
  @override
  void initState() {
    super.initState();

    Duration duration = new Duration(milliseconds: 1500);
    new Timer(
      duration,
      () => SharedPreferences.getInstance().then(authUser)
    );
  }

  authUser(SharedPreferences prefs){
    final String apiToken = prefs.getString("whatsapp_api_token");
    if(apiToken == null) navigateToLoginRoute(context);
    else {
      print("apiTooken: $apiToken");
      print(CHECK_API_TOKEN_URL + apiToken);
      http.get(
          CHECK_API_TOKEN_URL + apiToken,
          headers: {'Accept': 'application/json'}
      ).then((response) {
        final responseMap = json.decode(response.body);
        print(responseMap);

        if(response.statusCode == 200) {
          Navigator.pushReplacementNamed(
              context,
              WhatsappFullComplementWithCameraApp.MAIN_ROUTE
          );
        }
        else navigateToLoginRoute(context);
      }).catchError((exception){
        new Timer(new Duration(milliseconds: 2000), () => authUser(prefs));
      });
    }
  }

  navigateToLoginRoute(BuildContext context){
    Navigator.pushReplacementNamed(
        context,
        WhatsappFullComplementWithCameraApp.LOGIN_ROUTE
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: new Stack(
        //in fit baes mishavad stack gostarde shode va tamame containere pedar ra begirad
        //va andaze an digar baste be element haye darune an nabashad
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                height: 120,
                width: 120,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: AssetImage("assets/images/whatsapp_icon.png")
                  )
                )
              ),
              new Text(
                "واتساپ",
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                )
              )
            ]
          ),
          new Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: new Align(
              alignment: Alignment.bottomCenter,
              child: new CircularProgressIndicator()
            )
          )
        ]
      )
    );
  }
}

class WhatsappFullComplementWithCameraBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WhatsappFullComplementWithCameraBodyState();
  }
}

//single tricker ra baraye tabcontroller niaz darim
class WhatsappFullComplementWithCameraBodyState extends State<WhatsappFullComplementWithCameraBody>
    with SingleTickerProviderStateMixin {

  static final String MAIN_CONTENT = "main_content";
  static final String SEARCH_CONTENT = "search_content";
  TabController tabController;
  String currentContent;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(initialIndex: 1, length: 4, vsync: this);
    currentContent = MAIN_CONTENT;

    tabController.addListener((){
      if(tabController.index == 0){
        tabController.index = tabController.previousIndex;
        Navigator.pushNamed(
          context,
          WhatsappFullComplementWithCameraApp.CAMERA_SCREEN_ROUTE
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SingletoneObject singletone = new SingletoneObject();

    SliverAppBar mainAppBar = new SliverAppBar(
        title: new Text("واتساپ"),
        elevation: 5,
        //agar pinned true shavad appbar bala pin mishavad va ba scrole body hazf
        //nemishavad. dar gheyre in surat ba scrol app bar kamelan pak khahad shod
        pinned: true,
        //agar floating true shavad dar hali ke pinned ham true hast ba scrolle body
        //appbar be gheyr az tab bar mahv khahad shod
        floating: true,
        actions: <Widget>[
          new GestureDetector(
            child: Icon(Icons.search, color: Colors.white),
            onTap: () => setState(() => currentContent = SEARCH_CONTENT),
          ),
          new PopupMenuButton<String>(
            //child: Icon(Icons.more_vert),
              itemBuilder: (context){
                return [
                  new PopupMenuItem(
                      value: "new_group",
                      //tuye row migozarim ta text ra smate rast namayesh dahim
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[new Text("گروه جدید")],
                      )
                  ),
                  new PopupMenuItem(
                      value: "settings",
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[new Text("تنظیمات")]
                      )
                  ),
                  if(singletone.mainMenuPushReplacement) new PopupMenuItem(
                      value: "quit",
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[new Text("باز کردن منو")]
                      )
                  ),
                  new PopupMenuItem(
                      value: "logout",
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[new Text("خروج")]
                      )
                  ),
                ];
              },
              onSelected: (selected) async {
                if(selected == "settings") {
                  Navigator.pushNamed(
                      context,
                      WhatsappFullComplementWithCameraApp.SETTINGS_ROUTE
                  );
                }
                else if(selected == "new_group") {
                  Navigator.pushNamed(
                      context,
                      WhatsappFullComplementWithCameraApp.NEW_GROUP_ROUTE
                  );
                }
                else if(selected == "quit") {
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new MainMenuRoute()
                      )
                  );
                }
                else if(selected == "logout") {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.remove("whatsapp_login_email");
                  prefs.remove("whatsapp_login_password");
                  prefs.remove("whatsapp_api_token");

                  Navigator.pushReplacementNamed(
                      context,
                      WhatsappFullComplementWithCameraApp.LOGIN_ROUTE
                  );
                }
              }
          )
        ],
        bottom: new TabBar(
            tabs: <Widget>[
              new Tab(icon: new Icon(Icons.camera_alt)),
              new Tab(text: "چت ها"),
              new Tab(text: "وضعیت"),
              new Tab(text: "تماس ها")
            ],
            indicatorColor: Colors.white,
            controller: tabController
        )
    );

    SliverAppBar searchAppBar = new SliverAppBar(
      title: new TextField(
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: "جستجو ..."
        ),
      ),
      elevation: 5,
      backgroundColor: Colors.white,
      pinned: true,
      leading: new GestureDetector(
        child: new Icon(Icons.arrow_back, color: new Color(0xff075E54)),
        onTap: () => setState(() => currentContent = MAIN_CONTENT),
      ),
    );

    return new Scaffold(
        floatingActionButton: new FloatingActionButton(
            backgroundColor: Theme.of(context).accentColor,
            child: new Icon(Icons.message, color: Colors.white),
            onPressed: () => print("Floating Action Button Pressed!")
        ),
        body: new NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                currentContent == MAIN_CONTENT ? mainAppBar : searchAppBar
              ];
            },
            body: new TabBarView(
              children: <Widget>[
                new SizedBox(),
                new ChatScreen(),
                new StatusScreen(),
                new CallsScreen()
              ],
              controller: tabController
          )
        )
    );
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: dummyData.length,
        itemBuilder: (context, index) {
          return new Column(
            children: <Widget>[
              new GestureDetector(
                child: new ListTile(
                    leading: new RoundAvatar(
                        dummyData[index].avatarUrl,
                        45,
                        dummyData[index].isLocal
                    ),
                    title: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            dummyData[index].name,
                            style: new TextStyle(fontWeight: FontWeight.bold),
                          ),
                          new Text(
                            dummyData[index].time,
                            style: new TextStyle(color: Colors.grey, fontSize: 14),
                          )
                        ]
                    ),
                    subtitle: new Text(dummyData[index].message)
                ),
                onTap: () => openPrivateChat(context, dummyData[index]),
              ),
              new Divider(
                height: 10,
              )
            ],
          );
        }
    );
  }

  openPrivateChat(BuildContext context, ChatModel data) async {
    final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new WhatsappPrivateChat(data)
        )
    );

    if(result != null) {
      Scaffold.of(context).showSnackBar(
          new SnackBar(
              content: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                        (result as WhatsappPrivateChatAnswer).message,
                        style: new TextStyle(
                            fontFamily: "Vazir"
                        )
                    ),
                    new Icon((result as WhatsappPrivateChatAnswer).iconData)
                  ]
              ),
              backgroundColor: Theme.of(context).primaryColor
          )
      );
    }
  }
}

class StatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.lightGreen,
        child: new Center(
            child: new Text(
                "وضعیت",
                style: new TextStyle(fontSize: 25)
            )
        )
    );
  }
}

class CallsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.cyan,
        child: new Center(
            child: new Text(
                "تماس ها",
                style: new TextStyle(fontSize: 25)
            )
        )
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Directionality(
        textDirection: TextDirection.rtl,
        child: new Scaffold(
          body: new Container(
              color: Colors.lime,
              child: new Center(
                  child: new Text(
                      "تنظیمات",
                      style: new TextStyle(fontSize: 22)
                  )
              )
          ),
        )
    );
  }
}

class NewGroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Directionality(
        textDirection: TextDirection.rtl,
        child: new Scaffold(
          body: new Container(
              color: Colors.pinkAccent,
              child: new Center(
                  child: new Text(
                      "گروه جدید",
                      style: new TextStyle(
                          fontSize: 22,
                          color: Colors.white
                      )
                  )
              )
          ),
        )
    );
  }
}

List<ChatModel> dummyData = [
  new ChatModel(
      name: "صادق باقرزاده",
      message: "سلام دادا درگیر دوره فلاترم :)",
      time: "20:37",
      avatarUrl: "assets/images/sadegh97b_avatar.jpg",
      isLocal: true
  ),
  new ChatModel(
      name: "اکبر صدیق",
      message: "سلام, امروز چیکاره ایم؟",
      time: "19:16",
      avatarUrl: "assets/images/akbars2410_avatar.jpg",
      isLocal: true
  ),
  new ChatModel(
      name: "علی حسین پور",
      message: "به به چه خبر",
      time: "17:06",
      avatarUrl: "assets/images/ali_hoseinp00r_avatar.jpg",
      isLocal: true
  ),
  new ChatModel(
      name: "معین اسماعیلی",
      message: "سلام دوره فلاتر کی به اتمام میرسه؟",
      time: "17:02",
      avatarUrl: "assets/images/moiengraph_avatar.jpg",
      isLocal: true
  ),
  new ChatModel(
      name: "بوشهریا",
      message: "نمایی زیبا از ساحل بوشهر",
      time: "14:12",
      avatarUrl: "assets/images/mybushehr_avatar.jpg",
      isLocal: true
  ),
  new ChatModel(
      name: "شیاطین سرخ",
      message: "خلاصه بازی منچستر یونایتد و پرث گلوری",
      time: "13:52",
      avatarUrl: "assets/images/manchesterunited_avatar.jpg",
      isLocal: true
  ),
  new ChatModel(
      name: "شهر فوتبال",
      message: "رسمی: گریزمان به بارسلونا پیوست",
      time: "12:09",
      avatarUrl: "assets/images/433_avatar.jpg",
      isLocal: true
  ),
  new ChatModel(
      name: "جادی میرمیرانی",
      message: "دارم دوره پایتون رو ضبط میکنم :)",
      time: "10:51",
      avatarUrl: "assets/images/jadijadinet_avatar.jpg",
      isLocal: true
  ),
  new ChatModel(
      name: "علی باقرزاده",
      message: "سلام سلطان چه خبر؟",
      time: "08:21",
      avatarUrl: "assets/images/bzh.ali_avatar.jpg",
      isLocal: true
  ),
  new ChatModel(
      name: "حسام موسوی",
      message: "سلام حدودا 30 ساعت احتمالا",
      time: "08:21",
      avatarUrl: "https://www.gravatar.com/avatar/52f0fbcbedee04a121cba8dad1174462?s=150&d=mm&r=g",
      isLocal: false
  )
];