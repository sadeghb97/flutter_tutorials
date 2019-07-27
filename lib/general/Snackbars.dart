import 'package:flutter/material.dart';

showSnackbar(GlobalKey<ScaffoldState> scaffoldKey, String message, IconData iconData, {
  Duration duration = const Duration(milliseconds: 4000), //dafault duration of snackbar
  Color backgroundColor = Colors.cyan,
  TextDirection direction = null,
  bool hideCurrentSnackbar = false,
  VoidCallback onTap
})
{
  Text messageText = new Text(
    message,
    style: new TextStyle(
      fontFamily: "Vazir"
    )
  );

  Widget messageWidget = direction == null ? messageText : new Directionality(
    textDirection: direction,
    child: messageText
  );

  if(hideCurrentSnackbar) scaffoldKey.currentState.hideCurrentSnackBar();
  scaffoldKey.currentState.showSnackBar(
      new SnackBar(
          duration: duration,
          content: new GestureDetector(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                messageWidget,
                new Icon(iconData)
              ]
            ),
            onTap: onTap != null ? onTap : (){},
          ),
          backgroundColor: backgroundColor
      )
  );
}