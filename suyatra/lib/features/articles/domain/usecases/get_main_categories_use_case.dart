import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/articles/domain/entities/main_category_entity.dart';
import 'package:suyatra/features/articles/domain/repositories/article_repository.dart';

class GetMainCategoriesUseCase implements UseCaseWithoutParams {
  final ArticleRepository _repository;
  GetMainCategoriesUseCase (this._repository);

  @override
  ResultFuture<List<MainCategoryEntity>> call() async {
    return await _repository.getMainCategories();
  }
}