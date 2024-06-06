import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/database_helper.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final DatabaseHelper databaseHelper;

  StockBloc(this.databaseHelper) : super(StockInitial()) {
    on<LoadStockForRecipe>(_onLoadStockForRecipe);
  }

  Future<void> _onLoadStockForRecipe(
      LoadStockForRecipe event, Emitter<StockState> emit) async {
    emit(StockLoading());
    try {
      final remainingStock =
          await databaseHelper.calculateRemainingStock(event.recipeId);
      emit(StockLoaded(remainingStock));
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }
}
