import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/database_helper.dart';

part 'ingredients_event.dart';
part 'ingredients_state.dart';

class IngredientBloc extends Bloc<IngredientEvent, IngredientState> {
  final DatabaseHelper databaseHelper;

  IngredientBloc({required this.databaseHelper}) : super(IngredientInitial()) {
    on<LoadIngredients>(_onLoadIngredients);
    on<AddIngredient>(_onAddIngredient);
    on<UpdateIngredient>(_onUpdateIngredient);
    on<DeleteIngredient>(_onDeleteIngredient);
  }

  void _onLoadIngredients(LoadIngredients event, Emitter<IngredientState> emit) async {
    emit(IngredientLoadInProgress());
    try {
      final ingredients = await databaseHelper.queryAllIngredients();
      emit(IngredientLoadSuccess(ingredients));
    } catch (_) {
      emit(IngredientOperationFailure());
    }
  }

  void _onAddIngredient(AddIngredient event, Emitter<IngredientState> emit) async {
    try {
      await databaseHelper.insertIngredient({
        'name': event.name,
        'price': event.price,
        'unit': event.unit,
        'vendor_id': event.vendorId,
      });
      final ingredients = await databaseHelper.queryAllIngredients();
      emit(IngredientLoadSuccess(ingredients));
    } catch (_) {
      emit(IngredientOperationFailure());
    }
  }

  void _onUpdateIngredient(UpdateIngredient event, Emitter<IngredientState> emit) async {
    try {
      await databaseHelper.updateIngredient({
        'id': event.id,
        'name': event.name,
        'price': event.price,
        'unit': event.unit,
        'vendor_id': event.vendorId,
      });
      final ingredients = await databaseHelper.queryAllIngredients();
      emit(IngredientLoadSuccess(ingredients));
    } catch (_) {
      emit(IngredientOperationFailure());
    }
  }

  void _onDeleteIngredient(DeleteIngredient event, Emitter<IngredientState> emit) async {
    try {
      await databaseHelper.deleteIngredient(event.id);
      final ingredients = await databaseHelper.queryAllIngredients();
      emit(IngredientLoadSuccess(ingredients));
    } catch (_) {
      emit(IngredientOperationFailure());
    }
  }
}