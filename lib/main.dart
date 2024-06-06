import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/blocs/order_bloc/order_bloc.dart';
import 'package:task1/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:task1/blocs/ingredients_bloc/ingredients_bloc.dart';
import 'package:task1/blocs/stock_bloc/stock_bloc.dart';
import 'package:task1/screens/admin/main_page.dart';
import 'data/database_helper.dart';
import 'blocs/vendor_bloc/vendor_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              VendorBloc(databaseHelper: DatabaseHelper.instance),
        ),
        BlocProvider(
          create: (context) =>
              IngredientBloc(databaseHelper: DatabaseHelper.instance),
        ),
        BlocProvider(
          create: (context) =>
              RecipeBloc(databaseHelper: DatabaseHelper.instance),
        ),
        BlocProvider(
          create: (context) =>
              OrderBloc(databaseHelper: DatabaseHelper.instance),
        ),
        BlocProvider(
          create: (context) => StockBloc(databaseHelper: DatabaseHelper.instance),
        )
      ],
      child: const MaterialApp(
        title: 'Food Stock System',
        home: LoginPage(),
      ),
    );
  }
}
