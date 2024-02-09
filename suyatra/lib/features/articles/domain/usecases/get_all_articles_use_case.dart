import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/articles/domain/repositories/article_repository.dart';
import '../entities/article_entity.dart';

class GetAllArticlesUseCase implements UseCaseWithParams<List<ArticleEntity>, GetAllArticlesParams> {
  final ArticleRepository _repository;
  GetAllArticlesUseCase(this._repository);

  @override
  ResultFuture<List<ArticleEntity>> call(GetAllArticlesParams params) async {
    return await _repository.getAllArticles(
      perPage: params.perPage,
      mainCategory: params.mainCategory,
      category: params.category,
      loadMore: params.loadMore,
    );
  }
}

class GetAllArticlesParams {
  final int? perPage;
  final String? mainCategory;
  final int? category;
  final bool loadMore;

  GetAllArticlesParams({this.perPage, this.mainCategory, this.category, this.loadMore = false});
}