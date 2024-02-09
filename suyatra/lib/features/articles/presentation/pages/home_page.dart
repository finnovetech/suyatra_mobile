import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/enums.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/constants/url_constants.dart';
import 'package:suyatra/core/app_status.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/articles/domain/entities/article_category_entity.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/articles/presentation/cubit/article_cubit.dart';
import 'package:suyatra/services/app_routes.dart';
import 'package:suyatra/services/navigation_service.dart';
// import 'package:suyatra/utils/string_extensions.dart';
import 'package:suyatra/widgets/card_widget.dart';

import '../../../../utils/date_formats.dart';
import '../../../../widgets/cached_image_widget.dart';
import '../../../../widgets/page_loader.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../cubit/article_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<ArticleCubit, ArticleState>(builder: (context, state) {
        switch (state.articleStatus) {
          case AppStatus.loading:
            return const PageLoader();
          case AppStatus.failure:
            return Center(
              child: InkWell(
                onTap: () {
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Failure"
                    ),
                    Icon(Icons.restart_alt_sharp),
                  ],
                ),
              ),
            );
          default:
            return Scaffold(
              appBar: _appBar(context, context.read<ArticleCubit>(), state),
              body: _body(context.read<ArticleCubit>(), state),
            );
        }
      }),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context, ArticleCubit cubit, ArticleState state) {
    return AppBar(
      // leading: const Icon(
      //   Icons.notifications_outlined,
      // ),
      title: const Text("Suyatra"),
      actions: [
        FirebaseAuth.instance.currentUser != null ? IconButton(
          onPressed: () {
            context.read<AuthCubit>().signOutUser();  
          },
          icon: const Icon(Icons.logout),
        ) : IconButton(
          onPressed: () {
            locator<NavigationService>().navigateToAndBack(signUpRoute, arguments: {});
          },
          icon: const Icon(Icons.login),
        ),
      ],
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(48),
      //   child: Builder(
      //     builder: (context) {
      //       return Container(
      //         margin: const EdgeInsets.only(bottom: 8.0),
      //         height: 32.0,
      //         width: MediaQuery.sizeOf(context).width,
      //         child: ListView(
      //           scrollDirection: Axis.horizontal,
      //           children: [
      //             InkWell(
      //               onTap: () {
      //                 cubit.selectCategory(null);
      //               },
      //               child: Container(
      //                 margin: const EdgeInsets.only(left: 16.0, right: 16.0),
      //                 decoration: BoxDecoration(
      //                   border: state.selectedCategory == null ? const Border(
      //                     bottom: BorderSide(
      //                       width: 4,
      //                       color: blackColor,
      //                     )
      //                   ) : null,
      //                 ),
      //                 child: const Text(
      //                   "Explore",
      //                   style: TextStyle(
      //                     fontWeight: FontWeight.w500,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             ...state.articleCategories!.map((category) {
      //               return InkWell(
      //                 onTap: () {
      //                   cubit.selectCategory(category.id);
      //                 },
      //                 child: Container(
      //                   margin: const EdgeInsets.only(right: 16.0),
      //                   decoration: BoxDecoration(
      //                     border: state.selectedCategory == category.id ? const Border(
      //                       bottom: BorderSide(
      //                         width: 4,
      //                         color: blackColor,
      //                       )
      //                     ) : null,
      //                   ),
      //                   child: Text(
      //                     category.title.capitalize(),
      //                     style: const TextStyle(
      //                       fontWeight: FontWeight.w500,
      //                     ),
      //                   ),
      //                 ),
      //               );
      //             })
      //           ],
      //         ),
      //       );
      //     }
      //   ),
      // ),
    );
  }

  Widget _body(
    ArticleCubit articleCubit,
    ArticleState state,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 24.0),
          state.selectedCategory == null ? _categoriesSection(articleCubit, state) : const SizedBox(),
          _featuredArticlesSlider(articleCubit, state),
          const SizedBox(height: 32.0),
          state.selectedCategory != null ? _popularArticlesList(articleCubit, state) : _popularArticlesSlider(articleCubit, state),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _categoriesSection(ArticleCubit articleCubit, ArticleState state) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics() ,
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 32.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
      ), 
      // itemCount: state.articleCategories?.length ?? 0,
      children: [
        ...state.articleCategories!.map((category) {
          return _categoryCard(category);
        }),
        _categoryCard(
          const ArticleCategoryEntity(id: 0, title: "Explore", image: "", slug: "", createdAt: "", updatedAt: "")
        )
      ],
    );
  }

  Widget _categoryCard(ArticleCategoryEntity category) {
    return Builder(
      builder: (context) {
        return Material(
          color: whiteColor,
          borderRadius: BorderRadius.circular(12.0),
          shadowColor: grey100,
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: () {
              
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    context.read<ArticleCubit>().getCategoryIcon(category.id),
                    height: 64,
                    width: 64,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    category.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: h9,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _featuredArticlesSlider(ArticleCubit articleCubit, ArticleState state) {
    return CardWidget(
      label: "Featured",
      hasMargin: false,
      actions: [
        InkWell(
          onTap: () {
            articleCubit.navigateToArticlesList(ArticleType.featured);
          },
          child: const Text(
            "VIEW ALL",
            style: TextStyle(
              fontSize: h11,
              fontWeight:  FontWeight.w500,
              color: primaryDark,
            ),
          ),
        )
      ],
      card: CarouselSlider.builder(
        itemCount: (state.featuredArticles?.length ?? 0) > 5 ? 5 : state.featuredArticles?.length ?? 0,
        itemBuilder: (context, index, realIndex) {
          ArticleEntity featuredArticle = state.featuredArticles![index];
          return GestureDetector(
            onTap: () {
              articleCubit.openArticleDetails(
                featuredArticle, 
                "featured ${featuredArticle.id}",
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: blackColor,
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Hero(
                    tag: "featured ${featuredArticle.id}",
                    child: CachedImageWidget(
                      opacity: 0.7,
                      imageUrl: "$websiteUrl${featuredArticle.image}",
                      fit: BoxFit.cover,
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          state.articleCategories
                            ?.where((element) =>
                              featuredArticle.categories!.contains(element.id)).map((e) => e.title).join(", ") ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: h11,
                            fontWeight: FontWeight.w500,
                            color: whiteColor.withOpacity(0.60),
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          featuredArticle.title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: h6,
                            fontWeight: FontWeight.w600,
                            color: whiteColor,
                          ),
                        ),
                        Text(
                          "${formatDateInLanguageOnlyMonth(featuredArticle.publishedDate ?? "")} . ${featuredArticle.readTime}",
                          style: const TextStyle(
                            color: whiteColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        options: CarouselOptions(
          viewportFraction: 1,
          enlargeCenterPage: false,
          enableInfiniteScroll: false,
        ),
      ),
    );
  }

  Widget _popularArticlesSlider(ArticleCubit articleCubit, ArticleState state) {
    return CardWidget(
      label: "Popular",
      hasMargin: false,
      actions: [
        InkWell(
          onTap: () {
            articleCubit.navigateToArticlesList(ArticleType.popular);
          },
          child: const Text(
            "VIEW ALL",
            style: TextStyle(
              fontSize: h11,
              fontWeight:  FontWeight.w500,
              color: primaryDark,
            ),
          ),
        )
      ],
      card: CarouselSlider.builder(
        itemCount: (state.popularArticles?.length ?? 0) > 5 ? 5 : (state.popularArticles?.length ?? 0),
        itemBuilder: (context, index, _) {
          ArticleEntity popularArticle = state.popularArticles![index];
          return GestureDetector(
            onTap: () {
              articleCubit.openArticleDetails(
                popularArticle, 
                "popular ${popularArticle.id}",
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: "popular ${popularArticle.id}",
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    margin: const EdgeInsets.only(right: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedImageWidget(
                      imageUrl: "$websiteUrl${popularArticle.image}",
                      fit: BoxFit.cover,
                      width: MediaQuery.sizeOf(context).width,
                      height: 144,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  popularArticle.title!,
                  style: const TextStyle(
                    fontSize: h9,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          );
        },
        options: CarouselOptions(
          viewportFraction: 0.9,
          aspectRatio: 1.4,
          enlargeCenterPage: false,
          enableInfiniteScroll: false,
        ),
      ),
    );
  }

  Widget _popularArticlesList(ArticleCubit articleCubit, ArticleState state) {
    return CardWidget(
      label: "Popular",
      card: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          ArticleEntity popularArticle = state.popularArticles![index];
          return GestureDetector(
            onTap: () {
              articleCubit.openArticleDetails(
                popularArticle, 
                "popular ${popularArticle.id}",
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: grey200,
                )
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Hero(
                      tag: "popular ${popularArticle.id}",
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedImageWidget(
                          opacity: 0.7,
                          imageUrl: "$websiteUrl${popularArticle.image}",
                          fit: BoxFit.fill,
                          height: 116,
                          width: 104,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (state.articleCategories
                            ?.where((element) =>
                              popularArticle.categories!.contains(element.id)).map((e) => e.title).join(", ") ?? "").toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            fontSize: h11,
                            fontWeight: FontWeight.w500,
                            color: primaryDark,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          popularArticle.title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: h9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          "${formatDateInLanguageNoYear(popularArticle.publishedDate!)} . ${popularArticle.readTime}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: grey400,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }, 
        separatorBuilder: (context, _) => const SizedBox(height: 12.0), 
        itemCount: (state.popularArticles?.length ?? 0) > 3 ? 3 : state.popularArticles?.length ?? 0,
      ),
    );
  }
}
