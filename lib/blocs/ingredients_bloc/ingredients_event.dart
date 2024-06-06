part of 'ingredients_bloc.dart';

abstract class IngredientEvent extends Equatable {
  const IngredientEvent();

  @override
  List<Object> get props => [];
}

class LoadIngredients extends IngredientEvent {}

class AddIngredient extends IngredientEvent {
  final String name;
  final double price;
  final String unit;
  final int vendorId;

  const AddIngredient({required this.name, required this.price, required this.unit, required this.vendorId});

  @override
  List<Object> get props => [name, price, unit, vendorId];
}

class UpdateIngredient extends IngredientEvent {
  final int id;
  final String name;
  final double price;
  final String unit;
  final int vendorId;

  const UpdateIngredient({required this.id, required this.name, required this.price, required this.unit, required this.vendorId});

  @override
  List<Object> get props => [id, name, price, unit, vendorId];
}

class DeleteIngredient extends IngredientEvent {
  final int id;

  const DeleteIngredient({required this.id});

  @override
  List<Object> get props => [id];
}
