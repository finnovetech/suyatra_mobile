import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/core/usecases.dart';
import 'package:suyatra/features/articles/domain/repositories/article_repository.dart';

class AddArticleCommentUseCase implements UseCaseWithParams<void, AddArticleCommentParams> {
  final ArticleRepository _repository;
  AddArticleCommentUseCase(this._repository);

  @override
  ResultFuture<void> call(AddArticleCommentParams params) async {
    return await _repository.addArticleComment(
      articleId: params.articleId,
      comment: params.comment,
    );
  }
}

class AddArticleCommentParams {
  final String articleId;
  final Map<String, dynamic> comment;

  AddArticleCommentParams({required this.articleId, required this.comment});
}