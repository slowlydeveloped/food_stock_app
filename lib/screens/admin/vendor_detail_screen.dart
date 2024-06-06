import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/ingredients_bloc/ingredients_bloc.dart';
import '../../data/database_helper.dart';
import 'add_ingredients_page.dart';

class VendorDetailScreen extends StatelessWidget {
  final int vendorId;
  final String vendorName;

  const VendorDetailScreen(
      {super.key, required this.vendorId, required this.vendorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(vendorName)),
      body: BlocProvider(
        create: (context) =>
            IngredientBloc(databaseHelper: DatabaseHelper.instance)
              ..add(LoadIngredients()),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddIngredientPage(vendorId: vendorId)),
                  );
                },
                child: const Text('Add Ingredient'),
              ),
              const SizedBox(height: 12),
              BlocBuilder<IngredientBloc, IngredientState>(
                builder: (context, state) {
                  if (state is IngredientLoadInProgress) {
                    return const CircularProgressIndicator();
                  } else if (state is IngredientLoadSuccess) {
                    final vendorIngredients = state.ingredients
                        .where(
                            (ingredient) => ingredient['vendor_id'] == vendorId)
                        .toList();
                    return Expanded(
                      child: ListView.builder(
                        itemCount: vendorIngredients.length,
                        itemBuilder: (context, index) {
                          final ingredient = vendorIngredients[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ingredient['name']),
                                  Text('Price: ${ingredient['price']}'),
                                  Text('Unit: ${ingredient['unit']}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text('Failed to load ingredients');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
