import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/enums.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/constants/url_constants.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/articles/presentation/cubit/article_cubit.dart';
import 'package:suyatra/widgets/cached_image_widget.dart';

import '../../../../core/app_status.dart';

class ArticlesListPage extends StatelessWidget {
  final ArticleType articleType;
  const ArticlesListPage({super.key, this.articleType = ArticleType.all});

  @override
  Widget build(BuildContext context) {
    ArticleCubit articleCubit = context.watch<ArticleCubit>();
    return Scaffold(
      appBar: _appBar(),
      body: _body(articleCubit),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text(articleType.value),
    );
  }

  Widget _body(ArticleCubit articleCubit) {
    List<ArticleEntity> articles = [];
    switch (articleType) {
      case ArticleType.all:
        articles = articleCubit.state.allArticles ?? [];
        break;
      case ArticleType.featured:
        articles = articleCubit.state.featuredArticles ?? [];
        break;
      case ArticleType.popular:
        articles = articleCubit.state.popularArticles ?? [];
        break;
      default:
        articles = articleCubit.state.allArticles ?? [];
        break;
    }
    return Builder(
      builder: (context) {
        return NotificationListener(
          onNotification: (UserScrollNotification scrollInfo) {
            if (scrollInfo.direction == ScrollDirection.reverse && (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 50)) {
              articleCubit.getMoreArticles(
                articleType: articleType,
              );
            }
            return true;
          },
          child: Column(
            children: [
              Expanded(
                child: GridView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.85
                  ),
                  children: [
                    ...articles.map((article) {
                      return InkWell(
                        onTap: () {
                          articleCubit.openArticleDetails(article, "${articleType.value} ${article.id}");
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: "${articleType.value} ${article.id}",
                              child: Material(
                                color: whiteColor,
                                shadowColor: grey300,
                                clipBehavior: Clip.antiAlias,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: CachedImageWidget(
                                  imageUrl: "$websiteUrl${article.image}",
                                  fit: BoxFit.fill,
                                  height: 144,
                                  width: MediaQuery.sizeOf(context).width,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              article.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: h9,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      );
                    })
                  ],
                ),
              ),
              articleLoading(articleCubit),
            ],
          ),
        );
      }
    );
  }

  Widget articleLoading(ArticleCubit articleCubit) {
    if(articleCubit.state.articleStatus == AppStatus.loading) {
      return _progressIndicator();
    } else {
      return const SizedBox();
    }
  }

  Widget _progressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: CircularProgressIndicator(),
    );
  }
}