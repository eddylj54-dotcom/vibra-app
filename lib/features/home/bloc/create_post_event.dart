part of 'create_post_bloc.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];
}

class PostSubmitted extends CreatePostEvent {
  final String content;

  const PostSubmitted({required this.content});

  @override
  List<Object> get props => [content];
}
