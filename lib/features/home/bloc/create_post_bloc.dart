import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vibra/features/home/repositories/post_repository.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final PostRepository _postRepository;

  CreatePostBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(CreatePostInitial()) {
    on<PostSubmitted>(_onPostSubmitted);
  }

  void _onPostSubmitted(
      PostSubmitted event, Emitter<CreatePostState> emit) async {
    emit(CreatePostInProgress());
    try {
      await _postRepository.createPost(content: event.content);
      emit(CreatePostSuccess());
    } catch (e) {
      emit(CreatePostFailure(e.toString()));
    }
  }
}