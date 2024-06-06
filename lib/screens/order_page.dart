import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class OrderList extends StatelessWidget {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.queryAllOrdersWithDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final orders = snapshot.data ?? [];
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                leading: Text('Order ${order['id']}'),
                title: Text(order['recipe_name']), // Display recipe name as title
                subtitle: Text('Date: ${order['date']}'),
                // You can add more UI components here to display additional order details
              );
            },
          );
        }
      },
    );
  }
}
