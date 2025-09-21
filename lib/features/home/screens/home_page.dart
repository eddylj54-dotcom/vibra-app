import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String userName = user?.displayName ?? user?.email ?? 'Usuario';
    if (userName.contains(' ')) {
      userName = userName.split(' ')[0];
    }
    final userPhotoUrl = user?.photoURL;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a Vibra'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Con esto cerramos la sesión
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (userPhotoUrl != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userPhotoUrl),
              ),
            const SizedBox(height: 20),
            Text(
              '¡Hola, $userName!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
