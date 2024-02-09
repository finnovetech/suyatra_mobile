import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/enums.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/constants/url_constants.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/articles/presentation/cubit/article_cubit.dart';
import 'package:suyatra/utils/string_extensions.dart';
import 'package:suyatra/widgets/cached_image_widget.dart';
import 'package:suyatra/widgets/custom_button.dart';

import '../../../../core/app_status.dart';

class ArticlesListPage extends StatelessWidget {
  const ArticlesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    ArticleCubit articleCubit = context.watch<ArticleCubit>();
    return Scaffold(
      appBar: _appBar(articleCubit),
      body: _body(articleCubit),
    );
  }

  PreferredSizeWidget _appBar(ArticleCubit articleCubit) {
    return AppBar(
      title: const Text("Articles"),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(104),
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  height: 32.0,
                  width: MediaQuery.sizeOf(context).width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      InkWell(
                        onTap: () {
                          articleCubit.selectCategory(null, articleType: articleCubit.state.articleType);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                          decoration: BoxDecoration(
                            border: articleCubit.state.selectedCategory == null ? const Border(
                              bottom: BorderSide(
                                width: 4,
                                color: blackColor,
                              )
                            ) : null,
                          ),
                          child: const Text(
                            "Explore",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      ...articleCubit.state.articleCategories!.map((category) {
                        return InkWell(
                          onTap: () {
                            articleCubit.selectCategory(
                              category.id, 
                              articleType: articleCubit.state.articleType,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 16.0),
                            decoration: BoxDecoration(
                              border: articleCubit.state.selectedCategory == category.id ? const Border(
                                bottom: BorderSide(
                                  width: 4,
                                  color: blackColor,
                                )
                              ) : null,
                            ),
                            child: Text(
                              category.title.capitalize(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 8.0),
                  child: Row(
                    children: [
                      ...ArticleType.values.map((e) {
                        return _articleTypeButton(
                          articleCubit,
                          e, 
                          onTap: (value) {
                            articleCubit.selectCategory(
                              articleCubit.state.selectedCategory,
                              articleType: value,
                            );
                          },
                        );
                      }),
                    ],
                  ),
                )
              ],
            );
          }
        ),
      ),
    );
  }

  Widget _articleTypeButton(ArticleCubit articleCubit, ArticleType type, {required void Function(ArticleType value) onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Material(
        color: articleCubit.state.articleType == type 
          ? blackColor 
          : grey100,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(
            color: blackColor,
          )
        ),
        child: InkWell(
          onTap: () {
            onTap(type);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              type.name.toUpperCase(),
              style: TextStyle(
                color: articleCubit.state.articleType == type ? whiteColor : grey700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(ArticleCubit articleCubit) {
    List<ArticleEntity> articles = [];
    switch (articleCubit.state.articleType) {
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
    return articles.isEmpty 
      ? _noArticlesWidget(articleCubit) 
      : articleCubit.state.articleStatus == AppStatus.loading 
        ? _articleGridShimmer() 
        : _articleGrid(articleCubit, articles);
  }

  Widget _articleGrid(ArticleCubit articleCubit, List<ArticleEntity> articles) {
    return Builder(
      builder: (context) {
        return NotificationListener(
          onNotification: (UserScrollNotification scrollInfo) {
            if (scrollInfo.direction == ScrollDirection.reverse && (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 50)) {
              articleCubit.getMoreArticles(
                category: articleCubit.state.selectedCategory,
              );
            }
            return true;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GridView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
                          articleCubit.openArticleDetails(article, "${articleCubit.state.articleType.value} ${article.id}");
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: "${articleCubit.state.articleType.value} ${article.id}",
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
    if(articleCubit.state.articleLoadingMore == AppStatus.loading) {
      return _progressIndicator();
    } else {
      return const SizedBox();
    }
  }

  Widget _progressIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _noArticlesWidget(ArticleCubit articleCubit) {
    return Builder(
      builder: (context) {
        return Center(
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/icons/no_data.svg",
                height: 128,
                width: 128,
              ),
              const SizedBox(height: 32.0),
              const Text(
                "No articles found",
                style: TextStyle(
                  fontSize: h6,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                "There are no articles or Try adjusting your filter",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: h9,
                  color: grey500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24.0),
              CustomButton(
                onPressed: () {
                  articleCubit.selectCategory(
                    articleCubit.state.selectedCategory, 
                    articleType: articleCubit.state.articleType,
                  );
                },
                label: "Retry",
                fullWidth: false,
                isLoading: articleCubit.state.articleStatus == AppStatus.loading,
                horizontalPadding: 24.0,
                buttonColor: Colors.red.shade100,
                textColor: Colors.red.shade900,
              )
            ],
          ),
        );
      }
    );
  }

  Widget _articleGridShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.85
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: grey300,
          highlightColor: grey100,
          enabled: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 144,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: grey100,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                height: 16,
                decoration: BoxDecoration(
                  color: grey100,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                width: MediaQuery.sizeOf(context).width,
              ),
              const SizedBox(height: 4.0),
              Container(
                height: 16,
                decoration: BoxDecoration(
                  color: grey100,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                width: 128,
              ),
            ],
          ),
        );
      }
    );
    // return SizedBox(
    //   width: 200.0,
    //   height: 100.0,
    //   child: Shimmer.fromColors(
    //     baseColor: Colors.red,
    //     highlightColor: Colors.yellow,
    //     child: const Text(
    //       'Shimmer',
    //       textAlign: TextAlign.center,
    //       style: TextStyle(
    //         fontSize: 40.0,
    //         fontWeight:
    //         FontWeight.bold,
    //       ),
    //     ),
    //   ),
    // );
  }
}