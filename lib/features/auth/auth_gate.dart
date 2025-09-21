import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibra/features/auth/screens/login_screen.dart'; // Adjusted path
import 'package:vibra/features/home/screens/home_page.dart';  // Adjusted path

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Escuchamos el stream de cambios de autenticación de Firebase
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Si todavía está esperando la conexión, muestra un loader
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Si el snapshot tiene datos, significa que el usuario está logueado
        if (snapshot.hasData) {
          return const HomePage();
        }

        // Si no tiene datos, el usuario no está logueado
        return const LoginScreen();
      },
    );
  }
}
