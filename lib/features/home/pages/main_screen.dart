import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibra/features/auth/bloc/auth_bloc.dart';
import 'package:vibra/features/home/pages/create_post_page.dart';
import 'package:vibra/features/home/screens/home_page.dart';
import 'package:vibra/features/home/widgets/app_drawer.dart';
import 'package:vibra/features/profile/pages/profile_page.dart';
import 'package:vibra/features/profile/pages/guest_profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = <String>['Inicio', 'Perfil'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          setState(() {
            _selectedIndex = 0; // Go to home page on logout
          });
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Has cerrado sesión.')),
            );
        }
      },
      builder: (context, state) {
        final widgetOptions = <Widget>[
          const HomePage(),
          (state is Authenticated)
              ? const ProfilePage()
              : const GuestProfilePage(),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(_titles.elementAt(_selectedIndex)),
          ),
          drawer: const AppDrawer(),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
          floatingActionButton: (state is Authenticated)
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreatePostPage()),
                    );
                  },
                  tooltip: 'Crear Vibra',
                  child: const Icon(Icons.add),
                )
              : const SizedBox.shrink(),
          body: Center(
            child: widgetOptions.elementAt(_selectedIndex),
          ),
        );
      },
    );
  }
}
