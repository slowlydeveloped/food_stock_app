import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/stock_bloc/stock_bloc.dart';
import '../../data/database_helper.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Details')),
      body: BlocProvider(
        create: (context) => StockBloc(DatabaseHelper.instance)..add(const LoadStockForRecipe(1)), // Example recipeId
        child: BlocBuilder<StockBloc, StockState>(
          builder: (context, state) {
            if (state is StockLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StockLoaded) {
              return ListView.builder(
                itemCount: state.remainingStock.length,
                itemBuilder: (context, index) {
                  String ingredientName = state.remainingStock.keys.elementAt(index);
                  double remainingQuantity = state.remainingStock[ingredientName]!;
                  return ListTile(
                    title: Text(ingredientName),
                    subtitle: Text('Remaining: $remainingQuantity'),
                  );
                },
              );
            } else if (state is StockError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Center(child: Text('Select a recipe to view stock'));
          },
        ),
      ),
    );
  }
}
