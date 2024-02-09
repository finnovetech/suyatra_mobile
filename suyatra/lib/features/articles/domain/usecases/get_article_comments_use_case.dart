import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/articles/domain/entities/article_comment_entity.dart';
import 'package:suyatra/features/articles/domain/repositories/article_repository.dart';

class GetArticleCommentsUseCase implements UseCaseWithParams<List<CommentEntity>?, GetArticleCommentsParams> {
  final ArticleRepository _repository;
  GetArticleCommentsUseCase(this._repository);

  @override
  ResultFuture<List<CommentEntity>?> call(GetArticleCommentsParams params) async {
    return await _repository.getArticleComments(
      articleId: params.articleId,
    );
  }
}

class GetArticleCommentsParams {
  final String articleId;

  GetArticleCommentsParams({required this.articleId});
}