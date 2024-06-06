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
        create: (context) => StockBloc(databaseHelper: DatabaseHelper.instance)..add(LoadStock()),
        child: BlocBuilder<StockBloc, StockState>(
          builder: (context, state) {
            if (state is StockLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StockLoaded) {
              return ListView(
                children: [
                  _buildStockSection('Inward Stock', state.inwardStock),
                  _buildStockSection('Outward Stock', state.outwardStock),
                  _buildRemainingStockSection('Remaining Stock', state.remainingStock),
                ],
              );
            } else if (state is StockError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildStockSection(String title, List<Map<String, dynamic>> stock) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...stock.map((entry) {
              return ListTile(
                title: Text('Unit: ${entry['unit']}'), // Display unit instead of ID
                subtitle: Text('Quantity: ${entry['quantity']}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRemainingStockSection(String title, Map<String, double> remainingStock) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ...remainingStock.entries.map((entry) {
              return ListTile(
                title: Text('Ingredient ID: ${entry.key}'),
                subtitle: Text('Remaining Quantity: ${entry.value}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
