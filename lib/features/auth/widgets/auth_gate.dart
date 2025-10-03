// lib/features/auth/widgets/auth_gate.dart
import 'package:flutter/material.dart';
import 'package:vibra/features/navigation/pages/main_navigation_screen.dart'; // Cambiado a la nueva navegación principal con pestañas

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // La app ahora empieza en la pantalla de navegación principal.
    return const MainNavigationScreen();
  }
}