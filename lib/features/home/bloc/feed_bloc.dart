import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:vibra/features/home/repositories/post_repository.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository _postRepository;
  StreamSubscription? _postsSubscription;

  FeedBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(FeedLoading()) {
    on<LoadFeed>(_onLoadFeed);
    on<_FeedUpdated>(_onFeedUpdated);
  }

  void _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) {
    emit(FeedLoading());
    _postsSubscription?.cancel();
    _postsSubscription = _postRepository.getPosts().listen(
      (posts) {
        add(_FeedUpdated(posts.docs));
      },
      onError: (error) {
        emit(const FeedError('No se pudieron cargar las publicaciones.'));
      },
    );
  }

  void _onFeedUpdated(_FeedUpdated event, Emitter<FeedState> emit) {
    emit(FeedLoaded(event.posts));
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}
