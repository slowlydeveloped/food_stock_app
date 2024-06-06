import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/utils/global_methos.dart';

import '../../blocs/ingredients_bloc/ingredients_bloc.dart';
import '../../data/database_helper.dart';

class AddIngredientPage extends StatefulWidget {
  final int vendorId;

  const AddIngredientPage({super.key, required this.vendorId});

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Ingredient')),
      body: BlocProvider(
        create: (context) =>
            IngredientBloc(databaseHelper: DatabaseHelper.instance),
        child: BlocListener<IngredientBloc, IngredientState>(
          listener: (context, state) {
            if (state is IngredientLoadSuccess) {
              showSnackBar(context, "Ingredients added");
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _unitController,
                    decoration: const InputDecoration(labelText: 'Unit'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a unit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<IngredientBloc>().add(AddIngredient(
                              name: _nameController.text,
                              price: double.parse(_priceController.text),
                              unit: _unitController.text,
                              vendorId: widget.vendorId,
                            ));
                      }
                      _nameController.clear();
                      _priceController.clear();
                      _unitController.clear();
                    },
                    child: const Text('Add Ingredient'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
