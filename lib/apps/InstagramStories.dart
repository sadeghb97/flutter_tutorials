import 'package:flutter/material.dart';

class InstagramStoriesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //in onvan vaghti liste barname haye baz ra baz mikonim
      //ruye barname ma namayesh miyabad
        title: "Instagram App",
        theme: new ThemeData(
          //icon haye barname mesle icon haye app bar ra meshki mikonad
            primaryIconTheme: new IconThemeData(color: Colors.black)
        ),
        debugShowCheckedModeBanner: false,
        home: new InstagramStoriesAppBody()
    );
  }
}

class InstagramStoriesAppBody extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new InstagramStoriesAppState();
  }
}

class InstagramStoriesAppState extends State<InstagramStoriesAppBody> {
  static final String HOME_SCREEN_NAME = "home";
  static final String ADD_SCREEN_NAME = "add";
  static final String FAVORITE_SCREEN_NAME = "favorite";
  static final String SETTINGS_SCREEN_NAME = "settings";

  final Map screenMap = <String, Widget>{
    HOME_SCREEN_NAME: new HomeScreen(),
    ADD_SCREEN_NAME: new AddScreen(),
    FAVORITE_SCREEN_NAME: new FavoriteScreen(),
    SETTINGS_SCREEN_NAME: new SettingsScreen()
  };

  String currentScreen = HOME_SCREEN_NAME;

  final appBar = new AppBar(
    backgroundColor: Color(0xfff8faf8),
    elevation: 5.0,
    centerTitle: true,
    leading: new Icon(Icons.camera_alt),
    title: new SizedBox(
      height: 40,
      child: new Image.asset("assets/images/insta_logo.png"),
    ),
    actions: <Widget>[
      new Padding(
        child: new Icon(Icons.send),
        padding: EdgeInsets.only(right: 12),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    //ravashe avle tarife bottom navigation bar
    //sakht tar ama monatef tar
    final bottomNavigationBar = new Container(
      height: 50,
      alignment: Alignment.center,
      child: new BottomAppBar(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new IconButton(icon: new Icon(Icons.home, color: Colors.black),
                onPressed: (){changeScreen(HOME_SCREEN_NAME);}),
            new IconButton(icon: new Icon(Icons.add, color: Colors.black),
                onPressed: (){changeScreen(ADD_SCREEN_NAME);}),
            new IconButton(icon: new Icon(Icons.favorite, color: Colors.black),
                onPressed: (){changeScreen(FAVORITE_SCREEN_NAME);}),
            new IconButton(icon: new Icon(Icons.account_box, color: Colors.black),
                onPressed: (){changeScreen(SETTINGS_SCREEN_NAME);}),
          ],
        ),
      ),
    );

    return new Scaffold(
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        body: screenMap[currentScreen]
    );
  }

  changeScreen(String newScreen) => setState((){currentScreen = newScreen;});
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return new ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index){
          return index == 0 ? new SizedBox(
            child: new Stories(),
            height: deviceSize.height * 0.18,
          ) : new Container();
        }
    );
  }
}

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(color: Colors.amber);
  }
}

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(color: Colors.deepOrangeAccent);
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(color: Colors.lightGreen);
  }
}

class Stories extends StatelessWidget {
  static final IMAGE_URL = "https://www.gravatar.com/avatar/52f0fbcbedee04a121cba8dad1174462?s=150&d=mm&r=g";

  final texts = new Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      new Text("Stories", style: new TextStyle(fontWeight: FontWeight.bold)),
      new Row(
        children: <Widget>[
          new Text("Watch All", style: new TextStyle(fontWeight: FontWeight.bold)),
          new Icon(Icons.play_arrow)
        ],
      )
    ],
  );

  final stories = new Expanded(
      child: new Padding(
        padding: new EdgeInsets.only(top: 3),
        child: new ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              return new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    new Container(
                        width: 45,
                        height: 45,
                        margin: index < (10-1) ? EdgeInsets.only(right: 6) : null,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: new NetworkImage(IMAGE_URL)
                            )
                        )
                    ),
                    index == 0 ? new Positioned(
                        left: 3.0,
                        bottom: 0,
                        child: new CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 10,
                          child: new Icon(
                              Icons.add,
                              size: 14,
                              color: Colors.white
                          ),
                        )
                    ) : new Container()
                  ]
              );
            }
        ),
      )
  );

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          texts, stories
        ],
      ),
    );
  }
}