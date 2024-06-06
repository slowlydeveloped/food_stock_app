import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/order_bloc/order_bloc.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    BlocProvider.of<OrderBloc>(context).add(LoadOrders());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final recipe = state.orders[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe['recipe_name'] ?? ''.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('Quantity: ${recipe['quantity'] ?? ''}'),
                        Text('Total Price: ₹ ${recipe['total_price'] ?? ''}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No orders found'));
          }
        },
      ),
    );
  }
}

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _recipeIdController = TextEditingController();
  final _recipeNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _totalPriceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Orders"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _recipeIdController,
                decoration: const InputDecoration(labelText: 'Recipe ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipe ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _recipeNameController,
                decoration: const InputDecoration(labelText: 'Recipe Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipe name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _totalPriceController,
                decoration: const InputDecoration(labelText: 'Total Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the total price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Add order to database
                      final newOrder = {
                        'recipe_id': int.parse(_recipeIdController.text),
                        'recipe_name': _recipeNameController.text,
                        'quantity': int.parse(_quantityController.text),
                        'total_price': double.parse(_totalPriceController.text),
                      };
                      context.read<OrderBloc>().add(AddOrder(newOrder));
                      _recipeIdController.clear();
                      _recipeNameController.clear();
                      _quantityController.clear();
                      _totalPriceController.clear();
                    }
                  },
                  child: const Text("Add Orders")),
              const SizedBox(height: 18),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrdersScreen()));
                  },
                  child: const Text("ViewOrders"))
            ],
          ),
        ),
      ),
    );
  }
}
