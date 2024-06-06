part of 'stock_bloc.dart';

abstract class StockState extends Equatable {
  const StockState();

  @override
  List<Object> get props => [];
}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class StockLoaded extends StockState {
  final List<Map<String, dynamic>> inwardStock;
  final List<Map<String, dynamic>> outwardStock;
  final Map<String, double> remainingStock;

  const StockLoaded({
    required this.inwardStock,
    required this.outwardStock,
    required this.remainingStock,
  });
}

class StockError extends StockState {
  final String message;

  const StockError(this.message);
}
