import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:first_flutter/general/RoocketProduct.dart';

final String ROOCKET_PRODUCTS_URL = "http://roocket.org/api/products?page=";
final scaffoldKey = GlobalKey<ScaffoldState>();

class InfinitieStableRoocketProductsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Roocket Products",
        theme: new ThemeData(
            primaryIconTheme: new IconThemeData(color: Colors.white),
            primaryColor: Color(0xff075e54),
            accentColor: Color(0xff25d366),
            fontFamily: "Vazir"
        ),
        home: new Directionality(textDirection: TextDirection.rtl, child: new RoocketProductsBody())
    );
  }
}

class RoocketProductsBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RoocketProductsBodyState();
  }
}

//single tricker ra baraye tabcontroller niaz darim
class RoocketProductsBodyState extends State<RoocketProductsBody> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
            title: new Center(
                child: new Text("محصولات راکت")
            ),
            elevation: 5,
            bottom: new TabBar(
                tabs: <Widget>[
                  new Tab(icon: new Icon(Icons.shopping_basket)),
                  new Tab(icon: new Icon(Icons.settings))
                ],
                indicatorColor: Colors.white,
                controller: tabController
            )
        ),
        body: new TabBarView(
            children: <Widget>[
              new ProductsScreen(),
              new SettingsScreen(),
            ],
            controller: tabController
        )
    );
  }
}

class ProductsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ProductsScreenState();
}

class ProductsScreenState extends State<ProductsScreen> with AutomaticKeepAliveClientMixin<ProductsScreen>{
  ScrollController scrollController = new ScrollController();
  List products = new List<RoocketProduct>();
  int currentPage = 1;
  int lastPage = 0;
  bool gridViewMode = false;
  bool isLoading = true;

  final Widget loadingWidget = new Center(
    child: new CircularProgressIndicator(),
  );

  final Widget emptyListWidget = new Center(
    child: new Text('محصولی برای نمایش وجود ندارد'),
  );

  @override
  void initState() {
    super.initState();

    scrollController.addListener((){
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      print("$maxScroll - $currentScroll - ${maxScroll - currentScroll}");

      if(maxScroll - currentScroll <= 200 && !isLoading && currentPage < lastPage) {
        print("Load more ${currentPage + 1}");
        fetchProducts(currentPage + 1);
      }
    });

    fetchProducts(1);
  }

