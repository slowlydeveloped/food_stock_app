import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/blocs/vendor_bloc/vendor_event.dart';
import 'package:task1/blocs/vendor_bloc/vendor_state.dart';
import 'package:task1/blocs/vendor_bloc/vendor_bloc.dart';
import 'vendor_detail_screen.dart';

class VendorScreen extends StatelessWidget {
  const VendorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<VendorBloc>(context).add(LoadVendors());
    return Scaffold(
      appBar: AppBar(title: Text('Vendors')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<VendorBloc>(context).add(LoadVendors());
            },
            child: const Text('Load Vendors'),
          ),
          BlocBuilder<VendorBloc, VendorState>(
            builder: (context, state) {
              if (state is VendorLoadInProgress) {
                return const CircularProgressIndicator();
              } else if (state is VendorLoadSuccess) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.vendors.length,
                    itemBuilder: (context, index) {
                      final vendor = state.vendors[index];
                      return ListTile(
                        title: Text(vendor['name']),
                        subtitle: Text(vendor['contact']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VendorDetailScreen(
                                vendorId: vendor['id'],
                                vendorName: vendor['name'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              } else {
                return const Text('Failed to load vendors');
              }
            },
          ),
        ],
      ),
    );
  }
}
