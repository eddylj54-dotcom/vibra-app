// lib/features/profile/pages/guest_profile_page.dart
import 'package:flutter/material.dart';
import 'package:vibra/features/auth/pages/login_page.dart';

class GuestProfilePage extends StatelessWidget {
  const GuestProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.waving_hand, size: 60, color: Colors.teal),
              const SizedBox(height: 20),
              const Text(
                'Únete a la comunidad de Vibra',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Crea una cuenta para compartir tus propias Vibras y conectar con otros.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Iniciar Sesión o Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
