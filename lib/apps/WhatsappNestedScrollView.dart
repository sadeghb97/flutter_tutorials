import 'package:flutter/material.dart';
import 'package:first_flutter/general/ChatModel.dart';
import 'package:first_flutter/general/RoundAvatar.dart';

class WhatsappNestedScrollViewApp extends StatelessWidget {
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
  static final String MAIN_CONTENT = "main_content";
  static final String SEARCH_CONTENT = "search_content";
  TabController tabController;
  String currentContent;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(initialIndex: 1, length: 4, vsync: this);
    currentContent = MAIN_CONTENT;
  }

  @override
  Widget build(BuildContext context) {
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
                  new CameraScreen(),
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
              new ListTile(
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