  getSwitchListModeWidget(){
    return new SliverAppBar(
      backgroundColor: Colors.transparent,
      primary: false,
      pinned: false,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        new Padding(
            padding: EdgeInsetsDirectional.only(end: 8),
            child: new GestureDetector(
                child: new Icon(
                    Icons.view_stream,
                    color: !gridViewMode ? Colors.grey[900] : Colors.grey[500]
                ),
                onTap: (){
                  setState(() => gridViewMode = false);
                }
            )
        ),
        new Padding(
            padding: EdgeInsetsDirectional.only(end: 8),
            child: new GestureDetector(
                child: new Icon(
                    Icons.view_module,
                    color: gridViewMode ? Colors.grey[900] : Colors.grey[500]
                ),
                onTap: (){
                  setState(() => gridViewMode = true);
                }
            )
        )
      ]
    );
  }

  Widget getProductsListView(){
    return isLoading && products.length == 0
        ? loadingWidget
        : products.length == 0
          ? emptyListWidget
          : new RefreshIndicator(
              child: new ListView.builder(
                controller: scrollController,
                itemCount: products.length,
                itemBuilder: (context, index){
                  final double bottomMargin = index < (products.length - 1) ? 6 : 0;
                  return new ProductCard(
                      products[index],
                      bottomMargin: bottomMargin
                  );
                }
              ),
              onRefresh: () async {
                products.clear();
                await fetchProducts(1, awaitMode: true, updateStateInStart: false);
                return null;
              }
            );
  }

  Widget getProductsGridView(){
    return isLoading && products.length == 0
        ? loadingWidget
        : products.length == 0
          ? emptyListWidget
          : new RefreshIndicator(
              child: new GridView.builder(
                controller: scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: products.length,
                itemBuilder: (context, index){
                  final double endMargin = (index % 2) == 0 ? 6 : 0;
                  double bottomMargin;
                  if((products.length % 2) == 0)
                    bottomMargin = index < (products.length - 2) ? 6 : 0;
                  else bottomMargin = index < (products.length - 1) ? 6 : 0;

                  return new ProductCard(
                      products[index],
                      bottomMargin: bottomMargin,
                      endMargin: endMargin
                  );
                }
              ),
              onRefresh: () async {
                products.clear();
                await fetchProducts(1, awaitMode: true, updateStateInStart: false);
                return null;
              }
            );
  }

  @override
  Widget build(BuildContext context) {
    return new NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled){
          return [getSwitchListModeWidget()];
        },
        body: gridViewMode ? getProductsGridView() : getProductsListView()
    );
  }

  fetchProductsDone(int page, http.Response response){
    if (response.statusCode == 200) {
      print("Page $page fetched!");
      currentPage = page;
      final responseMap = json.decode(response.body);
      lastPage = responseMap['data']['last_page'];

      responseMap['data']['data'].forEach((item) {
        if(item['price'] != "undefined")
          products.add(RoocketProduct.fromJson(item));
      });
      print("Products: $products");

      if(products.length < 6 && currentPage < lastPage){
        fetchProducts(currentPage + 1);
        return;
      }
    }
    else {}
    setState(() => isLoading = false);
  }

  fetchProductsNoInternet(int page){
    showErrorSnackbar(
        "عدم اتصال به اینترنت!",
        Icons.wifi_lock,
        duration: new Duration(hours: 2),
        onTap: (){
          scaffoldKey.currentState.hideCurrentSnackBar();
          fetchProducts(page);
        }
    );
    setState(() => isLoading = false);
  }

  fetchProductsError(Object exception){
    setState(() => isLoading = false);
  }

  fetchProducts(int page, {bool awaitMode = false, updateStateInStart = true}) async {
    if(updateStateInStart) setState(() => isLoading = true);
    else isLoading = true;

    if(!awaitMode) {
      new Connectivity().checkConnectivity().then((connectivityResult) {
        if (connectivityResult != ConnectivityResult.none) {
          http.get("$ROOCKET_PRODUCTS_URL$page")
              .then((response) => fetchProductsDone(page, response))
              .catchError(fetchProductsError);
        }
        else fetchProductsNoInternet(page);
      });
    }
    else {
      final ConnectivityResult connectivityResult = await new Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        try {
          final http.Response response = await http.get(
              "$ROOCKET_PRODUCTS_URL$page");
          fetchProductsDone(page, response);
        }
        catch (exception) {fetchProductsError(exception);}
      }
      else fetchProductsNoInternet(page);
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class ProductCard extends StatelessWidget {
  final RoocketProduct product;
  final double bottomMargin;
  final double endMargin;
  ProductCard(this.product, {this.bottomMargin = 0, this.endMargin = 0});

  @override
  Widget build(BuildContext context) {
    var screeenSize = MediaQuery.of(context).size;

    return new Container(
      child: new Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, endMargin, bottomMargin),
        child: new Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              new Container(
                height: 200,
                width: screeenSize.width,
                child: new CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url){
                      return new Image(
                          image: AssetImage("assets/images/placeholder_image.png"),
                          fit: BoxFit.cover
                      );
                    }
                )
              ),
              new Container(
                height: 60,
                decoration: new BoxDecoration(
                    color: Colors.black38
                ),
                child: new Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                          product.title,
                          style: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      new RichText(
                          maxLines: 1,
                          text: new TextSpan(
                              text: product.body,
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: "Vazir"
                              )
                          )
                      )
                    ]
                  )
                )
              )
            ]
        )
      )
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.pinkAccent,
        child: new Center(
            child: new Text(
                "تنظیمات",
                style: new TextStyle(
                  fontSize: 22,
                  color: Colors.white
                )
            )
        )
    );
  }
}

showErrorSnackbar(String message, IconData iconData, {
  Duration duration = const Duration(milliseconds: 4000), //dafault duration of snackbar
  VoidCallback onTap
})
{

  scaffoldKey.currentState.showSnackBar(
    new SnackBar(
      duration: duration,
      content: new GestureDetector(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
                message,
                style: new TextStyle(
                    fontFamily: "Vazir"
                )
            ),
            new Icon(iconData)
          ]
        ),
        onTap: onTap != null ? onTap : (){},
      ),
      backgroundColor: Colors.redAccent
    )
  );
}
