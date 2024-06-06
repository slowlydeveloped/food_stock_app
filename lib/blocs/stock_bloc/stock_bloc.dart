import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/database_helper.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final DatabaseHelper databaseHelper;

  StockBloc({required this.databaseHelper}) : super(StockLoading()) {
    on<LoadStock>(_onLoadStock);
  }

  Future<void> _onLoadStock(LoadStock event, Emitter<StockState> emit) async {
    try {
      emit(StockLoading());
      final inwardStock = await databaseHelper.getInwardStock();
      final outwardStock = await databaseHelper.getOutwardStock();
      final remainingStock = await databaseHelper.getRemainingStock();
      emit(StockLoaded(
        inwardStock: inwardStock,
        outwardStock: outwardStock,
        remainingStock: remainingStock,
      ));
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }
}
