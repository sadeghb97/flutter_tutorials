import 'package:flutter/material.dart';

showSnackbar(GlobalKey<ScaffoldState> scaffoldKey, String message, IconData iconData, {
  Duration duration = const Duration(milliseconds: 4000), //dafault duration of snackbar
  Color backgroundColor = Colors.cyan,
  VoidCallback onTap
})
{

  scaffoldKey.currentState.showSnackBar(
      new SnackBar(
          duration: duration,
          content: new GestureDetector(
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                      message,
                      style: new TextStyle(
                          fontFamily: "Vazir"
                      )
                  ),
                  new Icon(iconData)
                ]
            ),
            onTap: onTap != null ? onTap : (){},
          ),
          backgroundColor: backgroundColor
      )
  );
}