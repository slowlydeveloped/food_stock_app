part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadOrders extends OrderEvent {}

class AddOrder extends OrderEvent {
  final Map<String, dynamic> order;

  const AddOrder(this.order);

  @override
  List<Object> get props => [order];
}

class UpdateOrder extends OrderEvent {
  final Map<String, dynamic> order;

  const UpdateOrder(this.order);

  @override
  List<Object> get props => [order];
}

class DeleteOrder extends OrderEvent {
  final int id;

  const DeleteOrder(this.id);

  @override
  List<Object> get props => [id];
}
