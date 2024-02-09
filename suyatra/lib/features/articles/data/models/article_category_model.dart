import 'dart:convert';

import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/features/articles/domain/entities/article_category_entity.dart';

class ArticleCategoryModel extends ArticleCategoryEntity {
  const ArticleCategoryModel({
    required super.id,
    required super.title,
    required super.image,
    required super.slug,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ArticleCategoryModel.fromJson(String source) {
    return ArticleCategoryModel.fromMap(jsonDecode(source));
  }

  ArticleCategoryModel.fromMap(DataMap map)
      : this(
          id: map["id"],
          title: map["title"],
          image: map["image"],
          slug: map["slug"],
          createdAt: map["created_at"],
          updatedAt: map["updated_at"],
        );

  ArticleCategoryModel copyWith({
    int? id,
    String? title,
    String? image,
    String? slug,
    String? createdAt,
    String? updatedAt,
  }) {
    return ArticleCategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.title,
      slug: slug ?? this.slug,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  DataMap toMap() => {
    "id": id,
    "title": title,
    "image": image,
    "slug": slug,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };

  String toJson() => jsonEncode(toMap());
}
