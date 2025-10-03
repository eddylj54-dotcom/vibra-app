part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class LoadFeed extends FeedEvent {}

// Evento interno para actualizar el feed con nuevos datos
class _FeedUpdated extends FeedEvent {
  final List<QueryDocumentSnapshot> posts;

  const _FeedUpdated(this.posts);

  @override
  List<Object> get props => [posts];
}
