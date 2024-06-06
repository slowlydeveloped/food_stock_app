import 'package:flutter/material.dart';
import 'admin_home_page.dart';
import 'manager_home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminHomePage()),
                );
              },
              child: const Text('Admin Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManagerHomePage()),
                );
              },
              child: const Text('Manager Login'),
            ),
          ],
        ),
      ),
    );
  }
}
