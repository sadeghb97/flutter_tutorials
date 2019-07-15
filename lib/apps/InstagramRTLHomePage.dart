import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:first_flutter/general/RoundAvatar.dart';

final IMAGE_URL = "https://www.gravatar.com/avatar/52f0fbcbedee04a121cba8dad1174462?s=150&d=mm&r=g";
final POST_URL = "https://roocket.ir/public/images/2018/9/23/flutter_eman_blog.png";

final medias = <MediaDetails>[
  new MediaDetails(
      "صادق باقرزاده",
      "assets/images/sadegh97b_avatar.jpg",
      "assets/images/sadegh97b_post_image.jpg",
      true
  ),
  new MediaDetails(
      "معین گراف",
      "assets/images/moiengraph_avatar.jpg",
      "assets/images/cross_axis.jpg",
      true
  ),
  new MediaDetails(
      "علی حسین پور",
      "assets/images/ali_hoseinp00r_avatar.jpg",
      "assets/images/main_axis.jpg",
      true
  ),
  new MediaDetails(
      "حسام موسوی",
      IMAGE_URL,
      POST_URL,
      false
  ),
  new MediaDetails(
      "اکبر صدیق",
      "assets/images/akbars2410_avatar.jpg",
      "assets/images/akbars2410_post_image.jpg",
      true
  ),
  new MediaDetails(
      "بوشهر من",
      "assets/images/mybushehr_avatar.jpg",
      "assets/images/mybushehr_post_image.jpg",
      true
  ),
  new MediaDetails(
      "منچستر یونایتد",
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
      "جادی میرمیرانی",
      "assets/images/jadijadinet_avatar.jpg",
      "assets/images/jadijadinet_post_image.jpg",
      true
  ),
  new MediaDetails(
      "علی باقرزاده",
      "assets/images/bzh.ali_avatar.jpg",
      "assets/images/bzh.ali_post_image.jpg",
      true
  )
];

class InstagramRTLHomePageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Instagram App",
        theme: new ThemeData(
            fontFamily: "Vazir",
            primaryIconTheme: new IconThemeData(color: Colors.black)
        ),
        debugShowCheckedModeBanner: false,
        home: new Directionality(textDirection: TextDirection.rtl, child: InstagramStoriesAppBody())
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
        padding: EdgeInsetsDirectional.only(end: 12),
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
      new Text("استوری ها", style: new TextStyle(fontWeight: FontWeight.bold)),
      new Row(
        children: <Widget>[
          new Text("مشاهده همه", style: new TextStyle(fontWeight: FontWeight.bold)),
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
                        margin: index < (10-1) ? EdgeInsetsDirectional.only(end: 8) : null,
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
                    index == 0 ? new PositionedDirectional(
                        end: 4.0,
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

class InstaPost extends StatefulWidget {
  MediaDetails mediaDetails;
  InstaPost(this.mediaDetails);

  @override
  State<StatefulWidget> createState() {
    return new InstaPostState();
  }


}

class InstaPostState extends State<InstaPost> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return new Column(
        crossAxisAlignment : CrossAxisAlignment.stretch,
        children: <Widget>[
          new Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 0, 0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new RoundAvatar(
                          widget.mediaDetails.userAvatarUrl,
                          45,
                          widget.mediaDetails.isLocal
                      ),
                      new Text(
                          widget.mediaDetails.username,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              //set kardane font family faghat baraye yek widget
                              fontFamily: "Vazir"
                          ),
                        //set kardane text direction faghat baraye yek text
                        textDirection: TextDirection.rtl
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
                  new Expanded(
                    child: new GestureDetector(
                      child: widget.mediaDetails.isLocal
                          ? Image.asset(
                          widget.mediaDetails.postImageUrl,
                          fit: BoxFit.cover
                      )
                          : Image.network(
                          widget.mediaDetails.postImageUrl,
                          fit: BoxFit.cover
                      ),
                      onDoubleTap: () => setState(() => liked = true)
                    )
                  )
              ]
          ),
          new Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new IconButton(
                          icon: new Icon(
                              liked
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                              color: liked ? Colors.red : Colors.black
                          ),
                          color: Colors.black,
                          onPressed: () => setState(() => liked = !liked),
                      ),
                      new IconButton(
                          icon: new Icon(FontAwesomeIcons.comment, color: Colors.black),
                          color: Colors.black,
                          onPressed: null
                      ),
                      new IconButton(
                          icon: new Icon(FontAwesomeIcons.paperPlane, color: Colors.black),
                          onPressed: null
                      )
                    ],
                  ),
                  new IconButton(
                      icon: new Icon(FontAwesomeIcons.bookmark, color: Colors.black),
                      onPressed: null
                  )
                ]
            ),
          ),

          //agar meghdare cross axis alignment ra ruye stretch nagozarim
          //in khane az sotune asli be andaze text faza eshghal mikonad
          //va dar vasat gharar migirad
          //ama agar in kar ra konim widgete padding tamame arz ra gerefte
          //text ham tamame arze widgete padding ra gerefte
          //va dar natige text dar samte chap be namayesh dar miyabad
          //meghdare cross axis alignment ra ruye start ham agar begozarim
          //hamin etefagh mioftad va text dar samte chap namayesh miyabad
          //vali text va widgete padding tamame arze safhe ra nemigirand
          new Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: new Text(
                "امین زنوریان و 24,817 نفر دیگر این مطلب را لایک کرده اند",
                style: new TextStyle(fontWeight: FontWeight.bold)
            ),
          ),
          new Padding(
            padding: EdgeInsets.all(8.0),
            child: new Row(
              children: <Widget>[
                new RoundAvatar(
                    widget.mediaDetails.userAvatarUrl,
                    30,
                    widget.mediaDetails.isLocal
                ),
                new Expanded(
                    child: new TextField(
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "اضافه کردن کامنت جدید ...",
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