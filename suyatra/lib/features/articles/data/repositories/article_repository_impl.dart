import 'package:dartz/dartz.dart';
import 'package:suyatra/core/exceptions.dart';
import 'package:suyatra/core/failure.dart';
import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/features/articles/data/datasource/article_data_source.dart';
import 'package:suyatra/features/articles/domain/entities/article_category_entity.dart';
import 'package:suyatra/features/articles/domain/entities/article_comment_entity.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/articles/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleDataSource _articleDataSource;
  ArticleRepositoryImpl(this._articleDataSource);

  @override
  ResultFuture<List<ArticleCategoryEntity>> getArticleCategories() async {
    try {
      final result = await _articleDataSource.getArticleCategories();
      return Right(result);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<ArticleEntity>> getFeaturedArticles({
    int? perPage,
    String? mainCategory,
    int? category,
    bool loadMore = false,
  }) async {
    try {
      final result = await _articleDataSource.getFeaturedArticles(
        perPage: perPage,
        mainCategory: mainCategory,
        category: category,
        loadMore: loadMore,
      );
      return Right(result);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<ArticleEntity>> getPopularArticles({
    int? perPage,
    String? mainCategory,
    int? category,
    bool loadMore = false,
  }) async {
    try {
      final result = await _articleDataSource.getPopularArticles(
        perPage: perPage,
        mainCategory: mainCategory,
        category: category,
        loadMore: loadMore,
      );
      return Right(result);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<ArticleEntity>> getAllArticles({
    int? perPage,
    String? mainCategory,
    int? category,
    int? page,
  }) async {
    try {
      final result = await _articleDataSource.getAllArticles(
        perPage: perPage,
        mainCategory: mainCategory,
        category: category,
        page: page,
      );
      return Right(result);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<CommentEntity>?> getArticleComments({required String articleId}) async {
    try {
      final result = await _articleDataSource.getArticleComments(
        articleId: articleId
      );
      return Right(result);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> addArticleComment({required String articleId, required Map<String, dynamic> comment}) async {
    try {
      final result = await _articleDataSource.addArticleComment(
        articleId: articleId,
        comment: comment,
      );
      return Right(result);
    } on APIException catch(e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}