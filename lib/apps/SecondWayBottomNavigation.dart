import 'package:flutter/material.dart';

class SecondBottomNavigationApp extends StatelessWidget {
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
        home: new SecondBottomNavigationAppBody()
    );
  }
}

class SecondBottomNavigationAppBody extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new SecondBottomNavigationAppState();
  }
}

class SecondBottomNavigationAppState extends State<SecondBottomNavigationAppBody> {
  final List screens = <Widget>[
    new HomeScreen(),
    new AddScreen(),
    new FavoriteScreen(),
    new SettingsScreen()
  ];

  int currentIndex = 0;

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
    //ravashe dovome tarife bottom navigation bar
    //bishtar zamani estefade mishavad ke bekhahim zire har item matn ham bashad
    //va hamin tor tedade item ha 3 be paein bashad
    final bottomNavigationBar = new BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        //agar tedade item ha bishtar az 3 shavad fonte neveshte haye har item sefid mishavad
        //pas behtar ast dasti range matne zire har item moshakhas shavad
        new BottomNavigationBarItem(icon: new Icon(Icons.home, color: Colors.black),
            title: new Text("Home", style: new TextStyle(color: Colors.black))),
        new BottomNavigationBarItem(icon: new Icon(Icons.add, color: Colors.black),
            title: new Text("Add", style: new TextStyle(color: Colors.black))),
        new BottomNavigationBarItem(icon: new Icon(Icons.favorite, color: Colors.black),
            title: new Text("Favorite", style: new TextStyle(color: Colors.black))),
        /*new BottomNavigationBarItem(icon: new Icon(Icons.account_box, color: Colors.black),
            title: new Text("Settings", style: new TextStyle(color: Colors.black)))*/
      ],
      onTap: changeScreen,
      //ruye bottom navigation safhe fa'al ra moshakhas mikonad.
      currentIndex: currentIndex,
    );

    return new Scaffold(
        appBar: appBar,
        body: screens[currentIndex],
        bottomNavigationBar: bottomNavigationBar,
    );
  }

  changeScreen(int newIndex) => setState((){currentIndex = newIndex;});
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