import 'package:flutter/material.dart';

class HelloApp extends Container{
  HelloApp() : super(
    child: new Center(
      child: new Text("Hello Flutter!",
          textDirection: TextDirection.ltr,
          style: new TextStyle(
              fontSize: 36,
              color: Colors.white
          )
      )
    ),
    decoration: new BoxDecoration(color: Colors.blue)
  );
}