import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/utils/global_methos.dart';

import '../blocs/vendor_bloc/vendor_bloc.dart';
import '../blocs/vendor_bloc/vendor_event.dart';
import '../blocs/vendor_bloc/vendor_state.dart';
import '../data/database_helper.dart';
import 'view_vendors.dart';

class AddVendorPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();

  AddVendorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Vendor')),
      body: BlocProvider(
        create: (context) =>
            VendorBloc(databaseHelper: DatabaseHelper.instance),
        child: BlocListener<VendorBloc, VendorState>(
          listener: (context, state) {
            if (state is VendorLoadSuccess) {
              showSnackBar(context, "Vendor added successfully");
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _contactController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Contact'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a contact';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<VendorBloc>().add(AddVendor(
                              name: _nameController.text,
                              contact: _contactController.text,
                            ));
                        showSnackBar(context, "Vendor added");
                      }
                      _nameController.clear();
                      _contactController.clear();
                    },
                    child: Text('Add Vendor'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VendorScreen()),
                      );
                    },
                    child: Text('View Vendor'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
