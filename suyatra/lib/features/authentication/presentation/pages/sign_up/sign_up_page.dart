import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/core/app_status.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_state.dart';
import 'package:suyatra/widgets/custom_button.dart';
import 'package:suyatra/widgets/page_loader.dart';
import 'package:suyatra/widgets/text_field_widget.dart';

import '../../../../../core/service_locator.dart';
import '../../../../../services/app_routes.dart';
import '../../../../../services/navigation_service.dart';

class SignUpPage extends StatefulWidget {
  final String? navigateBackTo;
  final ArticleEntity? article;
  const SignUpPage({super.key, this.navigateBackTo, this.article,});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }
  
  PreferredSizeWidget _appBar() {
    return AppBar();
  }

  Widget _body() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "LET'S GET STARTED!",
            style: TextStyle(
              fontSize: h1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            "Enter your details to continue",
            style: TextStyle(
              fontSize: h9,
              color: grey500,
            ),
          ),
          const SizedBox(height: 24.0),
          TextFieldWidget(
            autoFocus: true,
            controller: _fullNameController,
            hintText: "Full Name",
          ),
          const SizedBox(height: 24.0),
          TextFieldWidget(
            controller: _emailController,
            hintText: "Email",
          ),
          const SizedBox(height: 24.0),
          TextFieldWidget(
            controller: _passwordController,
            hintText: "Create Password",
            isPasswordField: true,
          ),
          const SizedBox(height: 24.0),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              switch (state.authStatus) {
                case AppStatus.success:
                  switch (widget.navigateBackTo) {
                    case null:
                      locator<NavigationService>().navigateToAndBack(emailVerificationRoute);
                      break;
                    case articleDetailsRoute:
                      locator<NavigationService>().navigateToAndRemoveAll(
                        widget.navigateBackTo!, 
                        arguments: {
                          "article": widget.article!, 
                          "tag": "", 
                          "scroll_to_comment": true,
                        },
                      );
                    case settingsRoute:
                      locator<NavigationService>().navigateToAndRemoveAll(
                        widget.navigateBackTo!, 
                        arguments: {
                        },
                      );
                    default:
                  }
                  break;
                case AppStatus.failure:
                  const PageLoader();
                default:
              }
            },
            builder: (context, state) {
              return ValueListenableBuilder<TextEditingValue>(
                valueListenable: _fullNameController,
                builder: (context, fullName, widget) {
                  return ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _passwordController,
                    builder: (context, password, widget) {
                      return ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _emailController,
                        builder: (context, email, widget) {
                          return CustomButton(
                            label: "Continue",
                            isLoading: state.authStatus == AppStatus.loading,
                            isDisabled: email.text.isEmpty || password.text.isEmpty || fullName.text.isEmpty,
                            onPressed: () {
                              context.read<AuthCubit>().signUpUser(
                                email: email.text.trim(), 
                                password: password.text.trim(),
                                fullName: fullName.text.trim(),
                              );
                            },
                          );
                        }
                      );
                    }
                  );
                }
              );
            }
          ),
          const SizedBox(height: 40.0),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have account? ",
                  style: TextStyle(
                    fontSize: h9,
                    color: grey70,
                  ),
                ),
                InkWell(
                  onTap: () {
                    switch (widget.navigateBackTo) {
                      case null:
                        locator<NavigationService>().navigateToAndBack(loginRoute, arguments: {});
                        break;
                      case articleDetailsRoute:
                        locator<NavigationService>().navigateToAndBack(
                          loginRoute, 
                          arguments: {
                            "route": articleDetailsRoute,
                            "article": widget.article!, 
                          },
                        );
                        break;
                      case settingsRoute:
                        locator<NavigationService>().navigateToAndBack(
                          loginRoute, 
                          arguments: {
                            "route": settingsRoute,
                          },
                        );
                        break;
                      default:
                    }
                  },
                  child: const Text(
                    "Login Now",
                    style: TextStyle(
                      fontSize: h9,
                      fontWeight: FontWeight.w600,
                      color: blackColor,
                    ),
                  )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}