import 'package:equatable/equatable.dart';

class ArticleCommentEntity extends Equatable {
  final int id;
  final List<CommentEntity>? comments;
  const ArticleCommentEntity({
    required this.id,
    this.comments,
  });
  @override
  List<Object?> get props => [
    id,
    comments,
  ];
}

class CommentEntity extends Equatable {
  final String userName;
  final String data;
  final String createdDate;

  const CommentEntity({
    required this.userName, 
    required this.data, 
    required this.createdDate
  });

  @override
  List<Object?> get props => [userName, data, createdDate];
}
