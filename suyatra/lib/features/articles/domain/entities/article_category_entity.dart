import 'package:equatable/equatable.dart';

class ArticleCategoryEntity extends Equatable {
  final int id;
  final String title;
  final String image;
  final String slug;
  final String createdAt;
  final String updatedAt;

  const ArticleCategoryEntity({
    required this.id,
    required this.title,
    required this.image,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  List<Object?> get props => [
    id,
    title,
    image,
    slug,
    createdAt,
    updatedAt,
  ];
}
