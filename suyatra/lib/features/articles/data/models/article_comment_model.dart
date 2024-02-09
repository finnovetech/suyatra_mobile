import 'dart:convert';

import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/features/articles/data/models/comment_model.dart';
import 'package:suyatra/features/articles/domain/entities/article_comment_entity.dart';

class ArticleCommentModel extends ArticleCommentEntity {
  const ArticleCommentModel({
    required super.id,
    super.comments,
  });

  factory ArticleCommentModel.fromJson(String source) {
    return ArticleCommentModel.fromMap(jsonDecode(source));
  }

  ArticleCommentModel.fromMap(DataMap map)
      : this(
          id: map["id"],
          comments: List.from(map["comments"]).map((e) => CommentModel.fromJson(e)).toList(),
        );

  ArticleCommentModel copyWith({
    int? id,
    List<CommentModel>? comments,
  }) {
    return ArticleCommentModel(
      id: id ?? this.id,
      comments: comments ?? this.comments,
    );
  }

  DataMap toMap() => {
    "id": id,
    "comments": comments,
  };

  String toJson() => jsonEncode(toMap());
}
