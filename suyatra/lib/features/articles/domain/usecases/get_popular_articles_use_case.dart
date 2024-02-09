import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/articles/domain/repositories/article_repository.dart';
import '../entities/article_entity.dart';

class GetPopularArticlesUseCase implements UseCaseWithParams<List<ArticleEntity>, GetPopularArticlesParams> {
  final ArticleRepository _repository;
  GetPopularArticlesUseCase(this._repository);

  @override
  ResultFuture<List<ArticleEntity>> call(GetPopularArticlesParams params) async {
    return await _repository.getPopularArticles(
      perPage: params.perPage,
      mainCategory: params.mainCategory,
      category: params.category,
      loadMore: params.loadMore,
    );
  }
}

class GetPopularArticlesParams {
  final int? perPage;
  final String? mainCategory;
  final int? category;
  final bool loadMore;

  GetPopularArticlesParams({this.perPage, this.mainCategory, this.category, this.loadMore = false});
}