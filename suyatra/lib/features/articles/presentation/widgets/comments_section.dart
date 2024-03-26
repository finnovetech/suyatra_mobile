import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/font_sizes.dart';
import '../../../../core/app_status.dart';
import '../../../../core/service_locator.dart';
import '../../../../services/firebase_service.dart';
import '../../../../widgets/text_field_widget.dart';
import '../../domain/entities/article_comment_entity.dart';
import '../cubit/articles/article_cubit.dart';
import '../cubit/articles/article_state.dart';

class ArticleComments extends StatefulWidget {
  final ArticleEntity article;
  const ArticleComments({super.key, required this.article});

  @override
  State<ArticleComments> createState() => _ArticleCommentsState();
}

class _ArticleCommentsState extends State<ArticleComments> {

  void getComments() async {
    context.read<ArticleCubit>().getArticleComments(articleId: "${widget.article.id}");
  }

  @override
  void initState() {
    super.initState();
    getComments();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, ArticleState>(
      builder: (context, state) {
        return Padding(
          key: state.commentWidgetKey,
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          (locator<FirebaseService>()
                                      .firebaseAuth
                                      .currentUser
                                      ?.email
                                      ?.characters
                                      .firstOrNull ??
                                  "G")
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: h7,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextFieldWidget(
                        controller: state.commentContoller,
                        hintText: "Share your views on this...",
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    InkWell(
                      onTap: () {
                        context
                            .read<ArticleCubit>()
                            .addArticleComment(article: widget.article, comment: {
                          "data": state.commentContoller!.text,
                          "user_name": locator<FirebaseService>()
                                  .firebaseAuth
                                  .currentUser
                                  ?.email ??
                              "",
                        });
                      },
                      child: state.articleStatus == AppStatus.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
              state.articleComments?.isNotEmpty == true
                  ? CarouselSlider.builder(
                      itemCount: state.articleComments!.length,
                      itemBuilder: (context, index, _) {
                        CommentEntity comment = state.articleComments![index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: grey300,
                            ),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(
                                  right:
                                      index == state.articleComments!.length - 1
                                          ? 0
                                          : 16.0)
                              .copyWith(top: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 32,
                                          width: 32,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: primaryColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              comment.userName.characters.first
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: h9,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Expanded(
                                          child: Text(
                                            comment.userName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    comment.createdDate,
                                    style: const TextStyle(
                                      color: grey500,
                                      fontSize: h11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Expanded(
                                child: Text(
                                  comment.data,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 8,
                                  style: const TextStyle(color: grey500),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      options: CarouselOptions(
                        viewportFraction: 0.91,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: false,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }
}
