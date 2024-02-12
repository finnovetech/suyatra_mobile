import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:suyatra/widgets/custom_button.dart';
import 'package:suyatra/widgets/text_field_widget.dart';

import '../../../../core/app_status.dart';
import '../../../../core/service_locator.dart';
import '../../../../services/app_routes.dart';
import '../../../../services/navigation_service.dart';
import '../../../articles/domain/entities/article_entity.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  final String? navigateBackTo;
  final ArticleEntity? article;
  const LoginPage({super.key, this.navigateBackTo, this.article});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4.0),
                  const Text(
                    "Login to Suyatra",
                    style: TextStyle(
                      fontSize: h3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextFieldWidget(
                    autoFocus: true,
                    controller: _emailController,
                    autoFillHints: const [AutofillHints.email],
                    hintText: "Email",
                  ),
                  const SizedBox(height: 24.0),
                  TextFieldWidget(
                    isPasswordField: true,
                    controller: _passwordController,
                    hintText: "Password",
                  ),
                  const SizedBox(height: 24.0),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      switch (state.authStatus) {
                        case AppStatus.success:
                          switch (widget.navigateBackTo) {
                            case null:
                              locator<NavigationService>().navigateTo(homeRoute);
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
                                label: "Login",
                                isUppercase: false,
                                onPressed: () {
                                  context.read<AuthCubit>().signInUser(
                                    email: _emailController.text, 
                                    password: _passwordController.text
                                  );
                                },
                                isLoading: state.authStatus == AppStatus.loading,
                                isDisabled: _passwordController.text.isEmpty || _emailController.text.isEmpty,
                              );
                            }
                          );
                        }
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "I forgot my password",
                        style: TextStyle(
                          color: blackColor,
                          fontSize: h9,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
                    onPressed: () {
                      context.read<AuthCubit>().signInWithGoogle();
                    },
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0)
                .copyWith(bottom: 24.0),
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
                        )),
                    const TextSpan(
                      text: "and ",
                    ),
                    TextSpan(
                        text: "Privacy Policy",
                        recognizer: TapGestureRecognizer()..onTap = () {},
                        style: const TextStyle(
                          color: primaryDark,
                          decoration: TextDecoration.underline,
                        ))
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
