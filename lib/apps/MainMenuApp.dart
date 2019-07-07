import 'package:flutter/material.dart';
import 'HelloApp.dart';
import 'StartScaffold.dart';
import 'StatefulIntro.dart';
import 'ShoppingCardApp.dart';

class Route{
  String name;
  Widget widget;
  Route(this.name, this.widget);
}

List routes = [
  Route("Hello Flutter", new HelloApp()),
  Route("First App With Flutter", new FirstAppWithScaffold()),
  Route("Stateful Widget Intro", new StatefulApp()),
  Route("Shopping Items", new ShoppingCardApp())
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
            onPressed: () => print("Floating Action Button Pressed!")
        )
    );
  }

}