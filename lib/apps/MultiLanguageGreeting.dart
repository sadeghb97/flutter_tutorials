import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';

class MultiLanguageGreetingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("QQQBuildingApp");
    return new MaterialApp(
      title: "Greeting",
      theme: new ThemeData(
          fontFamily: "Vazir"
      ),
      localizationsDelegates: [
        //ghabl az inke home shoru be sakhte shodan va bala amadan konad
        //yek shey az TranslationsDelegate sakhte mishavad va darun in list gharar
        //migirad
        new TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      routes: {
        "/": (context) => new SplashScreenBody(),
        "/main": (context) => new GreetingAppBody()
      }
    );
  }

  static loadNewLanguage(BuildContext context, String langCode, VoidCallback voidCallback) async {
    if(Translations.of(context).currentLanguage != langCode) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("greeting_app_selected_locale", langCode);
      await Translations.of(context).selectLanguage(langCode);
      voidCallback();
    }
  }

  static Future<void> loadDefaultLanguage(BuildContext context) {
    return new Future<void>(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey("greeting_app_selected_locale")){
        String langCode = prefs.getString("greeting_app_selected_locale");
        if(Translations.of(context).currentLanguage != langCode)
          await MultiLanguageGreetingApp.loadNewLanguage(context, langCode, (){});
      }
    });
  }
}

class GreetingAppBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new GreetingAppBodyState();
}

class GreetingAppBodyState extends State<GreetingAppBody>{
  @override
  void initState() {
    super.initState();
  }

  PopupMenuEntry<String> getLanguagePopupMenuItem(String langKey, String langCode, String direction) {
    List<Widget> rowWidgets = [
      new Text(Translations.of(context).text(langKey)),
      Translations.of(context).currentLanguage == langCode ? new Icon(Icons.check_box)
        : new Icon(Icons.check_box_outline_blank),
    ];

    return new PopupMenuItem(
      value: langCode,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: direction == "ltr" ? rowWidgets
          : rowWidgets.reversed.toList()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    print("QQQBuildingScaffold");
    String direction = Translations.of(context).text("language_direction");
    PopupMenuEntry<String> faMenuItem = getLanguagePopupMenuItem("persian_language", "fa", direction);
    PopupMenuEntry<String> enMenuItem = getLanguagePopupMenuItem("english_language", "en", direction);
    PopupMenuEntry<String> deMenuItem = getLanguagePopupMenuItem("german_language", "de", direction);
    PopupMenuEntry<String> frMenuItem = getLanguagePopupMenuItem("french_language", "fr", direction);
    PopupMenuEntry<String> esMenuItem = getLanguagePopupMenuItem("spanish_language", "es", direction);
    PopupMenuEntry<String> zhMenuItem = getLanguagePopupMenuItem("chinese_language", "zh-Hans", direction);
    PopupMenuEntry<String> arMenuItem = getLanguagePopupMenuItem("arabic_language", "ar", direction);

    return new Directionality(
      textDirection: direction == "ltr" ? TextDirection.ltr : TextDirection.rtl,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(Translations.of(context).text('app_title')),
          actions: <Widget>[
            new PopupMenuButton<String>(
              itemBuilder: (context){
                return [
                  faMenuItem, enMenuItem, deMenuItem, frMenuItem,
                  esMenuItem, zhMenuItem, arMenuItem,
                  new PopupMenuItem(
                    value: "clear",
                    child: new Row(
                      mainAxisAlignment: direction == "ltr"
                          ? MainAxisAlignment.start : MainAxisAlignment.end,
                      children: <Widget>[
                        new Text(Translations.of(context).text("clear_default")),
                      ],
                    )
                  )
                ];
              },
              onSelected: (selected) async {
                if(selected == "clear"){
                  clearDefaultSettings();
                  Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new MultiLanguageGreetingApp()
                    )
                  );
                }
                else {
                  await MultiLanguageGreetingApp.loadNewLanguage(
                    context,
                    selected,
                    () => setState((){})
                  );
                }
              }
            )
          ]
        ),
        body: new ListView(
          children: <Widget>[
            new ListTile(
              title: new Text(
                Translations.of(context).text("hello"),
                style: new TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
              trailing: new Icon(Icons.favorite)
            ),
            new ListTile(
              title: new Text(
                Translations.of(context).text("goog_morning"),
                style: new TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
              trailing: new Icon(Icons.favorite)
            ),
            new ListTile(
              title: new Text(
                Translations.of(context).text("how_are_you"),
                style: new TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
              trailing: new Icon(Icons.favorite)
            ),
            new ListTile(
              title: new Text(
                Translations.of(context).text("goodbye"),
                style: new TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
              trailing: new Icon(Icons.favorite)
            )
          ],
        ),
      )
    );
  }

  clearDefaultSettings(){
    SharedPreferences.getInstance().then((prefs){
      prefs.remove("greeting_app_selected_locale");
    });
  }
}

class SplashScreenBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SplashScreenBodyState();
}

