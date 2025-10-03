part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class LoadComments extends CommentsEvent {
  final String postId;

  const LoadComments(this.postId);

  @override
  List<Object> get props => [postId];
}

class AddComment extends CommentsEvent {
  final String text;

  const AddComment(this.text);

  @override
  List<Object> get props => [text];
}

class CommentsUpdated extends CommentsEvent {
  final List<Comment> comments;

  const CommentsUpdated(this.comments);

  @override
  List<Object> get props => [comments];
}
