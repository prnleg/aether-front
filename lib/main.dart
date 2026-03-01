import 'package:flutter/material.dart';
import 'presentation/pages/dashboard_page.dart';

void main() {
  runApp(const AetherApp());
}

class AetherApp extends StatelessWidget {
  const AetherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aether',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E3192),
          primary: const Color(0xFF2E3192),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const DashboardPage(),
    );
  }
}
