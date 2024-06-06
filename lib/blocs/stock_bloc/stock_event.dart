part of 'stock_bloc.dart';

abstract class StockEvent extends Equatable {
  const StockEvent();

  @override
  List<Object> get props => [];
}

class LoadStock extends StockEvent {}

class AddStock extends StockEvent {
  final Map<String, dynamic> stock;

  const AddStock(this.stock);

  @override
  List<Object> get props => [stock];
}

class UpdateStock extends StockEvent {
  final Map<String, dynamic> stock;

  const UpdateStock(this.stock);

  @override
  List<Object> get props => [stock];
}

class DeleteStock extends StockEvent {
  final int id;

  const DeleteStock(this.id);

  @override
  List<Object> get props => [id];
}

