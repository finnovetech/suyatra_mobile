import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/articles/domain/repositories/article_repository.dart';
import '../entities/article_entity.dart';

class GetFeaturedArticlesUseCase implements UseCaseWithParams<List<ArticleEntity>, GetFeaturedArticlesParams> {
  final ArticleRepository _repository;
  GetFeaturedArticlesUseCase(this._repository);

  @override
  ResultFuture<List<ArticleEntity>> call(GetFeaturedArticlesParams params) async {
    return await _repository.getFeaturedArticles(
      perPage: params.perPage,
      mainCategory: params.mainCategory,
      category: params.category,
      loadMore: params.loadMore,
    );
  }
}

class GetFeaturedArticlesParams {
  final int? perPage;
  final String? mainCategory;
  final int? category;
  final bool loadMore;

  GetFeaturedArticlesParams({this.perPage, this.mainCategory, this.category, this.loadMore = false});
}