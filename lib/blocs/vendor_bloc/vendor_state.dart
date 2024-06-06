import 'package:equatable/equatable.dart';

class VendorState extends Equatable {
  const VendorState();

  @override
  List<Object> get props => [];
}

class VendorInitial extends VendorState {}

class VendorLoadInProgress extends VendorState {}

class VendorLoadSuccess extends VendorState {
  final List<Map<String, dynamic>> vendors;

  const VendorLoadSuccess([this.vendors = const []]);

  @override
  List<Object> get props => [vendors];
}

class VendorOperationFailure extends VendorState {}
