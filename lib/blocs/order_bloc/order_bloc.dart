import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/database_helper.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final DatabaseHelper databaseHelper;

  OrderBloc({required this.databaseHelper}) : super(OrderLoading()) {
    on<LoadOrders>((event, emit) async {
      emit(OrderLoading());
      try {
        final orders = await databaseHelper.queryAllOrdersWithDetails();
        emit(OrderLoaded(orders));
      } catch (e) {
        emit(OrderError('Failed to load orders'));
      }
    });

    on<AddOrder>((event, emit) async {
      try {
        await databaseHelper.insertOrder(event.order);
        final orders = await databaseHelper.queryAllOrdersWithDetails();
            
        emit(OrderLoaded(orders));
      } catch (e) {
        emit(OrderError('Failed to add order'));
      }
    });

    on<UpdateOrder>((event, emit) async {
      try {
        await databaseHelper.updateOrder(event.order);
        final orders = await databaseHelper.queryAllOrdersWithDetails();
        emit(OrderLoaded(orders));
      } catch (e) {
        emit(OrderError('Failed to update order'));
      }
    });

    on<DeleteOrder>((event, emit) async {
      try {
        await databaseHelper.deleteOrder(event.id);
        final orders = await databaseHelper.queryAllOrdersWithDetails();
        emit(OrderLoaded(orders));
      } catch (e) {
        emit(OrderError('Failed to delete order'));
      }
    });
  }
}