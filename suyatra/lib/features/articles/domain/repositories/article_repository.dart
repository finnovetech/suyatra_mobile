import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/features/articles/domain/entities/article_category_entity.dart';
import 'package:suyatra/features/articles/domain/entities/article_comment_entity.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/articles/domain/entities/main_category_entity.dart';

abstract class ArticleRepository {
  ResultFuture<List<MainCategoryEntity>> getMainCategories();

  ResultFuture<List<ArticleCategoryEntity>> getArticleCategories();

  ResultFuture<List<ArticleEntity>> getFeaturedArticles({int? perPage, String? mainCategory, int? category, bool loadMore = false});

  ResultFuture<List<ArticleEntity>> getPopularArticles({int? perPage, String? mainCategory, int? category, bool loadMore = false});

  ResultFuture<List<ArticleEntity>> getAllArticles({int? perPage, String? mainCategory, int? category, bool loadMore = false});

  ResultFuture<List<CommentEntity>?> getArticleComments({required String articleId});

  ResultFuture<void> addArticleComment({required String articleId, required Map<String, dynamic> comment});

  ResultFuture<ArticleEntity> getArticleDetails({required String slug});
}