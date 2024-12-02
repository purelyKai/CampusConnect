import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String userEmail;

  const HomePage({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, '/signin'); // Log out and return to sign-in screen
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome, $userEmail!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
