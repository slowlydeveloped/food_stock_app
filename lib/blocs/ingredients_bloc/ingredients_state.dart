part of 'ingredients_bloc.dart';

class IngredientState extends Equatable {
  const IngredientState();

  @override
  List<Object> get props => [];
}

class IngredientInitial extends IngredientState {}

class IngredientLoadInProgress extends IngredientState {}

class IngredientLoadSuccess extends IngredientState {
  final List<Map<String, dynamic>> ingredients;

  const IngredientLoadSuccess([this.ingredients = const []]);

  @override
  List<Object> get props => [ingredients];
}

class IngredientOperationFailure extends IngredientState {}
