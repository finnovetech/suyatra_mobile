// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/core/service_locator.dart';
// import 'package:suyatra/features/articles/presentation/pages/home_page.dart';
import 'package:suyatra/services/app_routes.dart';
import 'package:suyatra/services/navigation_service.dart';
import '../../../../constants/font_sizes.dart';
import '../../../../services/shared_preference_service.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
// import '../../../../widgets/custom_button.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context);
    Future.delayed(const Duration(seconds: 2), () async {
      String? token = await locator<SharedPreferencesService>().getToken();
      
      if(token != null) {
        locator<NavigationService>().navigateTo(layoutRoute);
      } else {
        locator<NavigationService>().navigateTo(welcomeRoute);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: _body(),
    );
  }

  Widget _body() {
    // return StreamBuilder<User?>(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (context, snapshot) {
    //     switch (snapshot.hasData) {
    //       case true:
    //         return const HomePage();
    //       default:
    //         return _splash();
    //     }
    //   }
    // );
    return _splash();
  }

  Widget _splash() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/app_icon.jpg"),
                  const Text(
                    "Nepal Travel Guide",
                    style: TextStyle(
                      fontSize: h3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    "Explore Nepal Like Never Before!",
                    style: TextStyle(
                      fontSize: h9,
                      color: grey700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          const CircularProgressIndicator(),
          // CustomButton(
          //   label: "Get started from free",
          //   onPressed: () {
          //     locator<NavigationService>().navigateToAndBack(signUpRoute);
          //   },
          // ),
          // const SizedBox(height: 16.0),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Text(
          //       "Already have account? ",
          //       style: TextStyle(
          //         fontSize: h9,
          //         fontWeight: FontWeight.w500,
          //         color: grey500,
          //       ),
          //     ),
          //     InkWell(
          //       onTap: () {
          //         locator<NavigationService>().navigateToAndBack(loginRoute);
          //       },
          //       child: const Text(
          //         "Login",
          //         style: TextStyle(
          //           fontSize: h9,
          //           fontWeight: FontWeight.w500,
          //           color: himalayanBlue,
          //         ),
          //       )
          //     )
          //   ],
          // ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}