import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//Kar haye barname baraye ejra ruye ios anjam nashode ast
class FirebaseMessagingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Firebase Messaging",
      home: new FirebaseMessagingAppBody()
    );
  }
}

class FirebaseMessagingAppBody extends StatefulWidget {
  String receivedTitle;
  String receivedBody;
  String receivedMode;
  String receivedId;
  FirebaseMessagingAppBody({this.receivedTitle, this.receivedBody, this.receivedMode, this.receivedId});

  @override
  State<StatefulWidget> createState() => new FirebaseMessagingAppBodyState();
}

class FirebaseMessagingAppBodyState extends State<FirebaseMessagingAppBody>{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String messageTitle;
  String messageBody;
  String messageReceiveMode;

  @override
  void initState() {
    messageTitle = widget.receivedTitle;
    messageBody = widget.receivedBody;
    messageReceiveMode = widget.receivedMode;
    super.initState();

    //agar barname dar hale ejra bashad title va body darune notification
    //va dade haye set shodeye ezafi darune data be onMessage pas dade mishavad
    //va notificationi ham balaye safhe zaher nakhahad shod
    //ham dar android va ham ios
    //{notification: {}, data: {}}

    //ama agar barname darhale ejra nabashad va baraye ejra niaz be resume ya launch dashte bashad
    //method haye onResume va onLaunch ejra mishavand
    //Nokte inke title va body darune notification daryaft nakhahad shod
    //va faghat title va body dar yek notification balaye gushi zaher khahad shod
    //pas shoma mitavanid agar bekhahid an ra darune dade haye ezafi ham set konid va begirid
    //har dadeye ezafi ke set karde id ba yek seri dade ezafi pishfarz az darune data
    //daryaft mishavad
    //(agar ruye notification click shavad)
    //faghat dar android hatman bayad yek dade ezafi ba kelide click_action va
    //meghdare FLUTTER_NOTIFICATION_CLICK ham set konid vagarna method haye onresume va onlaunch
    //ejra nakhahand shod

    //nokte dar halati ke ma ebteda appe menu ra baz mikonim va sepas
    //appe in file ra baz mikonim
    //dar surati ke barname kollan baste shode bashad ya dar background bashad
    //ma notif ra moshahede mikonim ama dar halati ke barname kamelan baste bashad
    //ghatan appe menuye asli ke dar main farakhani shode ba click ruye notif baz mishavad
    //pas hich payam khasi nakhahim dasht
    //dar halati ke barname dar background hast bastegi darad kodam app dar jariyan bashad
    //agar ma varede barname in file shodim hame chiz dorost hast vali agar dar menu ya app haye
    //digarim haman app ha baz mishavand, bedune axolamali nesbat be etelaate ersal shode
    //agar barname baz bashad ham moshabehe hamin ast agar dar menu ya barname haye digarim
    //hich chizi nemibinim vali agar dar barname in file bashim hame chiz tebghe entezar
    //dorost kar mikonad
    firebaseMessaging.configure(
      onMessage: (message) => loadMessage(message, "message"),
      onLaunch: (message) => loadMessage(message, "launch"),
      onResume: (message) => loadMessage(message, "resume")
    );

    firebaseMessaging.getToken().then((String token) {
      print("QQQToken : $token");
    });
  }

  loadMessage(Map<String, dynamic> message, String mode){
    setState(() {
      print("QQQOn$mode: $message");
      if(message['notification'].containsKey("title")) {
        messageTitle = message['notification']['title'];
        messageBody = message['notification']['body'];
        messageReceiveMode = mode;
      }
      else if(widget.receivedId != message['data']['id']){
        if(message['data'].containsKey("title")) {
          messageTitle = message['data']['title'];
          messageBody = message['data']['body'];
          messageReceiveMode = mode;
        }
        else if(message['data'].containsKey("screen") && message['data'].containsKey("id")){
          print("QQQNavigateToNotifRoute");
          Navigator.of(context).pushReplacement(
            new MaterialPageRoute(
              builder: (context) =>
              new FirebaseMessagingAppBody(
                receivedId: message['data']['id'],
                receivedTitle: "Hi Man!",
                receivedBody: "There is a new story! enjoy :)",
                receivedMode: mode
              )
            )
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleTextStyle = new TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.white
    );

    TextStyle bodyTextStyle = new TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.white
    );

    final screenSize = MediaQuery.of(context).size;

    getShowingMessageWidget(){
      return new Column(
        children: <Widget>[
          new Text(
            messageTitle != null ? messageTitle : "Hello Man!",
            style: titleTextStyle
          ),
          new SizedBox(height: 7),
          new Container(
            width: screenSize.width * 0.85,
            child: new Text(
              "What a ${messageReceiveMode != null ? messageReceiveMode : "start"}",
              style: bodyTextStyle,
              textAlign: TextAlign.center,
            )
          ),
          new SizedBox(height: 4),
          new Container(
            width: screenSize.width * 0.85,
            child: new Text(
              messageBody != null ? messageBody : "Everything is OK :)",
              style: bodyTextStyle,
              textAlign: TextAlign.center,
            )
          )
        ]
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Firebase Messaging")
      ),
      body: new Container(
        color: Colors.lightBlueAccent,
        child: new Padding(
          padding: EdgeInsets.all(10),
          child: new Center(
            child: getShowingMessageWidget()
          )
        )
      )
    );
  }
}