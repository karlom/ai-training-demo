import 'package:flutter/material.dart';
import 'screens/user_profile_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fintech Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserProfilePage(),
    );
  }
}
