import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/articles/data/datasource/article_data_source.dart';
import 'package:suyatra/features/articles/data/repositories/article_repository_impl.dart';
import 'package:suyatra/features/articles/domain/repositories/article_repository.dart';
import 'package:suyatra/features/articles/domain/usecases/add_article_comment_use_case.dart';
import 'package:suyatra/features/articles/domain/usecases/get_all_articles_use_case.dart';
import 'package:suyatra/features/articles/domain/usecases/get_article_categories_use_case.dart';
import 'package:suyatra/features/articles/domain/usecases/get_article_comments_use_case.dart';
import 'package:suyatra/features/articles/domain/usecases/get_featured_articles_use_case.dart';
import 'package:suyatra/features/articles/domain/usecases/get_main_categories_use_case.dart';
import 'package:suyatra/features/articles/domain/usecases/get_popular_articles_use_case.dart';

articleDI() {
  //usecases
  locator.registerLazySingleton(() => GetMainCategoriesUseCase(locator()));
  locator.registerLazySingleton(() => GetArticleCategoriesUseCase(locator()));
  locator.registerLazySingleton(() => GetFeaturedArticlesUseCase(locator()));
  locator.registerLazySingleton(() => GetPopularArticlesUseCase(locator()));
  locator.registerLazySingleton(() => GetAllArticlesUseCase(locator()));
  locator.registerLazySingleton(() => GetArticleCommentsUseCase(locator()));
  locator.registerLazySingleton(() => AddArticleCommentUseCase(locator()));
  
  //repositories
  locator.registerLazySingleton<ArticleRepository>(() => ArticleRepositoryImpl(locator()));

  //data sources
  locator.registerLazySingleton<ArticleDataSource>(() => ArticleDataSourceImpl(locator()));
}