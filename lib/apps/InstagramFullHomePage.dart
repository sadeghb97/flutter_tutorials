import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final IMAGE_URL = "https://www.gravatar.com/avatar/52f0fbcbedee04a121cba8dad1174462?s=150&d=mm&r=g";
final POST_URL = "https://roocket.ir/public/images/2018/9/23/flutter_eman_blog.png";

final medias = <MediaDetails>[
  new MediaDetails(
      "sadegh97b",
      "assets/images/sadegh97b_avatar.jpg",
      "assets/images/sadegh97b_post_image.jpg",
      true
  ),
  new MediaDetails(
      "moiengraph",
      "assets/images/moiengraph_avatar.jpg",
      "assets/images/cross_axis.jpg",
      true
  ),
  new MediaDetails(
      "ali.hoseinp00r",
      "assets/images/ali_hoseinp00r_avatar.jpg",
      "assets/images/main_axis.jpg",
      true
  ),
  new MediaDetails(
      "hesam.mousavi",
      IMAGE_URL,
      POST_URL,
      false
  ),
  new MediaDetails(
      "akbars2410",
      "assets/images/akbars2410_avatar.jpg",
      "assets/images/akbars2410_post_image.jpg",
      true
  ),
  new MediaDetails(
      "mybushehr",
      "assets/images/mybushehr_avatar.jpg",
      "assets/images/mybushehr_post_image.jpg",
      true
  ),
  new MediaDetails(
      "manchesterunited",
      "assets/images/manchesterunited_avatar.jpg",
      "assets/images/manchesterunited_post_image.jpg",
      true
  ),
  new MediaDetails(
      "433",
      "assets/images/433_avatar.jpg",
      "assets/images/433_post_image.jpg",
      true
  ),
  new MediaDetails(
      "jadijadinet",
      "assets/images/jadijadinet_avatar.jpg",
      "assets/images/jadijadinet_post_image.jpg",
      true
  ),
  new MediaDetails(
      "bzh.ali",
      "assets/images/bzh.ali_avatar.jpg",
      "assets/images/bzh.ali_post_image.jpg",
      true
  )
];

class InstagramFullHomePageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //in onvan vaghti liste barname haye baz ra baz mikonim
      //ruye barname ma namayesh miyabad
        title: "Instagram App",
        theme: new ThemeData(
          //icon haye barname mesle icon haye app bar ra meshki mikonad
            primaryIconTheme: new IconThemeData(color: Colors.black)
        ),
        debugShowCheckedModeBanner: false,
        home: new InstagramStoriesAppBody()
    );
  }
}

class InstagramStoriesAppBody extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new InstagramStoriesAppState();
  }
}

class InstagramStoriesAppState extends State<InstagramStoriesAppBody> {
  static final String HOME_SCREEN_NAME = "home";
  static final String ADD_SCREEN_NAME = "add";
  static final String FAVORITE_SCREEN_NAME = "favorite";
  static final String SETTINGS_SCREEN_NAME = "settings";

  final Map screenMap = <String, Widget>{
    HOME_SCREEN_NAME: new HomeScreen(),
    ADD_SCREEN_NAME: new AddScreen(),
    FAVORITE_SCREEN_NAME: new FavoriteScreen(),
    SETTINGS_SCREEN_NAME: new SettingsScreen()
  };

  String currentScreen = HOME_SCREEN_NAME;

  final appBar = new AppBar(
    backgroundColor: Color(0xfff8faf8),
    elevation: 5.0,
    centerTitle: true,
    leading: new Icon(Icons.camera_alt),
    title: new SizedBox(
      height: 40,
      child: new Image.asset("assets/images/insta_logo.png"),
    ),
    actions: <Widget>[
      new Padding(
        child: new Icon(Icons.send),
        padding: EdgeInsets.only(right: 12),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    //ravashe avle tarife bottom navigation bar
    //sakht tar ama monatef tar
    final bottomNavigationBar = new Container(
      height: 50,
      alignment: Alignment.center,
      child: new BottomAppBar(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new IconButton(icon: new Icon(Icons.home, color: Colors.black),
                onPressed: (){changeScreen(HOME_SCREEN_NAME);}),
            new IconButton(icon: new Icon(Icons.add, color: Colors.black),
                onPressed: (){changeScreen(ADD_SCREEN_NAME);}),
            new IconButton(icon: new Icon(Icons.favorite, color: Colors.black),
                onPressed: (){changeScreen(FAVORITE_SCREEN_NAME);}),
            new IconButton(icon: new Icon(Icons.account_box, color: Colors.black),
                onPressed: (){changeScreen(SETTINGS_SCREEN_NAME);}),
          ],
        ),
      ),
    );

    return new Scaffold(
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        body: screenMap[currentScreen]
    );
  }

