import 'package:flutter/material.dart';

class WhatsappHomePageApp extends StatelessWidget {
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
        home: new Directionality(textDirection: TextDirection.rtl, child: new WhatsappBody())
    );
  }
}

class WhatsappBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WhatsappBodyState();
  }
}

//single tricker ra baraye tabcontroller niaz darim
class WhatsappBodyState extends State<WhatsappBody> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(initialIndex: 1, length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("واتساپ"),
            elevation: 5,
            actions: <Widget>[
              new Icon(Icons.search, color: Colors.white),
              new PopupMenuButton<String>(
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
                      )
                    ];
                  },
                  onSelected: (selected) => print(selected)
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
        ),
        floatingActionButton: new FloatingActionButton(
            backgroundColor: Theme.of(context).accentColor,
            child: new Icon(Icons.message, color: Colors.white),
            onPressed: () => print("Floating Action Button Pressed!")
        ),
        body: new TabBarView(
            children: <Widget>[
              new CameraScreen(),
              new ChatScreen(),
              new StatusScreen(),
              new CallsScreen()
            ],
            controller: tabController
        )
    );
  }
}

class Avatar extends StatelessWidget {
  String avatarUrl;
  double height;
  bool isLocal;
  Avatar(this.avatarUrl, this.height, this.isLocal);

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.only(right: 8),
        height: height,
        width: height,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                image: isLocal ? new AssetImage(avatarUrl) : new NetworkImage(avatarUrl)
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
              new ListTile(
                  leading: new Avatar(dummyData[index].avatarUrl, 45, dummyData[index].isLocal),
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
              new Divider(
                height: 10,
              )
            ],
          );
        }
    );
  }
}

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.amber,
        child: new Center(
            child: new Text(
                "دوربین",
                style: new TextStyle(fontSize: 25)
            )
        )
    );
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

class ChatModel {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final bool isLocal;

  ChatModel({this.name, this.message, this.time, this.avatarUrl, this.isLocal});
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