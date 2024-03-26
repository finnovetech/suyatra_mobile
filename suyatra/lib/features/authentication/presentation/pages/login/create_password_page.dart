import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:suyatra/widgets/custom_button.dart';
import 'package:suyatra/widgets/text_field_widget.dart';
import 'package:suyatra/widgets/text_widgets/heading_text.dart';
import 'package:suyatra/widgets/text_widgets/sub_heading_text.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeadingText("create password"),
            const SizedBox(height: 8.0),
            const SubHeadingText("Your passwords must be at least 8 characters long, and contain at least one letter and one number."),
            const SizedBox(height: 24.0),
            TextFieldWidget(
              controller: _passwordController,
              hintText: "Create Password",
              isPasswordField: true,
            ),
            const SizedBox(height: 16.0),
            TextFieldWidget(
              controller: _confirmPasswordController,
              hintText: "Re-enter Password",
              isPasswordField: true,
            ),
            const SizedBox(height: 24.0),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _passwordController,
              builder: (context, password, _) {
                return ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _confirmPasswordController,
                  builder: (context, confirmPassword, _) {
                    return CustomButton(
                      label: "Confirm",
                      isDisabled: _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty || _passwordController.text != _confirmPasswordController.text,
                      onPressed: () {
                        authCubit.createPassword(
                          password: password.text, 
                          confirmPassword: confirmPassword.text,
                        );
                      },
                    );
                  }
                );
              }
            )
          ],
        ),
      ),
    );
  }
}