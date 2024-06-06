import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/recipe_bloc/recipe_bloc.dart';
import '../data/database_helper.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({Key? key}) : super(key: key);

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<TextEditingController> _ingredientNameControllers = [TextEditingController()];
  final List<TextEditingController> _ingredientQuantityControllers = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Recipe')),
      body: BlocProvider(
        create: (context) =>
            RecipeBloc(databaseHelper: DatabaseHelper.instance),
        child: BlocListener<RecipeBloc, RecipeState>(
          listener: (context, state) {
            if (state is RecipeLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Recipe Added Successfully')),
              );
              Navigator.of(context).pop(); // Close the dialog
            } else if (state is RecipeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
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
                    decoration: const InputDecoration(labelText: 'Recipe Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a recipe name';
                      }
                      return null;
                    },
                  ),
                  ..._buildIngredientFields(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final List<Map<String, dynamic>> ingredients = [];
                        for (int i = 0; i < _ingredientNameControllers.length; i++) {
                          final name = _ingredientNameControllers[i].text;
                          final quantity = _ingredientQuantityControllers[i].text;
                          ingredients.add({'name': name, 'quantity': quantity});
                        }
                        final recipe = {
                          'name': _nameController.text,
                          'ingredients': ingredients,
                        };
                        BlocProvider.of<RecipeBloc>(context)
                            .add(AddRecipe(recipe));
                      }
                    },
                    child: const Text('Add Recipe'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _ingredientNameControllers.add(TextEditingController());
            _ingredientQuantityControllers.add(TextEditingController());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Widget> _buildIngredientFields() {
    return List<Widget>.generate(
      _ingredientNameControllers.length,
      (index) => Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _ingredientNameControllers[index],
              decoration: InputDecoration(
                labelText: 'Ingredient ${index + 1} Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an ingredient name';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _ingredientQuantityControllers[index],
              decoration: InputDecoration(
                labelText: 'Ingredient ${index + 1} Quantity',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an ingredient quantity';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
