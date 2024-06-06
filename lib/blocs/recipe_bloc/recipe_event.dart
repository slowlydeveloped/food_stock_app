part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipeEvent {}

class AddRecipe extends RecipeEvent {
  final Map<String, dynamic> recipe;

  const AddRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class UpdateRecipe extends RecipeEvent {
  final Map<String, dynamic> recipe;

  const UpdateRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class DeleteRecipe extends RecipeEvent {
  final int id;

  const DeleteRecipe(this.id);

  @override
  List<Object> get props => [id];
}