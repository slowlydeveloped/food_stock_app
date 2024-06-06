part of 'stock_bloc.dart';

abstract class StockState extends Equatable {
  const StockState();

  @override
  List<Object> get props => [];
}

class StockLoading extends StockState {}

class StockLoaded extends StockState {
  final List<Map<String, dynamic>> stock;

  const StockLoaded(this.stock);

  @override
  List<Object> get props => [stock];
}

class StockError extends StockState {
  final String message;

  const StockError(this.message);

  @override
  List<Object> get props => [message];
}

