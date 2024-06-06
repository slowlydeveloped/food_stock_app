part of 'recipe_bloc.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Map<String, dynamic>> recipes;

  const RecipeLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object> get props => [message];
}
