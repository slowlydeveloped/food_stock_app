import 'package:flutter/material.dart';
import 'add_vendor_page.dart';
import 'add_recipe_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddVendorPage()),
                );
              },
              child: Text('Add Vendor'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRecipePage()),
                );
              },
              child: Text('Add Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
