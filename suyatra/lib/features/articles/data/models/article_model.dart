import 'dart:convert';
import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    required super.id,
    required super.userName,
    required super.title,
    required super.shortDesc,
    required super.longDesc,
    required super.publishedDate,
    required super.status,
    required super.image,
    required super.mainCategory,
    required super.categories,
    required super.featured,
    required super.viewCount,
    required super.slug,
    required super.createdAt,
    required super.updatedAt,
    required super.readTime,
  });

  factory ArticleModel.fromJson(String source) {
    return ArticleModel.fromMap(jsonDecode(source));
  }

  ArticleModel.fromMap(DataMap map)
      : this(
          id: map["id"],
          userName: map["user_name"],
          title: map["title"],
          shortDesc: map["short_description"],
          longDesc: map["long_description"],
          publishedDate: map["published_date"],
          status: map["status"],
          image: map["image"],
          mainCategory: map["main_category"],
          categories: List.from(map["categories"]).map((e) => e).toList(),
          featured: map["featured"],
          viewCount: map["view_count"],
          slug: map["slug"],
          createdAt: map["created_at"],
          updatedAt: map["updated_at"],
          readTime: map["readtime"],
        );

  ArticleModel copyWith({
    int? id,
    String? userName,
    String? title,
    String? shortDesc,
    String? longDesc,
    String? publishedDate,
    String? status,
    String? image,
    String? mainCategory,
    List<int>? categories,
    bool? featured,
    int? viewCount,
    String? slug,
    String? createdAt,
    String? updatedAt,
    String? readTime,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      title: title ?? this.title,
      shortDesc: shortDesc ?? this.shortDesc,
      longDesc: longDesc ?? this.longDesc,
      publishedDate: publishedDate ?? this.publishedDate,
      status: status ?? this.status,
      image: image ?? this.title,
      mainCategory: image ?? this.title,
      categories: categories ?? this.categories,
      featured: featured ?? this.featured,
      viewCount: viewCount ?? this.viewCount,
      slug: slug ?? this.slug,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      readTime: readTime ?? this.readTime,
    );
  }
}
