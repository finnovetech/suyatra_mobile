part of 'article_details_cubit.dart';

class ArticleDetailsState extends Equatable {
  final AppStatus articleDetailsStatus;
  final ArticleEntity? article;

  const ArticleDetailsState({
    this.articleDetailsStatus = AppStatus.initial, 
    this.article,
  });

  ArticleDetailsState copyWith({
    AppStatus? articleDetailsStatus,
    ArticleEntity? article,
  }) {
    return ArticleDetailsState(
      articleDetailsStatus: articleDetailsStatus ?? this.articleDetailsStatus,
      article: article ?? this.article,
    );
  }

  @override
  List<Object?> get props => [
    articleDetailsStatus,
    article,
  ];
}