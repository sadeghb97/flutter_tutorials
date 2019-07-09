import 'package:flutter/material.dart';

class BottomNavigationApp extends StatelessWidget {
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
        home: new BottomNavigationAppBody()
    );
  }
}

class BottomNavigationAppBody extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new BottomNavigationAppState();
  }
}

class BottomNavigationAppState extends State<BottomNavigationAppBody> {
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
    return new Container(color: Colors.blue);
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