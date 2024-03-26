import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:suyatra/services/app_routes.dart';
import 'package:suyatra/services/navigation_service.dart';
import 'package:suyatra/widgets/custom_button.dart';

import '../../../../../widgets/custom_bottom_sheet.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/primary_icon.png",
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          "Welcome to Budget Sherpa",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: h1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          "Spend, Split & Settle",
                          style: TextStyle(
                            fontSize: h7,
                            fontWeight: FontWeight.w500,
                            color: lightGrey,
                          ),
                        ),
                        const SizedBox(height: 48.0),
                        CustomButton(
                          onPressed: () {
                          },
                          isSecondary: true,
                          icon: const Icon(Icons.apple),
                          label: "CONTINUE WITH APPLE",
                        ),
                        const SizedBox(height: 16.0),
                        CustomButton(
                          onPressed: () {
                            authCubit.signInWithGoogle();
                          },
                          isSecondary: true,
                          icon: SvgPicture.asset("assets/icons/google.svg"),
                          label: "CONTINUE WITH GOOGLE",
                        ),
                        const SizedBox(height: 16.0),
                        CustomButton(
                          onPressed: () {
                            locator<NavigationService>().navigateToAndBack(signUpRoute, arguments: {});
                          },
                          isSecondary: true,
                          buttonColor: grey20,
                          borderColor: grey40,
                          icon: const Icon(Icons.email, size: 24.0,),
                          label: "CONTINUE WITH EMAIL",
                        ),
                        const SizedBox(height: 16.0),
                        CustomButton(
                          onPressed: () {
                            createGuestAccountSheet(context);
                          },
                          isTextButton: true,
                          label: "CONTINUE AS GUEST",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: "By proceeding you agree to our ",
                style: TextStyle(
                  color: blackColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "Terms of Use ",
                    style: TextStyle(
                      color: himalayanBlue,
                      decoration: TextDecoration.underline,
                    )
                  ),
                  TextSpan(
                    text: "and ",
                  ),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(
                      color: himalayanBlue,
                      decoration: TextDecoration.underline,
                    )
                  ),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }

  createGuestAccountSheet(BuildContext context) {
    return customBottomSheet(
      context,
      canClose: false,
      hasMargin: false,
      child: Column(
        children: [
          const Text(
            "Create Guest Account?",
            style: TextStyle(
              fontSize: h5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24.0),
          const Text(
            "Are you sure you don't want to create an account or login with an existing account?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: grey70,
            ),
          ),
          const SizedBox(height: 24.0),
          CustomButton(
            onPressed: () {},
            isSecondary: true,
            borderColor: grey40,
            label: "CONTINUE AS GUEST",
          ),
          const SizedBox(height: 8.0),
          CustomButton(
            onPressed: () {
              locator<NavigationService>().goBack();
            },
            isTextButton: true,
            textColor: sunsetRed,
            label: "CANCEL",
          ),
        ],
      )
    );
  }
}