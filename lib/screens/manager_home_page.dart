import 'package:flutter/material.dart';
import 'package:task1/screens/order_page.dart';

class ManagerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manager Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const OrderList()));
                // Implement the manager functionalities here
              },
              child: Text('Order Page'),
            ),
          ],
        ),
      ),
    );
  }
}
