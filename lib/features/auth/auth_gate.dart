import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibra/features/auth/bloc/auth_bloc.dart';
import 'package:vibra/features/auth/pages/login_page.dart';
import 'package:vibra/features/home/pages/main_screen.dart'; // O tu pantalla principal

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const MainScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}