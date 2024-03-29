import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:first_flutter/general/SingletoneObject.dart';
import 'HelloApp.dart';
import 'StartScaffold.dart';
import 'StatefulIntro.dart';
import 'ShoppingCardApp.dart';
import 'FirstAppWithBottomNavigation.dart';
import 'SecondWayBottomNavigation.dart';
import 'InstagramStories.dart';
import 'InstagramFullHomePage.dart';
import 'InstagramRTLHomePage.dart';
import 'WhatsappTabBar.dart';
import 'WhatsappHomePage.dart';
import 'WhatsappNestedScrollView.dart';
import 'WhatsappNavigations.dart';
import 'WhatsappSplashScreen.dart';
import 'FirstAnimation.dart';
import 'StaggeredAnimation.dart';
import 'WhatsappLogin.dart';
import 'WhatsappFormValidation.dart';
import 'WhatsappLoginHttpRequest.dart';
import 'WhatsappCheckConnectionLogin.dart';
import 'WhatsappFullNavigations.dart';
import 'RoocketProducts.dart';
import 'InfinitieStableRefreshableRoocketProducts.dart';
import 'HandledBackButtonShoppingCard.dart';
import 'SQLiteISRRoocketProducts.dart';
import 'GoogleMapStart.dart';
import 'GoogleMapUsingOptions.dart';
import 'FlutterMapForAlternative.dart';
import 'DrawerLayout.dart';
import 'StartCamera.dart';
import 'RecordVideoWithCamera.dart';
import 'CameraWithTakenMediasPreviews.dart';
import 'CameraWithPlayMedia.dart';
import 'WhatsappFullComplementWithCamera.dart';
import 'SocketIoApp.dart';
import 'SocketChatRoomWithAcc.dart';
import 'ImagePickerApp.dart';
import 'MultiLanguageGreeting.dart';
import 'FirebaseMessagingApp.dart';
import 'URLLauncherAndWebviewApp.dart';

class Route{
  String name;
  Widget widget;
  Route(this.name, this.widget);
}

List routes = [
  Route("Hello Flutter", new HelloApp()),
  Route("First App With Flutter", new FirstAppWithScaffold()),
  Route("Stateful Widget Intro", new StatefulApp()),
  Route("Shopping Items", new ShoppingCardApp()),
  Route("Insta With First Bottom Navigation", new BottomNavigationApp()),
  Route("Insta With Second Bottom Navigation", new SecondBottomNavigationApp()),
  Route("Instagram With Stories", new InstagramStoriesApp()),
  Route("Instagram Full Home Page", new InstagramFullHomePageApp()),
  Route("Instagram Persin Home Page", new InstagramRTLHomePageApp()),
  Route("Whatsapp TabBar", new WhatsappTabBarApp()),
  Route("Whatsapp Home Page", new WhatsappHomePageApp()),
  Route("Whatsapp Nested Scroll View", new WhatsappNestedScrollViewApp()),
  Route("Whatsapp Navigations", new WhatsappNavigationsApp()),
  Route("Whatsapp Splash Screen", new WhatsappSplashScreenApp()),
  Route("First Animation", new FirstAnimationApp()),
  Route("Staggered Animation", new StaggeredAnimationApp()),
  Route("Whatsapp Login Screen", new WhatsappLoginApp()),
  Route("Whatsapp Form Validation", new WhatsappFormValidationApp()),
  Route("Whatsapp Login Http Request", new WhatsappLoginHttpRequestApp()),
  Route("Whatsapp Check Connection", new WhatsappCheckConnectionLoginApp()),
  Route("Whatsapp Full Navigations", new WhatsappFullNavigationsApp()),
  Route("Roocket Products Grid View", new RoocketProductsApp()),
  Route("Infinitie Stable and Refreshable Roocket Products", new InfinitieStableRoocketProductsApp()),
  Route("Handled Back Button Shopping Items", new HandledBackButtonShoppingCardsApp()),
  Route("SQLite Storing ISR Roocket Products", new SqliteISRRoocketProductsApp()),
  Route("First Google Map App", new FirstGoogleMapApp()),
  Route("Google Maps With Take Location", new GoogleMapOptionsApp()),
  Route("Flutter Map App For Alternative", new FlutterMapApp()),
  Route("My Fav Apps With Drawer Layout", new DrawerLayoutApp()),
  Route("Take Image With Camera App", new FirstCameraApp()),
  Route("Camera Recording Video App", new CameraRecordingVideoApp()),
  Route("Camera With Taken Medias Previews", new CameraTakenMediasPreviewsApp()),
  Route("Camera With Play Media App", new CameraWithPlayMediaApp()),
  Route("Whatsapp Full Complement With Camera", new WhatsappFullComplementWithCameraApp()),
  Route("Chat Room App", new ChatRoomWithSocketIOApp()),
  Route("Chat Room With Acc App", new SocketChatRoomWithAccApp()),
  Route("Media Loader And Image Picker", new ImagePickerApp()),
  Route("Multi Language Greeting App", new MultiLanguageGreetingApp()),
  Route("Firebase Messaging App", new FirebaseMessagingApp()),
  Route("URL Launcher and Webview App", new URLLauncherAndWebviewApp())
];

class MainMenuRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Flutter Basic Examples",
        home: new MainMenuBody()
    );
  }
}

class MainMenuBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MainMenuBodyState();
}

class MainMenuBodyState extends State<MainMenuBody> {
  SingletoneObject singletone = new SingletoneObject();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Flutter Basic Examples"),
          actions: <Widget>[
            new PopupMenuButton<String>(
                itemBuilder: (context){
                  return [
                    new PopupMenuItem(
                        value: "push_replacement",
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Push Replacement"),
                            singletone.mainMenuPushReplacement ? new Icon(Icons.check_box)
                                : new Icon(Icons.check_box_outline_blank)
                          ],
                        )
                    )
                  ];
                },
                onSelected: (selected){
                  if(selected == "push_replacement")
                    setState(() => singletone.mainMenuPushReplacement = !singletone.mainMenuPushReplacement);
                }
            )
          ]
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
              onTap: singletone.mainMenuPushReplacement ? () => Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(builder: (context) => item.widget)
                )
                : () => Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => item.widget)
              ),
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
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context){
                      //agar variable zir ba true set shavad atrafe tamame widget ha border khahim dasht
                      debugPaintSizeEnabled = !debugPaintSizeEnabled;
                      return new MainMenuRoute();
                    }
                )
            )
        )
    );
  }
}