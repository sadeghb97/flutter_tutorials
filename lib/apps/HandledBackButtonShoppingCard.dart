import 'dart:io';

import 'package:flutter/material.dart';
import 'package:first_flutter/general/SingletoneObject.dart';
import 'MainMenuApp.dart';

class Product{
  String name;
  Product(this.name);
}

List products = [Product("Egg"), Product("Chocolate"), Product("Pizza"),
  Product("Galery"), Product("Amazon"), Product("Hamedanian"),
  Product("Esalat"), Product("Mahram"), Product("Lubia"),
  Product("Salad Olvie"), Product("Pofak Namaki"), Product("Chitoz Motori")];

class HandledBackButtonShoppingCardsApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Shopping Cards",
        home: new ShoppingCardsBody(products)
    );
  }
}

class ShoppingCardsBody extends StatefulWidget{
  List productsList;
  ShoppingCardsBody(this.productsList);

  @override
  State<StatefulWidget> createState() {
    return new ShoppingCardsBodyState();
  }
}

class ShoppingCardsBodyState extends State<ShoppingCardsBody>{
  List cardItems = <Product>[];

  //ba estefade az widget be productsList dar clase ShoppingCardScaffold dastresi peyda kardim

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: new Scaffold(
          appBar: new AppBar(
              title: new Text("ShoppingItems")
          ),
          body: new ListView(
            padding: EdgeInsets.symmetric(vertical: 8, ),
            children: widget.productsList.map((item){
              bool selected = cardItems.contains(item);

              return new ListTile(
                title: Text(
                  item.name,
                  style: new TextStyle(
                      decoration: selected ? TextDecoration.lineThrough : null,
                      fontWeight: selected ? null : FontWeight.bold
                  ),
                ),
                onTap: (){
                  setState(() {
                    if (selected) cardItems.remove(item);
                    else cardItems.add(item);
                  });
                },
                leading: new CircleAvatar(
                  backgroundColor: selected ? Colors.black54 : Theme.of(context).primaryColor,
                  child: Text(item.name[0]),
                ),
              );
            }).toList(),
          ),
          floatingActionButton: new FloatingActionButton(
              child: new Icon(Icons.remove_shopping_cart),
              tooltip: "Floating Action Button",
              onPressed: () => setState(() => cardItems.clear())
          )
      ),
      //khoruji functioni ke be onWillPop midahim Future<bool> hast
      //agar natije false shavad amalkarde defaulte back button
      //ke raftan be screen ghabli ya khoruj az barname ast ejra nakhahad shod
      //agar natije null ham bashad ya aslan funcion future bar nagardanad
      //ham amalkarde default laghv khahad shod
      //ama agar natije future true bashad amalkarde defaulte back button pabarja khahad bud
      //khate code badi baes mishavad back button az kar bioftad
      //onWillPop: () => new Future<bool>(() => false)

      onWillPop: () => new Future<bool>((){
          return showDialog(
            context: context,
            builder: (context){
              return new Directionality(
                textDirection: TextDirection.rtl,
                child: new AlertDialog(
                  title: new Text(
                      "آیا از خروج مطمئنید؟",
                      style: new TextStyle(
                        fontFamily: "Vazir"
                      )
                  ),
                  content: new Text(
                      "با انتخاب گزینه بله از اپلیکیشن خارج خواهید شد!",
                      style: new TextStyle(
                        fontFamily: "Vazir"
                      )
                  ),
                  actions: <Widget>[
                    if(new SingletoneObject().mainMenuPushReplacement) new FlatButton(
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => new MainMenuRoute()
                              )
                          );
                        },
                        child: new Text(
                            "باز کردن منو",
                            style: new TextStyle(
                                fontFamily: "Vazir",
                                fontWeight: FontWeight.bold
                            )
                        )
                    ),
                    new FlatButton(
                        onPressed: (){
                          exit(0);
                        },
                        child: new Text(
                            "بله",
                            style: new TextStyle(
                              fontFamily: "Vazir",
                              fontWeight: FontWeight.bold
                            )
                        )
                    ),
                    new FlatButton(
                        onPressed: (){
                          //hamin dialog ra mibandad
                          Navigator.of(context).pop();
                        },
                        child: new Text(
                            "خیر",
                            style: new TextStyle(
                              fontFamily: "Vazir",
                              fontWeight: FontWeight.bold
                            )
                        )
                    )
                  ]
                )
              );
            }
          );
      })

    );
  }

}