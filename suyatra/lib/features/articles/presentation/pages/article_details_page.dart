// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/core/app_status.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/articles/presentation/cubit/articles/article_cubit.dart';
import 'package:suyatra/features/articles/presentation/cubit/article_details/article_details_cubit.dart';
import 'package:suyatra/features/articles/presentation/cubit/articles/article_state.dart';
import 'package:suyatra/features/articles/presentation/widgets/comments_section.dart';
import 'package:suyatra/services/app_routes.dart';
import 'package:suyatra/services/navigation_service.dart';
import 'package:suyatra/widgets/cached_image_widget.dart';
import 'package:suyatra/widgets/page_loader.dart';

import '../../../../constants/url_constants.dart';
// import '../../../../widgets/card_widget.dart';

class ArticleDetailsPage extends StatefulWidget {
  final String slug;
  final String heroTag;
  final bool? scrollToComment;
  const ArticleDetailsPage({
    super.key,
    required this.slug,
    required this.heroTag,
    this.scrollToComment = false,
  });

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  // String _customDesc = "";
  // late ArticleEntity article;

  void getComments(ArticleEntity article) async {
    context.read<ArticleCubit>().getArticleComments(articleId: "${article.id}");
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      context.read<ArticleCubit>().initializeControllers();
    }

    // getComments(article);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: locator<NavigationService>().navigationKey.currentState!.canPop()
          ? true
          : false,
      onPopInvoked: (hasPopped) {
        if (hasPopped) {
          return;
        }
        if (!(locator<NavigationService>()
            .navigationKey
            .currentState!
            .canPop())) {
          context.read<ArticleCubit>().disposeControllers();
          locator<NavigationService>().navigateTo(exploreRoute);
        }
      },
      child: BlocProvider(
        create: (context) => ArticleDetailsCubit(
          getArticleDetailsUseCase: locator(),
          slug: widget.slug,
        ),
        child: Scaffold(
          appBar: _appBar(),
          body: BlocBuilder<ArticleDetailsCubit, ArticleDetailsState>(
            builder: (context, state) {
              switch (state.articleDetailsStatus) {
                case AppStatus.loading:
                  return const PageLoader();
                default:
                  return _body(state.article!);
              }
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      leading: locator<NavigationService>().navigationKey.currentState!.canPop()
          ? null
          : IconButton(
              onPressed: () {
                locator<NavigationService>().navigateTo(exploreRoute);
              },
              icon: Icon(Icons.adaptive.arrow_back),
            ),
      actions: [
        IconButton(
          onPressed: () async {
            Share.share("$websiteUrl/stories/${widget.slug}");
          },
          icon: const Icon(Icons.share),
        ),
        // IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.bookmark_outline),
        // )
      ],
    );
  }

  Widget _body(ArticleEntity article) {
    return Builder(builder: (context) {
      return BlocConsumer<ArticleCubit, ArticleState>(
        listener: (context, state) {
          switch (state.articleStatus) {
            case AppStatus.success:
              if (widget.scrollToComment == true) {
                context.read<ArticleCubit>().scrollToCommentWidget();
              }
              break;
            case AppStatus.loading:
              const PageLoader();
              break;
            default:
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: widget.heroTag,
                  child: CachedImageWidget(
                    opacity: 0.7,
                    imageUrl: "${article.image}",
                    fit: BoxFit.cover,
                    width: MediaQuery.sizeOf(context).width,
                    height: 262,
                  ),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.articleCategories!
                                .where((element) =>
                                    element.id ==
                                    article.categories?.firstOrNull)
                                .firstOrNull
                                ?.title
                                .toUpperCase() ??
                            "",
                        style: const TextStyle(
                          fontSize: h11,
                          fontWeight: FontWeight.w500,
                          color: himalayanBlue,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        article.title!,
                        style: const TextStyle(
                          fontSize: h6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        article.readTime!,
                        style: const TextStyle(
                          fontSize: h9,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      Html(
                        data: article.longDesc,
                        onLinkTap: (String? url, attributes, element) async {
                          if (url != null) {
                            locator<NavigationService>().navigateToAndBack(
                              webViewRoute,
                              arguments: url,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                ArticleComments(article: article),
                const SizedBox(height: 32.0),
                // _relatedArticlesList(article, state),
              ],
            ),
          );
        },
      );
    });
  }

  // Widget _commentSection(ArticleState state) {
  //   return Padding(
  //     key: state.commentWidgetKey,
  //     padding: const EdgeInsets.only(top: 24.0),
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //           child: Row(
  //             children: [
  //               Container(
  //                 height: 40,
  //                 width: 40,
  //                 decoration: const BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   color: primaryColor,
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     (locator<FirebaseService>()
  //                                 .firebaseAuth
  //                                 .currentUser
  //                                 ?.email
  //                                 ?.characters
  //                                 .firstOrNull ??
  //                             "G")
  //                         .toUpperCase(),
  //                     style: const TextStyle(
  //                       fontSize: h7,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 8.0),
  //               Expanded(
  //                 child: TextFieldWidget(
  //                   controller: state.commentContoller,
  //                   hintText: "Share your views on this...",
  //                 ),
  //               ),
  //               const SizedBox(width: 8.0),
  //               InkWell(
  //                 onTap: () {
  //                   context
  //                       .read<ArticleCubit>()
  //                       .addArticleComment(article: article, comment: {
  //                     "data": state.commentContoller!.text,
  //                     "user_name": locator<FirebaseService>()
  //                             .firebaseAuth
  //                             .currentUser
  //                             ?.email ??
  //                         "",
  //                   });
  //                 },
  //                 child: state.articleStatus == AppStatus.loading
  //                     ? const SizedBox(
  //                         height: 20,
  //                         width: 20,
  //                         child: CircularProgressIndicator(),
  //                       )
  //                     : const Icon(Icons.send),
  //               ),
  //             ],
  //           ),
  //         ),
  //         state.articleComments?.isNotEmpty == true
  //             ? CarouselSlider.builder(
  //                 itemCount: state.articleComments!.length,
  //                 itemBuilder: (context, index, _) {
  //                   CommentEntity comment = state.articleComments![index];
  //                   return Container(
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(12.0),
  //                       border: Border.all(
  //                         color: grey300,
  //                       ),
  //                     ),
  //                     padding: const EdgeInsets.all(16.0),
  //                     margin: EdgeInsets.only(
  //                             right: index == state.articleComments!.length - 1
  //                                 ? 0
  //                                 : 16.0)
  //                         .copyWith(top: 12.0),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Expanded(
  //                               child: Row(
  //                                 children: [
  //                                   Container(
  //                                     height: 32,
  //                                     width: 32,
  //                                     decoration: const BoxDecoration(
  //                                       shape: BoxShape.circle,
  //                                       color: primaryColor,
  //                                     ),
  //                                     child: Center(
  //                                       child: Text(
  //                                         comment.userName.characters.first
  //                                             .toUpperCase(),
  //                                         style: const TextStyle(
  //                                           fontSize: h9,
  //                                           fontWeight: FontWeight.w600,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   const SizedBox(width: 8.0),
  //                                   Expanded(
  //                                     child: Text(
  //                                       comment.userName,
  //                                       maxLines: 1,
  //                                       overflow: TextOverflow.ellipsis,
  //                                       style: const TextStyle(
  //                                         fontWeight: FontWeight.w500,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             Text(
  //                               comment.createdDate,
  //                               style: const TextStyle(
  //                                 color: grey500,
  //                                 fontSize: h11,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 8.0),
  //                         Expanded(
  //                           child: Text(
  //                             comment.data,
  //                             overflow: TextOverflow.ellipsis,
  //                             maxLines: 8,
  //                             style: const TextStyle(color: grey500),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 },
  //                 options: CarouselOptions(
  //                   viewportFraction: 0.91,
  //                   enlargeCenterPage: false,
  //                   enableInfiniteScroll: false,
  //                 ),
  //               )
  //             : const SizedBox()
  //       ],
  //     ),
  //   );
  // }

  // Widget _relatedArticlesList(ArticleEntity article, ArticleState state) {
  //   List<ArticleEntity> articles = [];
  //   for (var i = 0; i < (article.categories?.length ?? 0); i++) {
  //     articles.addAll(state.allArticles!.where((article) =>
  //         article.categories!.contains(article.categories![i]) &&
  //         article.id != article.id));
  //   }
  //   if (articles.isNotEmpty) {
  //     return CardWidget(
  //       label: "RELATED ARTICLES",
  //       hasMargin: false,
  //       card: CarouselSlider.builder(
  //         itemCount: articles.length,
  //         itemBuilder: (context, index, _) {
  //           ArticleEntity article = articles[index];
  //           return GestureDetector(
  //             onTap: () {
  //               context.read<ArticleCubit>().openArticleDetails(
  //                     article,
  //                     "related ${article.id}",
  //                   );
  //             },
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Hero(
  //                   tag: "related ${article.id}",
  //                   child: Container(
  //                     width: MediaQuery.sizeOf(context).width,
  //                     margin: const EdgeInsets.only(right: 16.0),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(12.0),
  //                     ),
  //                     clipBehavior: Clip.antiAlias,
  //                     child: CachedImageWidget(
  //                       imageUrl: "$websiteUrl${article.image}",
  //                       fit: BoxFit.cover,
  //                       width: MediaQuery.sizeOf(context).width,
  //                       height: 144,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8.0),
  //                 Text(
  //                   article.title!,
  //                   style: const TextStyle(
  //                     fontSize: h9,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 )
  //               ],
  //             ),
  //           );
  //         },
  //         options: CarouselOptions(
  //           viewportFraction: 0.9,
  //           aspectRatio: 1.4,
  //           enlargeCenterPage: false,
  //           enableInfiniteScroll: false,
  //         ),
  //       ),
  //     );
  //   } else {
  //     return const SizedBox();
  //   }
  // }
}
