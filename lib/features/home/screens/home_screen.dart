import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibra/features/auth/bloc/auth_bloc.dart';
import 'package:vibra/features/comments/pages/comments_page.dart'; // Importar CommentsPage
import 'package:vibra/features/home/bloc/feed_bloc.dart';
import 'package:vibra/features/home/repositories/post_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vibra Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => FeedBloc(
          postRepository: RepositoryProvider.of<PostRepository>(context),
        )..add(LoadFeed()),
        child: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (state is FeedLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FeedLoaded) {
              if (state.posts.isEmpty) {
                return const Center(
                  child: Text('No hay publicaciones todavía. ¡Sé el primero!'),
                );
              }
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final postDoc = state.posts[index]; // Obtener el DocumentSnapshot
                  final post = postDoc.data() as Map<String, dynamic>;
                  final authorName = post['authorName'] ?? 'Anónimo';
                  final content = post['content'] ?? '';

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CommentsPage(postId: postDoc.id), // Pasar el ID del post
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(content),
                      ),
                    ),
                  );
                },
              );
            }
            if (state is FeedError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Iniciando feed...'));
          },
        ),
      ),
    );
  }
}