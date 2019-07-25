import 'package:first_flutter/general/RoundAvatar.dart';
import 'package:first_flutter/general/SingletoneObject.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import 'MainMenuApp.dart';
import 'GoogleMapUsingOptions.dart';
import 'SQLiteISRRoocketProducts.dart';
import 'InstagramRTLHomePage.dart';
import 'WhatsappNavigations.dart';

class DrawerLayoutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "My Apps",
        theme: new ThemeData(
            fontFamily: "Vazir",
            primaryColor: Color(0xff075e54),
            accentColor: Color(0xff25d366),
            primaryIconTheme: new IconThemeData(color: Colors.white)
        ),
        home: new Directionality(textDirection: TextDirection.rtl, child: new DrawerLayoutAppBody())
    );
  }
}

class DrawerLayoutAppBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new DrawerLayoutAppBodyState();
}

class DrawerLayoutAppBodyState extends State<DrawerLayoutAppBody>{
  TextStyle listTileTextStyle = new TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 18
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("برنامه های من")
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            //niazi be container nist agar nakhahid heighte
            //drawer header ra taghir dahid
            new Container(
                height: 120,
                child: new DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: new Container(
                    decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: <Color>[
                              Theme.of(context).primaryColor,
                              const Color(0xff05433c),
                            ],
                            begin: Alignment.topCenter,
                            end:  Alignment.bottomCenter
                        )
                    ),
                    child: new Stack(
                      children: <Widget>[
                        new Align(
                          alignment: Alignment.bottomRight,
                          child: new Padding(
                              padding: const EdgeInsets.only(right: 16 , bottom: 16),
                              child : new Text('مجله آموزشی راکت' , style: TextStyle(fontSize: 18, color: Colors.white))
                          ),
                        ),
                        new Align(
                          alignment: Alignment.topRight,
                          child: new Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: new ListTile(
                              leading: new RoundAvatar(
                                  "assets/images/sadegh97b_avatar.jpg",
                                  45,
                                  true
                              ),
                              title: new Text(
                                  'صادق باقرزاده',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18
                                  )
                              ),
                            )
                          )
                        )
                      ],
                    ),
                  )
                )
            ),
            new ListTile(
              leading: new Icon(Icons.map, color: Colors.black),
              title: new Text(
                'گوگل مپ',
                style: listTileTextStyle
              ),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) {
                      return new Directionality(
                          textDirection: TextDirection.ltr,
                          child: MapBody()
                      );
                    }
                  )
                );
              },
            ),
            new ListTile(
              leading: new Icon(Icons.shopping_basket, color: Colors.black),
              title: new Text(
                'محصولات راکت',
                style: listTileTextStyle
              ),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) {
                      return new Directionality(
                          textDirection: TextDirection.rtl,
                          child: RoocketProductsBody()
                      );
                    }
                  )
                );
              },
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.whatsapp, color: Colors.black),
              title: new Text(
                'واتساپ فارسی',
                style: listTileTextStyle
              ),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) {
                      return new Directionality(
                          textDirection: TextDirection.rtl,
                          child: WhatsappBody()
                      );
                    }
                  )
                );
              },
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.instagram, color: Colors.black),
              title: new Text(
                  'اینستاگرام فارسی',
                  style: listTileTextStyle
              ),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) {
                      return new Directionality(
                          textDirection: TextDirection.rtl,
                          child: InstagramStoriesAppBody()
                      );
                    }
                  )
                );
              },
            ),
            new ListTile(
              leading: new Icon(Icons.arrow_back, color: Colors.black),
              title: new Text(
                'بازگشت',
                style: listTileTextStyle
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            if(new SingletoneObject().mainMenuPushReplacement) new ListTile(
              leading: new Icon(Icons.exit_to_app, color: Colors.black),
              title: new Text(
                'بازگشت به منوی اصلی',
                style: listTileTextStyle
              ),
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new MainMenuRoute()
                  )
                );
              },
            )
          ]
        )
      ),
      body: new Row(
        children: <Widget>[
          new Expanded(
              child: new Image.asset("assets/images/nice_wallpaper.jpg", fit: BoxFit.cover)
          )
        ]
      )
    );
  }
}