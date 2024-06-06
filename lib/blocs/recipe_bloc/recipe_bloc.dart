import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/database_helper.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final DatabaseHelper databaseHelper;

  RecipeBloc({required this.databaseHelper}) : super(RecipeLoading()) {
    on<LoadRecipes>((event, emit) async {
      emit(RecipeLoading());
      try {
        final recipes = await databaseHelper.queryAllRecipes();
        emit(RecipeLoaded(recipes));
      } catch (e) {
        emit(const RecipeError('Failed to load recipes'));
      }
    });

    on<AddRecipe>((event, emit) async {
      try {
        await databaseHelper.insertRecipe(event.recipe);
        final recipes = await databaseHelper.queryAllRecipes();
        emit(RecipeLoaded(recipes));
      } catch (e) {
        emit(const RecipeError('Failed to add recipe'));
      }
    });

    on<UpdateRecipe>((event, emit) async {
      try {
        await databaseHelper.updateRecipe(event.recipe);
        final recipes = await databaseHelper.queryAllRecipes();
        emit(RecipeLoaded(recipes));
      } catch (e) {
        emit(const RecipeError('Failed to update recipe'));
      }
    });

    on<DeleteRecipe>((event, emit) async {
      try {
        await databaseHelper.deleteRecipe(event.id);
        final recipes = await databaseHelper.queryAllRecipes();
        emit(RecipeLoaded(recipes));
      } catch (e) {
        emit(RecipeError('Failed to delete recipe'));
      }
    });
  }
}