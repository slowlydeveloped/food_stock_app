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
      appBar: AppBar(title: const Text('Vendors')),
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
                      return InkWell(
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
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vendor['name']),
                                Text(vendor['contact']),
                              ],
                            ),
                          ),
                        ),
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
