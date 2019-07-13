import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'HelloApp.dart';
import 'StartScaffold.dart';
import 'StatefulIntro.dart';
import 'ShoppingCardApp.dart';
import 'FirstAppWithBottomNavigation.dart';
import 'SecondWayBottomNavigation.dart';
import 'InstagramStories.dart';
import 'InstagramFullHomePage.dart';
import 'InstagramRTLHomePage.dart';
import 'WhatsappTabBar.dart';

class Route{
  String name;
  Widget widget;
  Route(this.name, this.widget);
}

List routes = [
  Route("Hello Flutter", new HelloApp()),
  Route("First App With Flutter", new FirstAppWithScaffold()),
  Route("Stateful Widget Intro", new StatefulApp()),
  Route("Shopping Items", new ShoppingCardApp()),
  Route("Insta With First Bottom Navigation", new BottomNavigationApp()),
  Route("Insta With Second Bottom Navigation", new SecondBottomNavigationApp()),
  Route("Instagram With Stories", new InstagramStoriesApp()),
  Route("Instagram Full Home Page", new InstagramFullHomePageApp()),
  Route("Instagram Persin Home Page", new InstagramRTLHomePageApp()),
  Route("Whatsapp TabBar", new WhatsappTabBarApp())
];

class MainMenuRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "MaterialApp",
        home: new MainMenuScaffold()
    );
  }
}

class MainMenuScaffold extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("Flutter Basic Examples")
        ),
        body: new ListView(
          padding: EdgeInsets.symmetric(vertical: 8),
          children: routes.map((item){
            return new ListTile(
              title: Text(
                item.name,
                style: new TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => item.widget)),
              leading: new CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(item.name[0]),
              ),
            );
          }).toList(),
        ),
        floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.widgets),
            tooltip: "Floating Action Button",
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context){
                      //agar variable zir ba true set shavad atrafe tamame widget ha border khahim dasht
                      debugPaintSizeEnabled = !debugPaintSizeEnabled;
                      return new MainMenuRoute();
                    }
                )
            )
        )
    );
  }

}