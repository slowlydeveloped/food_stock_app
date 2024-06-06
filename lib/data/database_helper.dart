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

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
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
        total_price REAL NOT NULL,
        date TEXT NOT NULL,
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
    return await db.update('ingredients', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteIngredient(int id) async {
    Database db = await instance.database;
    return await db.delete('ingredients', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for recipes
  Future<int> insertRecipe(Map<String, dynamic> recipe) async {
    Database db = await instance.database;

    // Insert recipe into recipes table
    int recipeId = await db.insert('recipes', {
      'name': recipe['name'],
      'ingredients': jsonEncode(recipe['ingredients']), 
    });
    return recipeId;
  }

  Future<List<Map<String, dynamic>>> queryAllRecipes() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> recipes = await db.query('recipes');
    for (var recipe in recipes) {
      List<dynamic> ingredientsJson = jsonDecode(recipe['ingredients']);
      List<Map<String, dynamic>> ingredients =
          List<Map<String, dynamic>>.from(ingredientsJson);
      recipe['ingredients'] = ingredients;
    }
    return recipes;
  }

  Future<int> updateRecipe(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('recipes', row, where: 'id = ?', whereArgs: [id]);
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
        recipes.ingredients
      FROM recipes
    ''');

    for (var recipe in recipesWithDetails) {
      // Deserialize ingredients JSON string back into a list of maps
      List<dynamic> ingredientsJson = jsonDecode(recipe['ingredients']);
      List<Map<String, dynamic>> ingredients =
          List<Map<String, dynamic>>.from(ingredientsJson);
      recipe['ingredients'] = ingredients;
    }
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

    // Update stock after the order
    await updateStockAfterOrder(orderDetails['recipe_id'], orderDetails['quantity']);

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
        orders.date
      FROM orders
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

  // Helper method to calculate total price for a recipe
  double calculateTotalPrice(List<dynamic> ingredients) {
    double totalPrice = 0;
    for (var ingredient in ingredients) {
      totalPrice += ingredient['price'] * ingredient['quantity'];
    }
    return totalPrice;
  }

  // Method to get ingredients and their quantities for a recipe
  Future<List<Map<String, dynamic>>> getIngredientsForRecipe(int recipeId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> recipes = await db.query(
      'recipes',
      where: 'id = ?',
      whereArgs: [recipeId],
    );

    if (recipes.isEmpty) {
      throw Exception('Recipe not found');
    }

    String ingredientsJson = recipes.first['ingredients'];
    List<dynamic> ingredientsList = jsonDecode(ingredientsJson);

    return List<Map<String, dynamic>>.from(ingredientsList);
  }

  // Method to calculate remaining stock for each ingredient used in a recipe
  Future<Map<String, double>> calculateRemainingStock(int recipeId) async {
    Database db = await instance.database;

    // Get the ingredients and their quantities for the recipe
    List<Map<String, dynamic>> recipeIngredients = await getIngredientsForRecipe(recipeId);

    // Initialize a map to store the remaining stock of each ingredient
    Map<String, double> remainingStock = {};

    // Iterate over each ingredient used in the recipe
    for (var ingredient in recipeIngredients) {
      int ingredientId = ingredient['id'];
      double quantityUsed = ingredient['quantity'];

      // Get the total inward and outward stock for the ingredient
      List<Map<String, dynamic>> stockData = await db.rawQuery('''
        SELECT 
          IFNULL(SUM(CASE WHEN type = 'inward' THEN quantity ELSE 0 END), 0) AS total_inward,
          IFNULL(SUM(CASE WHEN type = 'outward' THEN quantity ELSE 0 END), 0) AS total_outward
        FROM stock
        WHERE ingredient_id = ?
      ''', [ingredientId]);

      if (stockData.isNotEmpty) {
        double totalInward = stockData.first['total_inward'];
        double totalOutward = stockData.first['total_outward'];

        // Calculate the remaining stock
        double currentStock = totalInward - totalOutward;

        // Calculate the remaining stock after using the quantity for the recipe
        double remaining = currentStock - quantityUsed;

        remainingStock[ingredient['name']] = remaining;
      }
    }

    return remainingStock;
  }

  // Method to update stock after placing an order
  Future<void> updateStockAfterOrder(int recipeId, int quantityOrdered) async {
    Database db = await instance.database;

    // Get the ingredients and their quantities for the recipe
    List<Map<String, dynamic>> recipeIngredients = await getIngredientsForRecipe(recipeId);

    // Update the stock for each ingredient used in the recipe
    for (var ingredient in recipeIngredients) {
      int ingredientId = ingredient['id'];
      double quantityUsed = ingredient['quantity'] * quantityOrdered;

      // Insert an 'outward' stock transaction for the used quantity
      await db.insert('stock', {
        'ingredient_id': ingredientId,
        'quantity': quantityUsed,
        'type': 'outward',
        'date': DateTime.now().toString(),
      });
    }
  }
}
