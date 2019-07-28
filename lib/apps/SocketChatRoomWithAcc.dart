import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_flutter/general/ChatModel.dart';
import 'package:first_flutter/general/Snackbars.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

//code servere nodejs
/*
var app = require('express')();
var server = require('http').Server(app);
var io = require('socket.io')(server);

server.listen(3000);

io
  .of('/')
  .on('connection', (socket) => {
      socket.on('send_message' , (data) => {
          console.log(data);
          socket.broadcast.emit('messages' , {
              senderId : data.senderId,
              message : data.message
          });
          socket.emit('confirm' , {
              messageId : data.messageId
          });
      });
  });
*/

int socketAppUserId;
String socketAppDomain = "http://192.168.0.170";
String socketAppPort = "3000";

class SocketChatRoomWithAccApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "RoocketChat",
      theme: new ThemeData(
        fontFamily: "Vazir"
      ),
      home: new Directionality(
        textDirection: TextDirection.rtl,
        child: new ChatRoomScreen()
      )
    );
  }
}

class ChatRoomScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ChatRoomScreenState();
}

class ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController sendingTextController = new TextEditingController();
  List<SocketMessage> messages = [];
  Map<String, int> myMessagesMap = new Map<String, int>();
  static final unknownStatusIcon = new Icon(Icons.public, color: Colors.black);
  Icon statusIcon = unknownStatusIcon;
  bool connected = false;
  SocketIO socketIO;

  @override
  void initState() {
    socketAppUserId = new Random().nextInt(1000);
    super.initState();
    loadSocketVars();
  }

  loadSocketVars(){
    print("QQQLoadSocketVars");
    SharedPreferences.getInstance().then((prefs){
      if(prefs.containsKey("socket_app_domain"))
        socketAppDomain = prefs.getString("socket_app_domain");

      if(prefs.containsKey("socket_app_port"))
        socketAppPort = prefs.getString("socket_app_port");

      if(prefs.containsKey("socket_app_id"))
        socketAppUserId = int.parse(prefs.getString("socket_app_id"));

      initSocket(socketAppDomain, socketAppPort);
    });
  }

  initSocket(String domain, String port) async {
    SocketIOManager socketIOManager = new SocketIOManager();
    setState((){
      connected = false;
      statusIcon = unknownStatusIcon;
    });
    await socketIOManager.destroyAllSocket();

    //harbar ke say shavad be socket connect shavad natije an tavasote
    //callbacke socketStatusCallback handel mishavad
    //agar ertebat ghat shavad masalan har 5 sanie yekbar say mishavad
    //ke mojadadan connection bargharar shavad
    socketIO = SocketIOManager().createSocketIO(
      domain + ":" + port,
      '/',
      socketStatusCallback: onSocketStatus
    );

    socketIO.init();

    //ma payamhaei ke ba keyworde messages broadcast mishavad ra rasad mikonim
    //dar haghighat har payami ke ma az tarighe socket ke be an motaselim befrestim
    //dar server broadcast shode va be hame kesani ke be an motaseland
    //be joz khodeman ersal mishavad
    //har gah payami daryaft konim tavasote callbacke subscribe handel mishavad
    socketIO.subscribe('messages', onReceiveNewMessages);
    socketIO.subscribe('confirm', onConfirmMessage);

    socketIO.connect();
  }

  @override
  void dispose() {
    new SocketIOManager().destroyAllSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('چت روم'),
        actions: <Widget>[
          new PopupMenuButton<String>(
            //child: Icon(Icons.more_vert),
              itemBuilder: (context){
                return [
                  new PopupMenuItem(
                    value: "chat_room_settings",
                    //tuye row migozarim ta text ra smate rast namayesh dahim
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[new Text("تنظیمات چت روم")],
                    )
                  )
                ];
              },
              onSelected: (selected) async {
                if(selected == "chat_room_settings") {
                  await Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new Directionality(
                        textDirection: TextDirection.rtl,
                        child: new ChatRoomSettingsScreen()
                      )
                    )
                  );

                  loadSocketVars();
                }
              }
          )
        ]
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              color: Colors.black12
            )
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
                  child: new ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context , int index) {
                      return new Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.all(new Radius.circular(10)),
                          color: socketAppUserId == messages[index].senderId
                            ? Colors.greenAccent
                            : Colors.white
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new Expanded(
                              child: new Container(
                                child: new Text(messages[index].message)
                              )
                            ),
                            messages[index].acknowledgement
                              ? new Icon(Icons.done_all, color: Theme.of(context).primaryColor)
                              : new Icon(Icons.info_outline, color: Colors.black26)
                          ],
                        ),
                      );
                    }
                  ),
                )
              ),
              new Container(
                decoration: new BoxDecoration(
                  color: Colors.white
                ),
                child: new Row(
                  children: <Widget>[
                    IconButton(
                      icon: statusIcon,
                    ),
                    Expanded(
                      child: new Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: new TextField(
                          controller: sendingTextController,
                          decoration: new InputDecoration(
                            hintText: 'تایپ کنید',
                            border: InputBorder.none,
                          ),
                        )
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if(connected && sendingTextController.text.length > 0) {
                          String message = sendingTextController.text;
                          SocketMessage socketMessage = new SocketMessage(
                            senderId: socketAppUserId,
                            message: message
                          );

                          broadcastMessage(socketMessage);

                          setState(() {
                            messages.add(socketMessage);
                            myMessagesMap[socketMessage.messageId] = messages.length - 1;
                            sendingTextController.text = '';
                          });
                        }
                      },
                      icon: new Icon(
                        Icons.send,
                        color: connected ? Theme.of(context).primaryColor : Colors.black
                      ),
                    )
                  ]
                )
              )
            ]
          )
        ]
      )
    );
  }


  onSocketStatus(dynamic data) {
    if(data == "connect"){
      setState((){
        statusIcon = new Icon(Icons.network_wifi, color: Colors.green);
        connected = true;
      });
    }
    else if(data == "disconnect"){
      setState((){
        statusIcon = new Icon(Icons.signal_wifi_off, color: Colors.red);
        connected = false;
      });
    }
    else if(data == "connect_error"){
      setState((){
        statusIcon = new Icon(Icons.wifi_lock, color: Colors.orangeAccent);
        connected = false;
      });
    }

    print('QQQSocketStatus : ' + data);
  }

  void broadcastMessage(SocketMessage socketMessage) {
    if(socketIO != null) {
      Map<String , dynamic> jsonData = {
        'senderId': socketAppUserId,
        'messageId': socketMessage.messageId,
        'message': socketMessage.message,
      };

      socketIO.sendMessage('send_message', json.encode(jsonData));
    }
  }

  onReceiveNewMessages(dynamic message) {
    Map<String , dynamic> msg = json.decode(message);
    print(msg);
    setState(() {
      messages.add(
        new SocketMessage(
          senderId : msg['senderId'],
          message: msg['message']
        )
      );
    });
  }

  onConfirmMessage(dynamic confirmMessage){
    Map<String , dynamic> cmJson = json.decode(confirmMessage);
    String confirmedMessageId = cmJson['messageId'];
    if(!myMessagesMap.containsKey(confirmedMessageId)) return;
    int index = myMessagesMap[confirmedMessageId];
    setState(() => messages[index].acknowledgement = true);
  }
}

class ChatRoomSettingsScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new ChatRoomSettingsScreenState();
}

class ChatRoomSettingsScreenState extends State<ChatRoomSettingsScreen> {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController domainController = new TextEditingController();
  TextEditingController portController = new TextEditingController();
  TextEditingController idController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs){
      if(prefs.containsKey("socket_app_domain"))
        domainController.text = prefs.getString("socket_app_domain");
      else domainController.text = socketAppDomain;

      if(prefs.containsKey("socket_app_port"))
        portController.text = prefs.getString("socket_app_port");
      else portController.text = socketAppPort;

      if(prefs.containsKey("socket_app_id"))
        idController.text = prefs.getString("socket_app_id");
      else idController.text = socketAppUserId.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = new TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold
    );

    SizedBox divider = new SizedBox(height: 20);

    UnderlineInputBorder textFieldEnabledBorder = new UnderlineInputBorder(
      borderSide: new BorderSide(
        color: Colors.cyanAccent
      )
    );

    UnderlineInputBorder textFieldFocusedBorder = new UnderlineInputBorder(
        borderSide: new BorderSide(
            color: Colors.cyanAccent
        )
    );

    UnderlineInputBorder textFieldErrorBorder = new UnderlineInputBorder(
        borderSide: new BorderSide(
            color: Colors.redAccent
        )
    );

    UnderlineInputBorder textFieldFocusedErrorBorder = new UnderlineInputBorder(
        borderSide: new BorderSide(
            color: Colors.redAccent
        )
    );

    return new Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text("تنظیمات چت روم")
      ),
      body: new Center(
        child: new Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: new Form(
              key: formKey,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text("دامین سوکت", style: titleStyle),
                  new TextFormField(
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: textFieldEnabledBorder,
                      focusedBorder: textFieldFocusedBorder,
                      errorBorder: textFieldErrorBorder,
                      focusedErrorBorder: textFieldFocusedErrorBorder,
                      hintText: "دامین سوکت را وارد کنید",
                      contentPadding: EdgeInsets.only(top: 5)
                    ),
                    validator: (str){
                      if(!isURL(str)) return "دامین سوکت معتبر نیست!";
                    },
                    controller: domainController
                  ),
                  divider,
                  new Text("پورت سوکت", style: titleStyle),
                  new TextFormField(
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: textFieldEnabledBorder,
                      focusedBorder: textFieldFocusedBorder,
                      errorBorder: textFieldErrorBorder,
                      focusedErrorBorder: textFieldFocusedErrorBorder,
                      hintText: "پورت سوکت را وارد کنید",
                      contentPadding: EdgeInsets.only(top: 5)
                    ),
                    validator: (str){
                      if(!isInt(str)) return "پورت سوکت معتبر نیست!";
                    },
                    controller: portController
                  ),
                  divider,
                  new Text("آی دی شما", style: titleStyle),
                  new TextFormField(
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: textFieldEnabledBorder,
                      focusedBorder: textFieldFocusedBorder,
                      errorBorder: textFieldErrorBorder,
                      focusedErrorBorder: textFieldFocusedErrorBorder,
                      hintText: "آی دی جدید را وارد کنید",
                      contentPadding: EdgeInsets.only(top: 5)
                    ),
                    validator: (str){
                      if(!isInt(str)) return "آی دی جدید معتبر نیست!";
                    },
                    controller: idController
                  ),
                  divider,
                  new ButtonTheme(
                    height: 50,
                    minWidth: 200,
                    child: new RaisedButton(
                      color: Theme.of(context).primaryColor,
                      elevation: 4.0,
                      textColor: Colors.white,
                      child: new Text(
                        "بروزرسانی",
                        style: new TextStyle(
                          fontSize: 20
                        )
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20)
                      ),
                      onPressed: (){
                        bool validated = formKey.currentState.validate();
                        if(validated){
                          SharedPreferences.getInstance().then((prefs){
                            prefs.setString("socket_app_domain", domainController.text);
                            prefs.setString("socket_app_port", portController.text);
                            prefs.setString("socket_app_id", idController.text);

                            showSnackbar(
                              scaffoldKey,
                              "اطلاعات بروز شدند",
                              Icons.done,
                              hideCurrentSnackbar: true,
                              duration: new Duration(seconds: 2)
                            );
                          });
                        }
                      }
                    )
                  )
                ]
              )
          )
        )
      )
    );
  }

}