  changeScreen(String newScreen) => setState((){currentScreen = newScreen;});
}

class MediaDetails {
  String username;
  String userAvatarUrl;
  String postImageUrl;
  bool isLocal;
  MediaDetails(this.username, this.userAvatarUrl, this.postImageUrl, this.isLocal);
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return new ListView.builder(
        itemCount: medias.length + 1,
        itemBuilder: (context, index){
          return index == 0 ? new SizedBox(
            child: new Stories(),
            height: deviceSize.height * 0.18,
          ) : new InstaPost(medias[index - 1]);
        }
    );
  }
}

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(color: Colors.amber);
  }
}

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(color: Colors.deepOrangeAccent);
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(color: Colors.lightGreen);
  }
}

class Stories extends StatelessWidget {
  final texts = new Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      new Text("Stories", style: new TextStyle(fontWeight: FontWeight.bold)),
      new Row(
        children: <Widget>[
          new Text("Watch All", style: new TextStyle(fontWeight: FontWeight.bold)),
          new Icon(Icons.play_arrow)
        ],
      )
    ],
  );

  final stories = new Expanded(
      child: new Padding(
        padding: new EdgeInsets.only(top: 3),
        child: new ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              return new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    new Container(
                        width: 50,
                        height: 50,
                        margin: index < (10-1) ? EdgeInsets.only(right: 8) : null,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: medias[index].isLocal
                                    ? new AssetImage(medias[index].userAvatarUrl)
                                    : new NetworkImage(medias[index].userAvatarUrl)
                            )
                        )
                    ),
                    index == 0 ? new Positioned(
                        right: 4.0,
                        bottom: 0,
                        child: new CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 10,
                          child: new Icon(
                              Icons.add,
                              size: 14,
                              color: Colors.white
                          ),
                        )
                    ) : new Container()
                  ]
              );
            }
        ),
      )
  );

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          texts, stories
        ],
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  String avatarUrl;
  double height;
  bool isLocal;
  Avatar(this.avatarUrl, this.height, this.isLocal);

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.only(right: 8),
        height: height,
        width: height,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                image: isLocal ? new AssetImage(avatarUrl) : new NetworkImage(avatarUrl)
            )
        )
    );
  }

}

class ExpandedImage extends StatelessWidget {
  String imageUrl;
  bool isLocal;
  ExpandedImage(this.imageUrl, this.isLocal);

  @override
  Widget build(BuildContext context) {
    return new Expanded(
        child: isLocal
            ? Image.asset(
            imageUrl,
            fit: BoxFit.cover
        )
            : Image.network(
            imageUrl,
            fit: BoxFit.cover
        )
    );
  }
}

class InstaPost extends StatelessWidget {
  MediaDetails mediaDetails;
  InstaPost(this.mediaDetails);

  @override
  Widget build(BuildContext context) {
    return new Column(
        crossAxisAlignment : CrossAxisAlignment.stretch,
        children: <Widget>[
          new Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Avatar(mediaDetails.userAvatarUrl, 45, mediaDetails.isLocal),
                      new Text(
                          mediaDetails.username,
                          style: new TextStyle(fontWeight: FontWeight.bold)
                      )
                    ],
                  ),
                  new IconButton(
                      icon: new Icon(Icons.more_vert, color: Colors.black),
                      onPressed: null
                  )
                ],
              )
          ),
          new Row(
              children: <Widget>[
                new ExpandedImage(mediaDetails.postImageUrl, mediaDetails.isLocal)
              ]
          ),
          new Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new IconButton(
                      icon: new Icon(FontAwesomeIcons.bookmark, color: Colors.black),
                      onPressed: null
                  ),
                  new Row(
                    children: <Widget>[
                      new IconButton(
                          icon: new Icon(FontAwesomeIcons.paperPlane, color: Colors.black),
                          onPressed: null
                      ),
                      new IconButton(
                          icon: new Icon(FontAwesomeIcons.comment, color: Colors.black),
                          color: Colors.black,
                          onPressed: null
                      ),
                      new IconButton(
                          icon: new Icon(FontAwesomeIcons.heart, color: Colors.black),
                          color: Colors.black,
                          onPressed: null
                      )
                    ],
                  )
                ]
            ),
          ),
          new Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: new Text(
                "Liked by amin.zanourian and 24,817 others",
                style: new TextStyle(fontWeight: FontWeight.bold)
            ),
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: new Row(
              children: <Widget>[
                new Avatar(mediaDetails.userAvatarUrl, 30, mediaDetails.isLocal),
                new Expanded(
                    child: new TextField(
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add a comment",
                          hintStyle: new TextStyle(fontWeight: FontWeight.w500)
                      ),
                    )
                )
              ],
            ),
          )
        ]
    );
  }
}