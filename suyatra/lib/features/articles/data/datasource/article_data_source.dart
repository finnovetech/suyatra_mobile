import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suyatra/constants/url_constants.dart';
import 'package:suyatra/core/exceptions.dart';
import 'package:suyatra/features/articles/data/models/article_category_model.dart';
import 'package:suyatra/features/articles/data/models/article_model.dart';
import 'package:suyatra/features/articles/data/models/comment_model.dart';
import 'package:suyatra/features/articles/data/models/main_category_model.dart';
import 'package:suyatra/services/api_service/api_base_helper.dart';

import '../../../../core/firebase_error_messages.dart';
import '../../../../core/service_locator.dart';
import '../../../../services/firebase_service.dart';
import '../../../../utils/date_formats.dart';

abstract class ArticleDataSource {
  Future<List<MainCategoryModel>> getMainCategories();
  Future<List<ArticleCategoryModel>> getArticleCategories();
  Future<List<ArticleModel>> getFeaturedArticles({int? perPage, String? mainCategory, int? category, bool loadMore});
  Future<List<ArticleModel>> getMoreFeaturedArticles({required List<ArticleModel> featuredArticles, String? mainCategory, int? category,});
  Future<List<ArticleModel>> getPopularArticles({int? perPage, String? mainCategory, int? category, bool loadMore});
  Future<List<ArticleModel>> getMorePopularArticles({required List<ArticleModel> popularArticles, String? mainCategory, int? category,});
  Future<List<ArticleModel>> getAllArticles({int? perPage, String? mainCategory, int? category, bool loadMore});
  Future<List<ArticleModel>> getMoreAllArticles({required List<ArticleModel> allArticles, String? mainCategory, int? category,});
  Future<List<CommentModel>> getArticleComments({required String articleId});
  Future<void> addArticleComment({required String articleId, required Map<String, dynamic> comment});
}

class ArticleDataSourceImpl implements ArticleDataSource {
  final ApiBaseHelper _apiBaseHelper;
  // final FirebaseFirestore _firebaseFirestore;
  ArticleDataSourceImpl(this._apiBaseHelper);

  @override
  Future<List<MainCategoryModel>> getMainCategories() async {
    try {
      List<MainCategoryModel> mainCategories = [];
      await Future.delayed(const Duration(milliseconds: 2000), () {
        mainCategories = [
          const MainCategoryModel(
            id: 001, 
            title: "Nepal Now",
            value: "news_briefs",
          ),
          const MainCategoryModel(
            id: 002, 
            title: "Travel Guides",
            value: "guides",
          ),
          const MainCategoryModel(
            id: 003, 
            title: "Nepal Insider",
            value: "newsletter"
          ),
          const MainCategoryModel(
            id: 004, 
            title: "Nepal Uncovered",
            value: "longreads"
          ),
        ];
      });
      return mainCategories;
    } on APIException {
      rethrow;
    } catch(e) {
      throw APIException(message: e.toString(), statusCode: -1);
    }
  }

  @override
  Future<List<ArticleCategoryModel>> getArticleCategories() async {
    try {
      final response = await _apiBaseHelper.getWithoutToken("$baseUrl/category_stories");
      if(response.statusCode == 200) {
        List<ArticleCategoryModel> articleCategories = List.from(jsonDecode(response.body)).map((e) => ArticleCategoryModel.fromMap(e)).toList();
        return articleCategories;
      } else {
        throw APIException(message: response.body, statusCode: response.statusCode);
      }
    } on APIException {
      rethrow;
    } catch(e) {
      throw APIException(message: e.toString(), statusCode: -1);
    }
  }

  int _currentFeaturedPage = 0;
  List<ArticleModel> featuredArticles = [];
  @override
  Future<List<ArticleModel>> getFeaturedArticles({
    int? perPage = 3,
    String? mainCategory = "",
    int? category,
    int? page = 0,
    bool loadMore = false,
    }) async {
    try {
      final response = await _apiBaseHelper.getWithoutToken("$baseUrl/featured_stories?per_page=${perPage ?? 3}&main_category=${mainCategory ?? ""}&category=${category ?? ""}&page=${loadMore ? _currentFeaturedPage : 0}");
      if(response.statusCode == 200) {
        //clear current loaded articles and reset current page
        if(!loadMore) {
          featuredArticles.clear();
          _currentFeaturedPage = 1;
        } else {
          _currentFeaturedPage++;
        }

        if((featuredArticles.length >= int.parse(jsonDecode(response.body)["total"].toString()))) {
          return featuredArticles;
        }
        else {
          if(!loadMore && (featuredArticles.length <= int.parse(jsonDecode(response.body)["total"].toString()))) {
            featuredArticles.addAll(List.from(jsonDecode(response.body)["result"]).map((e) => ArticleModel.fromMap(e)).toList());
          }
          if(loadMore && (featuredArticles.length <= int.parse(jsonDecode(response.body)["total"].toString()))) {
            featuredArticles = await getMoreFeaturedArticles(
              featuredArticles: featuredArticles, 
              mainCategory: mainCategory,
              category: category,
            );
          }
          return featuredArticles;
        }
      } else {
        throw APIException(message: response.body, statusCode: response.statusCode);
      }
    } on APIException {
      rethrow;
    } catch(e) {
      throw APIException(message: e.toString(), statusCode: -1);
    }
  }

