import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final int? id;
  final String? userName;
  final String? title;
  final String? shortDesc;
  final String? longDesc;
  final String? publishedDate;
  final String? status;
  final String? image;
  final String? mainCategory;
  final List<dynamic>? categories;
  final bool? featured;
  final int? viewCount;
  final String? slug;
  final String? createdAt;
  final String? updatedAt;
  final String? readTime;

  const ArticleEntity({
    required this.id,
    required this.userName,
    required this.title,
    required this.shortDesc,
    required this.longDesc,
    required this.publishedDate,
    required this.status,
    required this.image,
    required this.mainCategory,
    required this.categories,
    required this.featured,
    required this.viewCount,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    required this.readTime,
  });
  
  @override
  List<Object?> get props => [
    id,
    userName,
    title,
    shortDesc,
    longDesc,
    publishedDate,
    status,
    image,
    mainCategory,
    categories,
    featured,
    viewCount,
    slug,
    createdAt,
    updatedAt,
    readTime,
  ];
}
