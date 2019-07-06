import 'package:flutter/material.dart';

//be tore kolli do no widget darim yeki stateless va yeki ham stateful
//stateful ha widget haei hastand ke yekseri data darand
//va vaghti an data ha taghir mikonand widget ham dobare render shode va taghir mikonad
//ama stateless widget yekbar render mishavad va digar taghir nemikonad
//mamulan roote yek application yek shey az clase abstracte StatelessWidget ast
//ke dar methode builde an yek shey az MaterialApp return mishavad

class FirstAppWithScaffold extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "MyMaterialApp",
      home: new StartScaffold(),
    );
  }
}

class StartScaffold extends Scaffold{
  StartScaffold() : super(
    appBar: new AppBar(
      leading: new IconButton(
          icon: new Icon(Icons.menu),
          tooltip: "Navigation Menu",
          onPressed: () => print("Navigation Menu Pressed!")
      ),
      title: new Text("MyAppBar"),
      actions: <Widget>[
        new IconButton(
            icon: new Icon(Icons.search),
            tooltip: "Search Icon",
            onPressed: () => print("Search Icon Pressed!")
        )
      ],
    ),
    body: new Container(
      child: new Center(
        child: new Text("Hello Stateless Widgets",
          style: new TextStyle(
            fontSize: 26,
            color: Colors.limeAccent
          ),
        ),
      ),
      decoration: new BoxDecoration(color: Colors.teal),
    ),
    floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        tooltip: "Floating Action Button",
        onPressed: () => print("Floating Action Button Pressed!")
    )
  );
}