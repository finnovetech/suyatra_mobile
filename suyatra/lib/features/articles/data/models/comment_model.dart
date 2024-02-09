import 'dart:convert';
import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/features/articles/domain/entities/article_comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.userName, 
    required super.data, 
    required super.createdDate,
  });

  factory CommentModel.fromJson(String source) {
    return CommentModel.fromMap(jsonDecode(source));
  }

  CommentModel.fromMap(DataMap map)
      : this(
          userName: map["user_name"],
          data: map["data"],
          createdDate: map["created_date"],
        );

  CommentModel copyWith({
    String? userName,
    String? data,
    String? createdDate,
  }) {
    return CommentModel(
      userName: userName ?? this.userName,
      data: data ?? this.data,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  DataMap toMap() => {
    "user_name": userName,
    "data": data,
    "created_date": createdDate,
  };

  String toJson() => jsonEncode(toMap());
}
