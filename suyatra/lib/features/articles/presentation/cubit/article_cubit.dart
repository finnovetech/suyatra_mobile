import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/constants/enums.dart';
import 'package:suyatra/core/app_status.dart';
import 'package:suyatra/core/exceptions.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/articles/domain/usecases/add_article_comment_use_case.dart';
import 'package:suyatra/features/articles/domain/usecases/get_all_articles_use_case.dart';
import 'package:suyatra/features/articles/domain/usecases/get_article_categories_use_case.dart';
import 'package:suyatra/features/articles/domain/usecases/get_article_comments_use_case.dart';
import 'package:suyatra/features/articles/domain/usecases/get_featured_articles_use_case.dart';
import 'package:suyatra/features/articles/domain/usecases/get_popular_articles_use_case.dart';
import 'package:suyatra/features/articles/presentation/cubit/article_state.dart';
import 'package:suyatra/services/firebase_service.dart';
import 'package:suyatra/services/navigation_service.dart';
import 'package:suyatra/utils/toast_message.dart';

import '../../../../services/app_routes.dart';

class ArticleCubit extends Cubit<ArticleState> {
  final GetArticleCategoriesUseCase getArticleCategoriesUseCase;
  final GetFeaturedArticlesUseCase getFeaturedArticlesUseCase;
  final GetPopularArticlesUseCase getPopularArticlesUseCase;
  final GetAllArticlesUseCase getAllArticlesUseCase;
  final GetArticleCommentsUseCase getArticleCommentsUseCase;
  final AddArticleCommentUseCase addArticleCommentUseCase;


  ArticleCubit({
    required this.getArticleCategoriesUseCase, 
    required this.getFeaturedArticlesUseCase, 
    required this.getPopularArticlesUseCase, 
    required this.getAllArticlesUseCase, 
    required this.getArticleCommentsUseCase,
    required this.addArticleCommentUseCase,
  }) 
    : super(const ArticleState()) {
        getArticleCategories();
        getFeaturedArticles();
        getPopularArticles();
        getAllArticles();
        initializeControllers();
      }

  selectCategory(int? value, {required ArticleType articleType}) {
    getCategorizedArticles(value, articleType);
  }

  Future initializeControllers({bool keepText = true}) async {
    emit(state.copyWith(commentWidgetKey: GlobalKey(), commentContoller: TextEditingController(text: keepText ? state.commentContoller?.text : null)));
  }
  
