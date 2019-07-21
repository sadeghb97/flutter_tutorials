import 'package:first_flutter/general/RoocketProduct.dart';
import 'package:sqflite/sqflite.dart';

class RoocketProductsDatabase {
  static final DB_NAME = "roocket_products.db";
  static final PRODUCTS_TABLE_NAME = "products";
  Database database;

  onCreate(Database db, int version) async {
    print("DB OnCreate: $DB_NAME");
    await db.execute('''
        CREATE TABLE $PRODUCTS_TABLE_NAME ( 
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            user_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            body  TEXT NOT NULL,
            image TEXT NOT NULL,
            price TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL)
        '''
    );
  }

  Future<RoocketProductsDatabase> open() {
    return new Future<RoocketProductsDatabase>(() async {
      final String databasePath = await getDatabasesPath();
      final String roocketDbPath = databasePath + "/" + DB_NAME;

      database = await openDatabase(
          roocketDbPath,
          version: 2,

          //vaghti ke database ra mikhahim baz konim agar dar masire database, file database
          //mojud nabashad method oncreate anjam mishavad va database ba versione dade shode sakhte
          //mishavad. agar file database mojud bashad ama versione an kamtar ya bishtar
          //bashad onupgrade ya ondowngrade ejra mishavad
          onCreate: onCreate,
          onUpgrade: (db, oldVersion, newVersion) async {
            print("DB OnUpgrade: $DB_NAME");
            await db.execute("DROP TABLE iF EXISTS $PRODUCTS_TABLE_NAME");
            await onCreate(db, newVersion);
          },
          onDowngrade: (db, oldVersion, newVersion) async {
            print("DB OnDowngrade: $DB_NAME");
            await db.execute("DROP TABLE iF EXISTS $PRODUCTS_TABLE_NAME");
            await onCreate(db, newVersion);
          }
      );
      return this;
    });
  }

  Future<void> close() async => new Future<void>(() => database.close());

  insertProduct(RoocketProduct product) async {
    final int productId = await database.insert(
        PRODUCTS_TABLE_NAME,
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );

    print("Inserted Product Id: $productId");
  }

  Future<List<RoocketProduct>> paginateProducts({int page : 1, limit: 6}) {
    return new Future<List<RoocketProduct>>(() async {
      List<Map> productsMap = await database.query(
          PRODUCTS_TABLE_NAME,
          columns: ['id', 'user_id', 'title', 'body', 'image', 'price', 'created_at', 'updated_at'],
          limit: limit,
          offset: (page - 1) * limit
      );

      List<RoocketProduct> productsList = new List<RoocketProduct>();
      productsMap.forEach((item){
        if(item != null) productsList.add(RoocketProduct.fromJson(item));
      });

      return productsList;
    });
  }
}