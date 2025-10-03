import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibra/features/home/bloc/create_post_bloc.dart';
import 'package:vibra/features/home/repositories/post_repository.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CreatePostBloc(postRepository: context.read<PostRepository>()),
      child: const CreatePostView(),
    );
  }
}

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Vibra'),
      ),
      body: BlocListener<CreatePostBloc, CreatePostState>(
        listener: (context, state) {
          if (state is CreatePostSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Vibra publicada!')),
              );
            Navigator.of(context).pop();
          }
          if (state is CreatePostFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Error al publicar: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: '¿Qué estás pensando?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              BlocBuilder<CreatePostBloc, CreatePostState>(
                builder: (context, state) {
                  if (state is CreatePostInProgress) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        context
                            .read<CreatePostBloc>()
                            .add(PostSubmitted(content: _textController.text));
                      }
                    },
                    child: const Text('Publicar'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}