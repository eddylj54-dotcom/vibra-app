import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibra/features/auth/bloc/auth_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FORMA SEGURA DE ACCEDER AL USUARIO
    final state = context.read<AuthBloc>().state;
    final user = state is Authenticated ? state.user : null;

    // FORMA SEGURA DE OBTENER EL PRIMER NOMBRE
    final firstName = user?.displayName?.split(' ').first ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a Vibra'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FORMA SEGURA DE MOSTRAR LA FOTO DE PERFIL
            if (user?.photoURL != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user!.photoURL!),
              )
            else
              // Muestra un ícono por defecto si no hay foto
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            const SizedBox(height: 24),
            Text(
              'Hola, $firstName!',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}