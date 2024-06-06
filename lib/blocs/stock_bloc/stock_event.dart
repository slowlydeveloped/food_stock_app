part of 'stock_bloc.dart';

abstract class StockEvent extends Equatable {
  const StockEvent();

  @override
  List<Object> get props => [];
}

class LoadStock extends StockEvent {}

class LoadStockForRecipe extends StockEvent {
  final int recipeId;

  const LoadStockForRecipe(this.recipeId);

}