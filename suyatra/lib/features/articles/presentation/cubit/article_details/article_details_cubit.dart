import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/core/app_status.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/articles/domain/usecases/get_article_details_use_case.dart';

import '../../../../../core/exceptions.dart';
import '../../../../../utils/toast_message.dart';

part 'article_details_state.dart';

class ArticleDetailsCubit extends Cubit<ArticleDetailsState> {
  final GetArticleDetailsUseCase getArticleDetailsUseCase;
  final String slug;
  ArticleDetailsCubit({
    required this.getArticleDetailsUseCase,
    required this.slug,
  }) : super(const ArticleDetailsState()) {
    getArticleDetails(slug: slug);
  }

  getArticleDetails({required String slug}) async {
    emit(state.copyWith(articleDetailsStatus: AppStatus.loading));
    try {
      final result = await getArticleDetailsUseCase.call(
        GetArticleDetailsParams(slug: slug)
      );

      result.fold(
        (error) => throw APIException(message: error.message, statusCode: -1), 
        (data) => emit(state.copyWith(article: data, articleDetailsStatus: AppStatus.success))
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      toastMessage(message: e.toString());
      emit(state.copyWith(articleDetailsStatus: AppStatus.failure));
    }
  }
}