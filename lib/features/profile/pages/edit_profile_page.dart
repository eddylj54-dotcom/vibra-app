import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vibra/features/auth/repositories/auth_repository.dart';
import 'package:vibra/features/profile/bloc/edit_profile_bloc.dart';
import 'package:vibra/features/profile/bloc/edit_profile_event.dart';
import 'package:vibra/features/profile/bloc/edit_profile_state.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBloc(
        authRepository: context.read<AuthRepository>(),
      ),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController(text: currentUser?.displayName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context
          .read<EditProfileBloc>()
          .add(EditProfileSubmitted(newName: _nameController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: BlocListener<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Perfil actualizado con éxito')),
              );
            Navigator.of(context).pop();
          } else if (state is EditProfileFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Simulación de selección de foto
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                          ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                          : null,
                      child: FirebaseAuth.instance.currentUser?.photoURL == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: () {
                            // Simulación: En una implementación real, aquí llamarías a image_picker
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('La selección de fotos no está implementada aún.'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de usuario',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<EditProfileBloc, EditProfileState>(
                  builder: (context, state) {
                    if (state is EditProfileLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Guardar Cambios'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
