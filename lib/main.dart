import 'package:flutter/material.dart';
import 'login_page.dart'; // Make sure your login screen code is in login_page.dart

void main() {
  runApp(const SchoolPortalApp());
}

class SchoolPortalApp extends StatelessWidget {
  const SchoolPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oakridge School Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Campus Navy Primary
          primary: const Color(0xFF1E3A8A),
          surface: const Color(0xFFF3F4F6),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      ),
      home: const CleanLoginScreen(),
    );
  }
}