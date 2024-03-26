import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:suyatra/constants/enums.dart';
import 'package:suyatra/core/app_status.dart';
import 'package:suyatra/features/articles/domain/entities/article_category_entity.dart';
import 'package:suyatra/features/articles/domain/entities/article_comment_entity.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/articles/domain/entities/main_category_entity.dart';

class ArticleState extends Equatable {
  final List<MainCategoryEntity>? mainCategories;
  final String? selectedMainCategory;
  final List<ArticleCategoryEntity>? articleCategories;
  final List<ArticleEntity>? featuredArticles;
  final List<ArticleEntity>? popularArticles;
  final List<ArticleEntity>? allArticles;
  final List<CommentEntity>? articleComments;
  final int? selectedCategory;
  final AppStatus articleStatus;
  final TextEditingController? commentContoller;
  final GlobalKey? commentWidgetKey;
  final AppStatus articleLoadingMore;
  final ArticleType articleType;


  const ArticleState({
    this.mainCategories,
    this.selectedMainCategory,
    this.articleCategories,
    this.featuredArticles,
    this.popularArticles,
    this.allArticles,
    this.articleComments,
    this.selectedCategory,
    this.articleStatus = AppStatus.initial,
    this.commentContoller,
    this.commentWidgetKey,
    this.articleLoadingMore = AppStatus.initial,
    this.articleType = ArticleType.all,
  });

  ArticleState copyWith({
    List<MainCategoryEntity>? mainCategories,
    String? selectedMainCategory,
    bool clearMainCategory = false,
    List<ArticleCategoryEntity>? articleCategories,
    List<ArticleEntity>? featuredArticles,
    List<ArticleEntity>? popularArticles,
    List<ArticleEntity>? allArticles,
    List<CommentEntity>? articleComments,
    int? selectedCategory,
    bool clearCategory = false,
    AppStatus? articleStatus,
    TextEditingController? commentContoller,
    GlobalKey? commentWidgetKey,
    AppStatus? articleLoadingMore,
    ArticleType? articleType,
  }) {
    return ArticleState(
      mainCategories: mainCategories ?? this.mainCategories,
      selectedMainCategory: clearMainCategory == true
          ? null
          : (selectedMainCategory ?? this.selectedMainCategory),
      articleCategories: articleCategories ?? this.articleCategories,
      featuredArticles: featuredArticles ?? this.featuredArticles,
      popularArticles: popularArticles ?? this.popularArticles,
      allArticles: allArticles ?? this.allArticles,
      articleComments: articleComments ?? this.articleComments,
      selectedCategory: clearCategory == true
          ? null
          : (selectedCategory ?? this.selectedCategory),
      articleStatus: articleStatus ?? this.articleStatus,
      commentContoller: commentContoller ?? this.commentContoller,
      commentWidgetKey: commentWidgetKey ?? this.commentWidgetKey,
      articleLoadingMore: articleLoadingMore ?? this.articleLoadingMore,
      articleType: articleType ?? this.articleType,
    );
  }

  @override
  List<Object?> get props => [
    mainCategories,
    selectedMainCategory,
    articleCategories,
    featuredArticles,
    popularArticles,
    allArticles,
    articleComments,
    selectedCategory,
    articleStatus,
    commentContoller,
    commentWidgetKey,
    articleLoadingMore,
    articleType,
  ];
}