  @override
  Future<List<ArticleModel>> getMoreFeaturedArticles({
    required List<ArticleModel> featuredArticles, 
    String? mainCategory,
    int? category,
    }) async {
    try {
      final moreResponse = await _apiBaseHelper.getWithoutToken("$baseUrl/featured_stories?per_page=3&main_category=${mainCategory ?? ""}&category=${category ?? ""}&page=$_currentFeaturedPage");
      if(moreResponse.statusCode == 200) {
        featuredArticles.addAll(List.from(jsonDecode(moreResponse.body)["result"]).map((e) => ArticleModel.fromMap(e)).toList());
      } else {
        throw APIException(message: moreResponse.body, statusCode: moreResponse.statusCode);
      }
      return featuredArticles;
    } on APIException {
      rethrow;
    } catch(e) {
      throw APIException(message: e.toString(), statusCode: -1);
    }
  }

  int _currentPopularPage = 0;
  List<ArticleModel> popularArticles = [];
  @override
  Future<List<ArticleModel>> getPopularArticles({
    int? perPage = 3,
    String? mainCategory = "",
    int? category,
    bool loadMore = false,
    }) async {
    try {
      final response = await _apiBaseHelper.getWithoutToken("$baseUrl/popular_stories?per_page=${perPage ?? 3}&main_category=${mainCategory ?? ""}&category=${category ?? ""}&page=${loadMore ? _currentPopularPage : 0}");
      if(response.statusCode == 200) {
        //clear current loaded articles and reset current page
        if(!loadMore) {
          popularArticles.clear();
          _currentPopularPage = 1;
        } else {
          _currentPopularPage++;
        }

        if((popularArticles.length >= int.parse(jsonDecode(response.body)["total"].toString()))) {
          return popularArticles;
        }
        else {
          if(!loadMore && (popularArticles.length <= int.parse(jsonDecode(response.body)["total"].toString()))) {
            popularArticles.addAll(List.from(jsonDecode(response.body)["result"]).map((e) => ArticleModel.fromMap(e)).toList());          
          }
          if(loadMore && (popularArticles.length <= int.parse(jsonDecode(response.body)["total"].toString()))) {
            popularArticles = await getMorePopularArticles(
              popularArticles: popularArticles, 
              mainCategory: mainCategory,
              category: category,
            );
          }
          return popularArticles;
        }
      } else {
        throw APIException(message: response.body, statusCode: response.statusCode);
      }
    } on APIException {
      rethrow;
    } catch(e) {
      throw APIException(message: e.toString(), statusCode: -1);
    }
  }

  @override
  Future<List<ArticleModel>> getMorePopularArticles({
    required List<ArticleModel> popularArticles, 
    String? mainCategory,
    int? category,
    }) async {
    try {
      final moreResponse = await _apiBaseHelper.getWithoutToken("$baseUrl/popular_stories?per_page=3&main_category=${mainCategory ?? ""}&category=${category ?? ""}&page=$_currentPopularPage");
      if(moreResponse.statusCode == 200) {
        popularArticles.addAll(List.from(jsonDecode(moreResponse.body)["result"]).map((e) => ArticleModel.fromMap(e)).toList());
      } else {
        throw APIException(message: moreResponse.body, statusCode: moreResponse.statusCode);
      }
      return popularArticles;
    } on APIException {
      rethrow;
    } catch(e) {
      throw APIException(message: e.toString(), statusCode: -1);
    }
  }

