import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/articles/domain/repositories/article_repository.dart';

class GetArticleDetailsUseCase implements UseCaseWithParams<ArticleEntity?, GetArticleDetailsParams> {
  final ArticleRepository _repository;
  GetArticleDetailsUseCase(this._repository);

  @override
  ResultFuture<ArticleEntity?> call(GetArticleDetailsParams params) async {
    return await _repository.getArticleDetails(
      slug: params.slug,
    );
  }
}

class GetArticleDetailsParams {
  final String slug;

  GetArticleDetailsParams({required this.slug});
}