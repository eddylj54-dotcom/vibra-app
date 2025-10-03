part of 'create_post_bloc.dart';

abstract class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object> get props => [];
}

class CreatePostInitial extends CreatePostState {}

class CreatePostInProgress extends CreatePostState {}

class CreatePostSuccess extends CreatePostState {}

class CreatePostFailure extends CreatePostState {
  final String error;

  const CreatePostFailure(this.error);

  @override
  List<Object> get props => [error];
}
