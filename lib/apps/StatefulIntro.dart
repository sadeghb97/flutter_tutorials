import 'dart:math';
import 'package:flutter/material.dart';

class StatefulApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "MaterialApp",
      home: new MyScaffold()
    );
  }
}

class MyScaffold extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new MyScaffoldState();
  }
}

//class haei ke clase abstracte State<T extends StatefulWidget> ra extend
//mikonand daraye yek tabe e set state hastand
//in tabe yek VoidCallback migirad va an ra ejra mikonad
//va sepas Widget dobare render mishavad (dobare tabe build ejra mishavad)
class MyScaffoldState extends State<MyScaffold>{
  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("MyAppBar")
        ),
        body: new Center(
          child: new Text("Hello Stateful Widgets",
            style: new TextStyle(
                fontSize: 26,
                color: Color(Colors.primaries[random.nextInt(Colors.primaries.length)].shade800.value)
            )
          )
        ),
        floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.change_history),
            tooltip: "Floating Action Button",
            onPressed: () => setState((){})
        )
    );
  }
}