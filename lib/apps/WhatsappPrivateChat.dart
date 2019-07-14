import 'package:flutter/material.dart';
import 'WhatsappNavigations.dart';

class WhatsappPrivateChat extends StatelessWidget {
  ChatModel data;
  WhatsappPrivateChat(this.data);

  @override
  Widget build(BuildContext context) {
    return new Directionality(
        textDirection: TextDirection.rtl,
        child: new Scaffold(
          appBar: new AppBar(
            automaticallyImplyLeading: false,
            title: new Row(
              children: <Widget>[
                new GestureDetector(
                  child: new Icon(Icons.arrow_back),
                  onTap: () => Navigator.pop(context),
                ),
                new SizedBox(width: 8),
                new Avatar(data.avatarUrl, 45, data.isLocal),
                new Text(data.name, style: new TextStyle(fontSize: 18))
              ],
            ),
            actions: <Widget>[
              new Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: new GestureDetector(
                  child: new Icon(Icons.videocam),
                  onTap: () => Navigator.pop(
                      context,
                      new WhatsappPrivateChatAnswer(
                          "تماس ویدیویی با " + data.name,
                          Icons.videocam
                      )
                  )
                )
              ),
              new Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: new GestureDetector(
                  child: new Icon(Icons.call),
                  onTap: () => Navigator.pop(
                      context,
                      new WhatsappPrivateChatAnswer(
                          "تماس صوتی با " + data.name,
                          Icons.call
                      )
                  )
                )
              ),
              new Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: new GestureDetector(
                  child: new Icon(Icons.more_vert),
                  onTap: () => print("More")
                )
              )
            ]
          ),
          body: new Stack(
            children: <Widget>[
              new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new Image.asset("assets/images/wpvc_bg.jpg", fit: BoxFit.cover)
                    )
                  ]
              ),
               new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Text(
                        data.message,
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 16)
                    )
                  ]
              )
            ]
          )
        )
    );
  }
}

class WhatsappPrivateChatAnswer {
  String messgae;
  IconData iconData;
  WhatsappPrivateChatAnswer(this.messgae, this.iconData);
}