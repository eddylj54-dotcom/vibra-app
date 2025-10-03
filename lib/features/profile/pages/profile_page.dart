// lib/features/profile/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibra/features/auth/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.user;
            final firstName = user.displayName?.split(' ').first ?? 'Usuario';
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (user.photoURL != null)
                    CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.photoURL!))
                  else
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
                  const SizedBox(height: 20),
                  Text('Hola, $firstName!',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () =>
                        context.read<AuthBloc>().add(AuthLogoutRequested()),
                    child: const Text('Cerrar Sesión'),
                  ),
                ],
              ),
            );
          } else if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            // For Unauthenticated, AuthInitial, AuthError
            return const Center(
              child: Text('No se pudo cargar el perfil de usuario.'),
            );
          }
        },
      ),
    );
  }
}