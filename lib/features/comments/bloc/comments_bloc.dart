import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // No longer directly needed here
import 'package:vibra/features/auth/bloc/auth_bloc.dart';
import 'package:vibra/features/comments/models/comment_model.dart';
import 'package:vibra/features/home/repositories/post_repository.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _commentsSubscription;
  String? _currentPostId;

  CommentsBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        super(CommentsInitial()) {
    on<LoadComments>(_onLoadComments);
    on<AddComment>(_onAddComment);
    on<CommentsUpdated>(_onCommentsUpdated);
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentsState> emit,
  ) async {
    emit(CommentsLoading());
    _currentPostId = event.postId;
    _commentsSubscription?.cancel();
    _commentsSubscription = _postRepository
        .getCommentsStream(event.postId)
        .listen((comments) => add(CommentsUpdated(comments)));
  }

  void _onCommentsUpdated(
    CommentsUpdated event,
    Emitter<CommentsState> emit,
  ) {
    emit(CommentsLoaded(event.comments));
  }

  Future<void> _onAddComment(
    AddComment event,
    Emitter<CommentsState> emit,
  ) async {
    if (_currentPostId == null) {
      emit(const CommentsError('No post ID available to add comment.'));
      return;
    }

    // Correctly access the user from the Authenticated state
    final authState = _authBloc.state;
    if (authState is! Authenticated) {
      emit(const CommentsError('User not authenticated.'));
      return;
    }
    final user = authState.user;

    if (user.isAnonymous) {
      emit(const CommentsError('Guest users cannot add comments.'));
      return;
    }

    try {
      await _postRepository.addComment(_currentPostId!, event.text, user);
    } catch (e) {
      emit(CommentsError('Failed to add comment: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _commentsSubscription?.cancel();
    return super.close();
  }
}
