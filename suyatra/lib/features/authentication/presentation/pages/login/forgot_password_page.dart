import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:suyatra/services/app_routes.dart';
import 'package:suyatra/services/navigation_service.dart';
import 'package:suyatra/widgets/custom_button.dart';
import 'package:suyatra/widgets/text_field_widget.dart';
import 'package:suyatra/widgets/text_widgets/heading_text.dart';

import '../../../../../widgets/text_widgets/sub_heading_text.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const HeadingText("forgot your password?"),
            const SizedBox(height: 8.0),
            const SubHeadingText("No worries! We'll help you reset it. Please enter your email address associated with your account"),
            const SizedBox(height: 24.0),
            TextFieldWidget(
              controller: _emailController,
              hintText: "Email",
            ),
            const SizedBox(height: 24.0),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _emailController,
              builder: (context, email, _) {
                return CustomButton(
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context, listen: false).sendResetVerificationOTP(
                      email: email.text.trim(),
                    );
                    locator<NavigationService>().navigateTo(emailVerificationRoute, arguments: false);
                  },
                  isDisabled: email.text.isEmpty,
                  label: "Continue",
                );
              }
            )
          ],
        ),
      ),
    );
  }
}