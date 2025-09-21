
// [Ubicación: tu archivo de la página de login]

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Keep this import for now, as the original code used it.

import 'package:vibra/features/auth/bloc/auth_bloc.dart'; // Keep this import for now, as the original code used it.


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView( // Solución para el overflow
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),

                  const Text(
                    'Iniciar Sesión',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Por favor, inicia sesión',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 48),

                  TextFormField(
                    controller: _emailController, // Added controller
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController, // Added controller
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  BlocBuilder<AuthBloc, AuthState>( // Re-added BlocBuilder
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const CircularProgressIndicator();
                      }
                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                    AuthLoginWithEmailPasswordRequested(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4DB6AC),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Iniciar Sesión con Email'),
                          ),
                          const SizedBox(height: 48),

                          OutlinedButton.icon( // Solución para el ícono de Google
                            icon: const FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.deepPurple,
                              size: 20,
                            ),
                            label: const Text(
                              'Continuar con Google',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                    const AuthLoginWithGoogleRequested(),
                                  );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const Spacer(flex: 3)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