  int _currentArticlePage = 0;
  List<ArticleModel> allArticles = [];
  @override
  Future<List<ArticleModel>> getAllArticles({
    int? perPage = 3,
    String? mainCategory = "",
    int? category,
    int? page = 0,
    bool loadMore = false,
    }) async {
    try {
      final response = await _apiBaseHelper.getWithoutToken("$baseUrl/stories?per_page=${perPage ?? 3}&main_category=${mainCategory ?? ""}&category=${category ?? ""}&page=${loadMore ? _currentArticlePage : 0}");
      if(response.statusCode == 200) {
        //clear current loaded articles and reset current page
        if(!loadMore) {
          allArticles.clear();
          _currentArticlePage = 1;
        } else {
          _currentArticlePage++;
        }
        if((allArticles.length >= int.parse(jsonDecode(response.body)["total"].toString()))) {
          return allArticles;
        }
        else {
          if(!loadMore && (allArticles.length <= int.parse(jsonDecode(response.body)["total"].toString()))) {
            allArticles.addAll(List.from(jsonDecode(response.body)["result"]).map((e) => ArticleModel.fromMap(e)).toList());
          }
          if(loadMore && (allArticles.length <= int.parse(jsonDecode(response.body)["total"].toString()))) {
            allArticles = await getMoreAllArticles(
              allArticles: allArticles,
              mainCategory: mainCategory,
              category: category,
            );
          }
          return allArticles;
        }
      } else {
        throw APIException(message: response.body, statusCode: response.statusCode);
      }
    } on APIException {
      rethrow;
    } catch(e) {
      throw APIException(message: e.toString(), statusCode: -1);
    }
  }

  @override
  Future<List<ArticleModel>> getMoreAllArticles({
    required List<ArticleModel> allArticles, 
    String? mainCategory,
    int? category,
    }) async {
    try {
      print(allArticles.length);
      final moreResponse = await _apiBaseHelper.getWithoutToken("$baseUrl/stories?per_page=3&main_category=${mainCategory ?? ""}&category=${category ?? ""}&page=$_currentArticlePage");
      if(moreResponse.statusCode == 200) {
        allArticles.addAll(List.from(jsonDecode(moreResponse.body)["result"]).map((e) => ArticleModel.fromMap(e)).toList());
      } else {
        throw APIException(message: moreResponse.body, statusCode: moreResponse.statusCode);
      }
      return allArticles;
    } on APIException {
      rethrow;
    } catch(e) {
      throw APIException(message: e.toString(), statusCode: -1);
    }
  }

  @override
  Future<List<CommentModel>> getArticleComments({required String articleId}) async {
    try {
      List<CommentModel> comments = [];
      CollectionReference articleCommentRef = locator<FirebaseService>().firebaseFirestore.collection('Article_Comment');
      Query articleCommentDoc = articleCommentRef.where("article_id", isEqualTo: articleId);
      QuerySnapshot articleCommentSnapShot = await articleCommentDoc.get();
      for (var element in articleCommentSnapShot.docs) {
        QuerySnapshot snapshot = await articleCommentRef.doc(element.id).collection("Comment").get();
        comments = snapshot.docs.map((e) {
          Map<String, dynamic> data = {
            "user_name": e.get("user_name"),
            "data": e.get("data"),
            "created_date": readFirebaseTimestamp(e.get("created_date")),
          };
          return CommentModel.fromMap(data);
        }).toList();
        break;
      }
      return comments;

    } on FirebaseException catch(e) {
      throw APIException(message: Errors.show(e.code), statusCode: -1);
    } catch(e) {
      throw APIException(message: e.toString(), statusCode: -1);
    }
  }

  @override
  Future<void> addArticleComment({required String articleId, required Map<String, dynamic> comment}) async {
    try {
      CollectionReference articleCommentRef = locator<FirebaseService>().firebaseFirestore.collection('Article_Comment');
      Query articleCommentDoc = articleCommentRef.where("article_id", isEqualTo: articleId);
      QuerySnapshot articleCommentSnapShot = await articleCommentDoc.get();
      if(articleCommentSnapShot.docs.isEmpty) {
        Map<String,dynamic> articleComment = {
          "article_id": articleId,
        };
        await articleCommentRef.add(articleComment);
        articleCommentDoc = articleCommentRef.where("article_id", isEqualTo: articleId);
        articleCommentSnapShot = await articleCommentDoc.get();
      }
      for (var element in articleCommentSnapShot.docs) {
        CollectionReference commentColRef = articleCommentRef.doc(element.id).collection("Comment");
        Map<String, dynamic> newComment = {
          "user_name": comment["user_name"],
          "data": comment["data"],
          "created_date": Timestamp.fromDate(DateTime.now()),
        };
        await commentColRef.add(newComment);
        break;
      }
    } on FirebaseException catch(e) {
      throw APIException(message: Errors.show(e.code), statusCode: -1);
    } catch(e) {
      throw APIException(message: e.toString(), statusCode: -1);
    }
  }

}