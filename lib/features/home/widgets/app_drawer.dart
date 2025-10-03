import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibra/features/auth/bloc/auth_bloc.dart';
import 'package:vibra/features/settings/pages/settings_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          Widget header = const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Bienvenido a Vibra',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          );

          if (state is Authenticated) {
            header = UserAccountsDrawerHeader(
              accountName: Text(state.user.displayName ?? 'Usuario'),
              accountEmail: Text(state.user.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    state.user.photoURL != null ? NetworkImage(state.user.photoURL!) : null,
                child: state.user.photoURL == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              header,
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Inicio'),
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                onTap: () {
                  Navigator.pop(context); // Cierra el drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
              ),
              const Divider(),
              if (state is Authenticated)
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Cerrar Sesión'),
                  onTap: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                    Navigator.pop(context); // Cierra el drawer
                  },
                )
              else
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Iniciar Sesión'),
                  onTap: () {
                    // TODO: Implementar navegación a la página de login si es necesario
                    Navigator.pop(context); // Cierra el drawer
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}