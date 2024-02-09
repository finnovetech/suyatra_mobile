import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/core/app_status.dart';
import 'package:suyatra/features/articles/domain/entities/article_entity.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_state.dart';
import 'package:suyatra/widgets/custom_button.dart';
import 'package:suyatra/widgets/page_loader.dart';
import 'package:suyatra/widgets/text_field_widget.dart';

import '../../../../core/service_locator.dart';
import '../../../../services/app_routes.dart';
import '../../../../services/navigation_service.dart';

class SignUpPage extends StatefulWidget {
  final String? navigateBackTo;
  final ArticleEntity? article;
  const SignUpPage({super.key, this.navigateBackTo, this.article,});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
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
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4.0),
                const Text(
                  "Create Suyatra account for free",
                  style: TextStyle(
                    fontSize: h3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24.0),
                TextFieldWidget(
                  autoFocus: true,
                  controller: _emailController,
                  hintText: "Email",
                ),
                const SizedBox(height: 24.0),
                TextFieldWidget(
                  controller: _passwordController,
                  hintText: "Password",
                  isPasswordField: true,
                ),
                const SizedBox(height: 24.0),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    switch (state.authStatus) {
                      case AppStatus.success:
                        switch (widget.navigateBackTo) {
                          case null:
                            locator<NavigationService>().navigateToAndRemoveAll(homeRoute);
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
                      valueListenable: _passwordController,
                      builder: (context, _, widget) {
                        return ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _emailController,
                          builder: (context, _, widget) {
                            return CustomButton(
                              label: "Sign Up",
                              isUppercase: false,
                              isLoading: state.authStatus == AppStatus.loading,
                              isDisabled: _emailController.text.isEmpty || _passwordController.text.isEmpty,
                              onPressed: () {
                                context.read<AuthCubit>().signUpUser(
                                  email: _emailController.text, 
                                  password: _passwordController.text,
                                );  
                              },
                            );
                          }
                        );
                      }
                    );
                  }
                ),
                const SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have account? ",
                        style: TextStyle(
                          fontSize: h9,
                          fontWeight: FontWeight.w500,
                          color: grey500,
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
                            default:
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: h9,
                            fontWeight: FontWeight.w500,
                            color: primaryDark,
                          ),
                        )
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 36.0),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: grey200,
                        endIndent: 8.0,
                        height: 0,
                      ),
                    ),
                    Text(
                      "or",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: grey700,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: grey200,
                        indent: 8.0,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                CustomButton(
                  label: "Continue with google",
                  buttonColor: Colors.transparent,
                  borderColor: blackColor,
                  textColor: blackColor,
                  icon: SvgPicture.asset("assets/icons/google.svg"),
                ),
                const SizedBox(height: 12.0),
                CustomButton(
                  label: "Continue with apple",
                  buttonColor: Colors.transparent,
                  borderColor: blackColor,
                  textColor: blackColor,
                  icon: SvgPicture.asset("assets/icons/apple.svg"),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 24.0),
          child: RichText(
            text: TextSpan(
              text: "By proceeding yo agree to our ",
              style: const TextStyle(
                fontSize: h9,
                color: blackColor,
              ),
              children: [
                TextSpan(
                  text: "Terms of Use ",
                  recognizer: TapGestureRecognizer()..onTap = () {},
                  style: const TextStyle(
                    color: primaryDark,
                    decoration: TextDecoration.underline,
                  )
                ),
                const TextSpan(
                  text: "and ",
                ),
                TextSpan(
                  text: "Privacy Policy",
                  recognizer: TapGestureRecognizer()..onTap = () {},
                  style: const TextStyle(
                    color: primaryDark,
                    decoration: TextDecoration.underline,
                  )
                )
              ]
            ),
          ),
        )
      ],
    );
  }
}