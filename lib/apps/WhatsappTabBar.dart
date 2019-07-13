import 'package:flutter/material.dart';

class WhatsappTabBarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Whatsapp",
      theme: new ThemeData(
          primaryIconTheme: new IconThemeData(color: Colors.black),
          primaryColor: Color(0xff075e54),
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
          new Padding(
              padding: EdgeInsetsDirectional.fromSTEB(6, 0, 8, 0),
              child: new Icon(Icons.more_vert, color: Colors.white)
          ),
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

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.orangeAccent,
        child: new Center(
          child: new Text(
              "چت ها",
              style: new TextStyle(fontSize: 25)
          )
        )
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