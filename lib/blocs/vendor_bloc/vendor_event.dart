import 'package:equatable/equatable.dart';

abstract class VendorEvent extends Equatable {
  const VendorEvent();

  @override
  List<Object> get props => [];
}

class LoadVendors extends VendorEvent {}

class AddVendor extends VendorEvent {
  final String name;
  final String contact;

  const AddVendor({required this.name, required this.contact});

  @override
  List<Object> get props => [name, contact];
}

class UpdateVendor extends VendorEvent {
  final int id;
  final String name;
  final String contact;

  const UpdateVendor({required this.id, required this.name, required this.contact});

  @override
  List<Object> get props => [id, name, contact];
}

class DeleteVendor extends VendorEvent {
  final int id;

  const DeleteVendor({required this.id});

  @override
  List<Object> get props => [id];
}
