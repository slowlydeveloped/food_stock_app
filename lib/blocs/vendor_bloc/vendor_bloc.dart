import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
import '../../data/database_helper.dart';
import 'vendor_event.dart';
import 'vendor_state.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final DatabaseHelper databaseHelper;

  VendorBloc({required this.databaseHelper}) : super(VendorInitial()) {
    on<LoadVendors>(_onLoadVendors);
    on<AddVendor>(_onAddVendor);
    on<UpdateVendor>(_onUpdateVendor);
    on<DeleteVendor>(_onDeleteVendor);
  }

  void _onLoadVendors(LoadVendors event, Emitter<VendorState> emit) async {
    emit(VendorLoadInProgress());
    try {
      final vendors = await databaseHelper.queryAllVendors();
      emit(VendorLoadSuccess(vendors));
    } catch (_) {
      emit(VendorOperationFailure());
    }
  }

  void _onAddVendor(AddVendor event, Emitter<VendorState> emit) async {
    try {
      await databaseHelper.insertVendor({'name': event.name, 'contact': event.contact});
      final vendors = await databaseHelper.queryAllVendors();
      emit(VendorLoadSuccess(vendors));
    } catch (_) {
      emit(VendorOperationFailure());
    }
  }

  void _onUpdateVendor(UpdateVendor event, Emitter<VendorState> emit) async {
    try {
      await databaseHelper.updateVendor({'id': event.id, 'name': event.name, 'contact': event.contact});
      final vendors = await databaseHelper.queryAllVendors();
      emit(VendorLoadSuccess(vendors));
    } catch (_) {
      emit(VendorOperationFailure());
    }
  }

  void _onDeleteVendor(DeleteVendor event, Emitter<VendorState> emit) async {
    try {
      await databaseHelper.deleteVendor(event.id);
      final vendors = await databaseHelper.queryAllVendors();
      emit(VendorLoadSuccess(vendors));
    } catch (_) {
      emit(VendorOperationFailure());
    }
  }
}