  getArticleCategories() async {
    emit(state.copyWith(articleStatus: AppStatus.loading));
    try {
      final result = await getArticleCategoriesUseCase.call();

      result.fold(
        (error) => throw APIException(message: error.message, statusCode: -1), 
        (data) => emit(state.copyWith(articleCategories: data, articleStatus: AppStatus.success))
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      toastMessage(message: e.toString());
      emit(state.copyWith(articleStatus: AppStatus.failure));
    }
  }

  getFeaturedArticles({
    int? perPage,
    String? mainCategory,
    int? category,
    bool loadMore = false,
    bool changeTab = true,
    }) async {
    if(loadMore) {
      emit(state.copyWith(articleLoadingMore: AppStatus.loading));
    } else {
      emit(state.copyWith(articleStatus: AppStatus.loading));
    }
    try {
      final result = await getFeaturedArticlesUseCase.call(
        GetFeaturedArticlesParams(
          perPage: perPage,
          mainCategory: mainCategory,
          category: category,
          loadMore: loadMore,
        )
      );
      result.fold(
        (error) => throw APIException(message: error.message, statusCode: -1),
        (data) {
          emit(state.copyWith(featuredArticles: data, selectedCategory: changeTab ? category : null, clearCategory: category == null, articleStatus: AppStatus.success, articleLoadingMore: AppStatus.success));
        }
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      toastMessage(message: e.toString());
      if(loadMore) {
        emit(state.copyWith(articleLoadingMore: AppStatus.failure));
      } else {
        emit(state.copyWith(articleStatus: AppStatus.failure));
      }
    }
  }

  getPopularArticles({
    int? perPage,
    String? mainCategory,
    int? category,
    bool loadMore = false,
    bool changeTab = true,
    }) async {

    if(loadMore) {
      emit(state.copyWith(articleLoadingMore: AppStatus.loading));
    } else {
      emit(state.copyWith(articleStatus: AppStatus.loading));
    }
    try {
      final result = await getPopularArticlesUseCase.call(
        GetPopularArticlesParams(
          perPage: perPage,
          mainCategory: mainCategory,
          category: category,
          loadMore: loadMore,
        )
      );
      result.fold(
        (error) => throw APIException(message: error.message, statusCode: -1), 
        (data) {
          emit(state.copyWith(popularArticles: data, selectedCategory: changeTab ? category : null, clearCategory: category == null, articleStatus: AppStatus.success, articleLoadingMore: AppStatus.success));
        }
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      toastMessage(message: e.toString());
      if(loadMore) {
        emit(state.copyWith(articleLoadingMore: AppStatus.failure));
      } else {
        emit(state.copyWith(articleStatus: AppStatus.failure));
      }
    }
  }

  getAllArticles({
    int? perPage,
    String? mainCategory,
    int? category,
    bool loadMore = false,
    bool changeTab = true,
    }) async {
    if(loadMore) {
      emit(state.copyWith(articleLoadingMore: AppStatus.loading));
    } else {
      emit(state.copyWith(articleStatus: AppStatus.loading));
    }
    try {
      final result = await getAllArticlesUseCase.call(
        GetAllArticlesParams(
          perPage: perPage,
          mainCategory: mainCategory,
          category: category,
          loadMore: loadMore,
        )
      );

      result.fold(
        (error) => throw APIException(message: error.message, statusCode: -1),
        (data) {
          emit(state.copyWith(allArticles: data, selectedCategory: changeTab ? category : null, clearCategory: category == null, articleStatus: AppStatus.success, articleLoadingMore: AppStatus.success));
        }
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      toastMessage(message: e.toString());
      if(loadMore) {
        emit(state.copyWith(articleLoadingMore: AppStatus.failure));
      } else {
        emit(state.copyWith(articleStatus: AppStatus.failure));
      }
    }
  }

  getMoreArticles({
    int? perPage,
    String? mainCategory,
    int? category,
    int? page,
    }) async {
    if(state.articleStatus != AppStatus.loading) {
      switch (state.articleType) {
        case ArticleType.all:
          await getAllArticles(
            perPage: perPage,
            mainCategory: mainCategory,
            category: category,
            loadMore: true,
          );
          break;
        case ArticleType.featured:
          await getFeaturedArticles(
            perPage: perPage,
            mainCategory: mainCategory,
            category: category,
            loadMore: true,
          );
          break;
        case ArticleType.popular:
          await getPopularArticles(
            perPage: perPage,
            mainCategory: mainCategory,
            category: category,
            loadMore: true,
          );
          break;
        default:
      }
    }
    
  }

  navigateToArticlesList({required ArticleType articleType, int? category}) {
    selectCategory(category, articleType: articleType);
    locator<NavigationService>().navigateToAndBack(articlesListRoute);
  }

  openArticleDetails(ArticleEntity article, String heroTag) {
    locator<NavigationService>().navigateToAndBack(
      articleDetailsRoute, 
      arguments: {
        "article": article, 
        "tag": heroTag, 
      },
    );
  }

  getCategorizedArticles(int? categoryId, ArticleType articleType) async {
    emit(state.copyWith(articleType: articleType));
    switch (articleType) {
      case ArticleType.all:
        await getAllArticles(
          category: categoryId,
        );
        break;
      case ArticleType.featured:
        await getFeaturedArticles(
          category: categoryId,
        );
        break;
      case ArticleType.popular:
        await getPopularArticles(
          category: categoryId,
        );
        break;
      default:
    }
    
  }

  Future getArticleComments({required String articleId}) async {
    try {
      final result = await getArticleCommentsUseCase.call(
        GetArticleCommentsParams(
          articleId: articleId,
        )
      );
      result.fold(
        (error) => throw APIException(message: error.message, statusCode: -1),
        (data) {
          emit(state.copyWith(articleComments: data, articleStatus: AppStatus.success));
        }
      );
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      toastMessage(message: e.toString());
      emit(state.copyWith(articleStatus: AppStatus.failure));
    }
  }

  addArticleComment({required ArticleEntity article, required Map<String, dynamic> comment}) async {
    //do nothing if process is ongoing
    if(state.articleStatus == AppStatus.loading) {
      return;
    }
    //navigate to sign up screen if user not logged in
    if(locator<FirebaseService>().firebaseAuth.currentUser == null) {
      locator<NavigationService>().navigateTo(signUpRoute, arguments: {"route": articleDetailsRoute, "article": article}, );
      return;
    }
    //do nothing if comment data is empty
    if(comment["data"] == "") {
      return;
    }
    emit(state.copyWith(articleStatus: AppStatus.loading));
    try {
      for (var element in state.articleComments!) { 
        if(element.userName.contains(comment["user_name"])) {
          toastMessage(message: "You cannot add more than one comment");
          state.commentContoller!.clear();
          emit(state.copyWith(articleStatus: AppStatus.success));
          break;
        }
      }
      if(state.articleStatus != AppStatus.success) {
        final result = await addArticleCommentUseCase.call(
          AddArticleCommentParams(
            articleId: article.id.toString(),
            comment: comment,
          )
        );
        result.fold(
          (error) {
            emit(state.copyWith(articleStatus: AppStatus.failure));
          }, 
          (data) async {
            await getArticleComments(articleId: article.id.toString()).then((value) {
              state.commentContoller!.clear();
            });
          }
        );
      }
    } catch(e) {
      if(kDebugMode) {
        print(e.toString());
      }
      toastMessage(message: e.toString());
      emit(state.copyWith(articleStatus: AppStatus.failure));
    }
  }

  void scrollToCommentWidget() {
    Scrollable.ensureVisible(state.commentWidgetKey!.currentContext!);
  }

  void disposeControllers() {
    state.commentContoller!.dispose();
  }

  String getCategoryIcon(int id) {
    switch (id) {
      case 14:
        return "assets/icons/categories/food_cuisine.svg";
      case 15:
        return "assets/icons/categories/place_culture.svg";
      case 16:
        return "assets/icons/categories/trek_trail.svg";
      case 17:
        return "assets/icons/categories/travel_tour.svg";
      case 18:
        return "assets/icons/categories/sport_adventure.svg";
      default:
        return "assets/icons/categories/explore.svg";
    }
  }
}