class SplashScreenBodyState extends State<SplashScreenBody> {
  @override
  void initState() {
    super.initState();
    int beforeLoadDefaultTime = DateTime.now().millisecondsSinceEpoch;
    MultiLanguageGreetingApp.loadDefaultLanguage(context).then((_){
      int remainedTime = 1800 - (DateTime.now().millisecondsSinceEpoch - beforeLoadDefaultTime);
      print("QQQRemainedTimeToNavigateMain: $remainedTime");
      if(remainedTime <= 0) navigate();
      else new Timer(new Duration(milliseconds: remainedTime), navigate);
    });
  }

  navigate() => Navigator.pushReplacementNamed(context, "/main");

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: new Stack(
          //in fit baes mishavad stack gostarde shode va tamame containere pedar ra begirad
          //va andaze an digar baste be element haye darune an nabashad
          fit: StackFit.expand,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height: 280,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: AssetImage("assets/images/greeting_icon.png")
                    )
                  )
                )
              ]
            ),
            new Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: new Align(
                alignment: Alignment.bottomCenter,
                child: new CircularProgressIndicator()
              )
            )
          ]
        )
    );
  }
}

class Translations {
  static const List<String> supportedLanguages = ['en' , 'fa'];
  Locale locale;
  Map<dynamic , dynamic> localizedValues;

  Translations(Locale locale) {
    print("QQQPhoneDefaultLanguageCode: ${locale.languageCode}");
    this.locale = locale;
    localizedValues = null;
  }

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  String text(String key) {
    return localizedValues[key] ?? 'str not found';
  }

  selectLanguage(String languageCode) async {
    locale = new Locale(languageCode, "");
    String jsonContent = await rootBundle.loadString(
        "assets/locale/i18n_${locale.languageCode}.json"
    );
    localizedValues = json.decode(jsonContent);
  }

  static Future<Translations> load(Locale locale) {
    return new Future<Translations>(() async {
      print("QQQStaticFutureLoad");
      //agar inja bekhahim az shared preferences estefade konim
      //va bebinim aya zabani entekhab shode ta an zaban ra be jaye
      //zabane pishfarze gushi estefade konim
      //zamani ke safheye barname mikhahad load shavad
      //safhe modate kutahi siah mishavad
      //pas inja inkar ra nemikonim va be jaye an dar init state barresi karde im
      //ke aya dar shared preferences zabani entekhab shode ast, va agar in chenin
      //bud agar az zabane defaulte gushi motefavet ast, ba estefade az methode selectLanguage
      //dar in class an zaban ra load mikonim va sepas setState mikonim
      //be in surat safhe siah nemishavad
      //ama baz ham karbar motevajjehe taghire mohtava mishavad
      //va taghire text ha namahsus nist
      //pas behtar ast masalan az splash screen ya hamchenin chizi estefade shavad

      Translations translations = new Translations(locale);
      String jsonContent = await rootBundle.loadString(
          "assets/locale/i18n_${locale.languageCode}.json"
      );
      translations.localizedValues = json.decode(jsonContent);
      return translations;
    });
  }

  get currentLanguage => locale.languageCode;

}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  @override
  bool isSupported(Locale locale) => Translations.supportedLanguages.contains(locale.languageCode);

  //vaghti yek shey az in class misazim va darun list localizedDelegates material appe
  //barname mirizim in method yani load farakhani mishavad
  //vorudi, locale pishrafte gushi hast ke pass dade mishavad
  //va yek shey az class Translations ke dar generic amade ham khorujie in method ast
  //zamani ke future tamam shavad va sheye Transalations amade shavad
  //kar edame miyabad
  @override
  Future<Translations> load(Locale locale) => Translations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<Translations> old) => false;
}