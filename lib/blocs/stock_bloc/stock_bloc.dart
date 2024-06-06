import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/database_helper.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final DatabaseHelper databaseHelper;

  StockBloc({required this.databaseHelper}) : super(StockLoading()) {
    on<LoadStock>((event, emit) async {
      emit(StockLoading());
      try {
        final stock = await databaseHelper.queryAllStock();
        emit(StockLoaded(stock));
      } catch (e) {
        emit(StockError('Failed to load stock'));
      }
    });

    on<AddStock>((event, emit) async {
      try {
        await databaseHelper.insertStock(event.stock);
        final stock = await databaseHelper.queryAllStock();
        emit(StockLoaded(stock));
      } catch (e) {
        emit(StockError('Failed to add stock'));
      }
    });

    on<UpdateStock>((event, emit) async {
      try {
        await databaseHelper.updateStock(event.stock);
        final stock = await databaseHelper.queryAllStock();
        emit(StockLoaded(stock));
      } catch (e) {
        emit(StockError('Failed to update stock'));
      }
    });

    on<DeleteStock>((event, emit) async {
      try {
        await databaseHelper.deleteStock(event.id);
        final stock = await databaseHelper.queryAllStock();
        emit(StockLoaded(stock));
      } catch (e) {
        emit(StockError('Failed to delete stock'));
      }
    });
  }
}