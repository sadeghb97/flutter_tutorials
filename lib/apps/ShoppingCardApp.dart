import 'package:flutter/material.dart';

class Product{
  String name;
  Product(this.name);
}

List products = [Product("Egg"), Product("Chocolate"), Product("Pizza"),
  Product("Galery"), Product("Amazon"), Product("Hamedanian"),
  Product("Esalat"), Product("Mahram"), Product("Lubia"),
  Product("Salad Olvie"), Product("Pofak Namaki"), Product("Chitoz Motori")];

class ShoppingCardApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "MaterialApp",
        home: new ShoppingCardScaffold(products)
    );
  }
}

class ShoppingCardScaffold extends StatefulWidget{
  List productsList;
  ShoppingCardScaffold(this.productsList);

  @override
  State<StatefulWidget> createState() {
    return new ShoppingCardScaffoldState();
  }
}

class ShoppingCardScaffoldState extends State<ShoppingCardScaffold>{
  List cardItems = <Product>[];

  //ba estefade az widget be productsList dar clase ShoppingCardScaffold dastresi peyda kardim

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
    );
  }

}