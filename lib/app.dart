import 'package:flutter/material.dart';
import 'features/auth/presentation/auth_gate.dart';

class UbuntuTechApp extends StatelessWidget {
  const UbuntuTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UbuntuTech',
      home: const AuthGate(),
    );
  }
}