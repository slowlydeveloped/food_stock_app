import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "FoodStockDatabase.db";
  static const _databaseVersion = 3;

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE vendors (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      contact TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE ingredients (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      price REAL NOT NULL,
      unit TEXT NOT NULL,
      vendor_id INTEGER,
      FOREIGN KEY (vendor_id) REFERENCES vendors(id)
    )
  ''');

    await db.execute('''
    CREATE TABLE recipes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      ingredients TEXT NOT NULL -- JSON string of ingredients with quantities
    )
  ''');

   await db.execute(''' 
    CREATE TABLE orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      recipe_id INTEGER NOT NULL,
      recipe_name TEXT NOT NULL,
      quantity INTEGER NOT NULL,
      total_price REAL NOT NULL, -- New column for storing the total price
      FOREIGN KEY (recipe_id) REFERENCES recipes(id)
    )
  ''');
    
    await db.execute('''
    CREATE TABLE stock (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ingredient_id INTEGER NOT NULL,
      quantity REAL NOT NULL,
      type TEXT NOT NULL, -- 'inward' or 'outward'
      date TEXT NOT NULL,
      FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
    )
  ''');
  }

  // CRUD Operations for vendors
  Future<int> insertVendor(Map<String, dynamic> row) async {
    Database db = await instance.database;

    return await db.insert('vendors', row);
  }

  Future<List<Map<String, dynamic>>> queryAllVendors() async {
    Database db = await instance.database;
    return await db.query('vendors');
  }

  Future<int> updateVendor(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('vendors', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteVendor(int id) async {
    Database db = await instance.database;
    return await db.delete('vendors', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for ingredients
  Future<int> insertIngredient(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('ingredients', row);
  }

  Future<List<Map<String, dynamic>>> queryAllIngredients() async {
    Database db = await instance.database;
    return await db.query('ingredients');
  }

  Future<int> updateIngredient(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db
        .update('ingredients', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteIngredient(int id) async {
    Database db = await instance.database;
    return await db.delete('ingredients', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for recipes

  Future<int> updateRecipe(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('recipes', row, where: 'id = ?', whereArgs: [id]);
  }

 Future<int> insertRecipe(Map<String, dynamic> recipe) async {
  Database db = await instance.database;

  // Insert recipe into recipes table
  int recipeId = await db.insert('recipes', {
    'name': recipe['name'],
    'ingredients': jsonEncode(recipe['ingredients']), // Serialize ingredients list to JSON
  });

  // Insert order for the recipe
  await db.insert('orders', {
    'recipe_id': recipeId,
    'recipe_name': recipe['name'], // Use recipe name as the product
    'quantity': 1, // Assuming initial quantity is 1 for simplicity
    'total_price': calculateTotalPrice(recipe['ingredients']), // Calculate total price
    'date': DateTime.now().toString(), // Store the date of the order
  });

  return recipeId;
}

// Function to calculate total price based on ingredients
double calculateTotalPrice(List<dynamic> ingredients) {
  double totalPrice = 0;
  for (var ingredient in ingredients) {
    totalPrice += ingredient['price'] * ingredient['quantity'];
  }
  return totalPrice;
}


// Modify your queryAllRecipes method to also fetch ingredients for each recipe:

  Future<List<Map<String, dynamic>>> queryAllRecipes() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> recipes = await db.query('recipes');

    for (var recipe in recipes) {
      // Deserialize ingredients JSON string back into a list of maps
      List<dynamic> ingredientsJson = jsonDecode(recipe['ingredients']);
      List<Map<String, dynamic>> ingredients =
          List<Map<String, dynamic>>.from(ingredientsJson);
      recipe['ingredients'] = ingredients;
    }

    return recipes;
  }

  Future<int> deleteRecipe(int id) async {
    Database db = await instance.database;
    return await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllRecipesWithDetails() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> recipesWithDetails = await db.rawQuery('''
    SELECT 
      recipes.id,
      recipes.name AS recipe_name,
      recipes.ingredients,
      orders.quantity,
      ingredients.price * orders.quantity AS total_price -- Calculate total price
    FROM recipes
    LEFT JOIN orders ON recipes.id = orders.recipe_id
    LEFT JOIN ingredients ON orders.ingredient_id = ingredients.id
  ''');

    return recipesWithDetails;
  }

  // CRUD Operations for orders
Future<int> insertOrder(Map<String, dynamic> orderDetails) async {
  Database db = await instance.database;

  // Insert order into orders table
  int orderId = await db.insert('orders', {
    'recipe_id': orderDetails['recipe_id'],
    'recipe_name': orderDetails['recipe_name'],
    'quantity': orderDetails['quantity'],
    'total_price': orderDetails['total_price'],
    'date': DateTime.now().toString(), 
  });

  return orderId;
}

Future<List<Map<String, dynamic>>> queryAllOrdersWithDetails() async {
  Database db = await instance.database;

  List<Map<String, dynamic>> ordersWithDetails = await db.rawQuery('''
    SELECT 
      orders.id,
      orders.recipe_id,
      orders.recipe_name,
      orders.quantity,
      orders.total_price,
      recipes.ingredients -- You can include other details as needed
    FROM orders
    INNER JOIN recipes ON orders.recipe_id = recipes.id
  ''');

  return ordersWithDetails;
}

  Future<int> updateOrder(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('orders', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteOrder(int id) async {
    Database db = await instance.database;
    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for stock
  Future<int> insertStock(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('stock', row);
  }

  Future<List<Map<String, dynamic>>> queryAllStock() async {
    Database db = await instance.database;
    return await db.query('stock');
  }

  Future<int> updateStock(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('stock', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteStock(int id) async {
    Database db = await instance.database;
    return await db.delete('stock', where: 'id = ?', whereArgs: [id]);
  }
}
