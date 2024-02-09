import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/articles/domain/entities/article_category_entity.dart';
import 'package:suyatra/features/articles/domain/repositories/article_repository.dart';

class GetArticleCategoriesUseCase implements UseCaseWithoutParams {
  final ArticleRepository _repository;
  GetArticleCategoriesUseCase(this._repository);

  @override
  ResultFuture<List<ArticleCategoryEntity>> call() async {
    return await _repository.getArticleCategories();
  }
}