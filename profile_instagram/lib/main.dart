import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const InstagramProfileApp());
}

class InstagramProfileApp extends StatelessWidget {
  const InstagramProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Instagram Profile",
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const ProfileScreen(),
    );
  }
}