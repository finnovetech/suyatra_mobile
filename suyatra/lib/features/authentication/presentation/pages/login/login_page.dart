import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:suyatra/widgets/custom_button.dart';
import 'package:suyatra/widgets/text_field_widget.dart';

import '../../../../../core/app_status.dart';
import '../../../../../core/service_locator.dart';
import '../../../../../services/app_routes.dart';
import '../../../../../services/navigation_service.dart';
import '../../../../articles/domain/entities/article_entity.dart';
import '../../cubit/auth_state.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "WELCOME BACK!",
              style: TextStyle(
                fontSize: h1,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              "Login to your account.",
              style: TextStyle(
                fontSize: h9,
                color: grey400,
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
            TextButton(
              onPressed: () {
                locator<NavigationService>().navigateToAndBack(forgotPasswordRoute);
              },
              child: const Text(
                "Forgot Password",
                style: TextStyle(
                  color: grey70,
                  fontSize: h9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                switch (state.authStatus) {
                  case AppStatus.success:
                    switch (widget.navigateBackTo) {
                      case null:
                        locator<NavigationService>().navigateToAndRemoveAll(layoutRoute);
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
                          label: "Continue",
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
            const SizedBox(height: 36.0),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(
                    fontSize: h9,
                    color: grey70,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Register Now",
                      recognizer: TapGestureRecognizer()..onTap = () {
                        locator<NavigationService>().navigateToAndBack(welcomeRoute);
                      },
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      )
                    )
                  ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
