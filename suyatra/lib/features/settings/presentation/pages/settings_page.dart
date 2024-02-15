import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/core/app_status.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:suyatra/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:suyatra/services/app_routes.dart';
import 'package:suyatra/services/firebase_service.dart';
import 'package:suyatra/services/navigation_service.dart';
import 'package:suyatra/utils/string_extensions.dart';
import 'package:suyatra/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  _launchWhatsapp() async {
    var contact = "+977-9818008585";
    var text = "";
    var whatsappAndroid = Uri.parse("whatsapp://send?phone=$contact&text=$text");

    var whatsappIOS = Uri.parse("https://wa.me/$contact?text=${Uri.parse(text)}");

    if (Platform.isIOS) {
      if (await canLaunchUrl(whatsappIOS)) {
        await launchUrl(whatsappIOS);
      } else {
        ScaffoldMessenger.of(locator<NavigationService>().navigationKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text("WhatsApp is not installed on the device"),
          ),
        );
      }
    } else {
      if (await canLaunchUrl(whatsappAndroid)) {
        await launchUrl(whatsappAndroid);
      } else {
        ScaffoldMessenger.of(
            locator<NavigationService>().navigationKey.currentContext!)
            .showSnackBar(
          const SnackBar(
            content: Text("WhatsApp is not installed on the device"),
          ),
        );
      }
    }
  }

  _launchEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'admin@suyatra.com',
      query: 'subject=Sharing experience&body=', //add subject and body here
    );

    var url = params.toString();
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = context.watch<AuthCubit>();
    User? currentUser = locator<FirebaseService>().firebaseAuth.currentUser;
    return BlocProvider<SettingsCubit>(
      create: (context) => SettingsCubit(),
      child: Scaffold(
        appBar: _appBar(),
        body: _body(authCubit, currentUser),
      )
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      leading: locator<NavigationService>().navigationKey.currentState!.canPop() 
        ? null 
        : IconButton(
            onPressed: () {
              locator<NavigationService>().navigateTo(homeRoute);
            }, 
            icon: Icon(Icons.adaptive.arrow_back),
          ),
      title: const Text("Settings"),
    );
  }

  Widget _body(AuthCubit authCubit, User? currentUser) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            children: [
              _profileSection(authCubit),
              const SizedBox(height: 24.0),
              _contactSection(),
              const SizedBox(height: 32.0),
              CustomButton(
                onPressed: () {
                  authCubit.signOutUser();
                },
                isLoading: authCubit.state.authStatus == AppStatus.loading,
                label: "Sign Out",
                textColor: Colors.red.shade900,
                buttonColor: Colors.red.withOpacity(0.12),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _profileSection(AuthCubit authCubit) {
    User? currentUser = locator<FirebaseService>().firebaseAuth.currentUser;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (currentUser?.displayName?.capitalize() ?? currentUser?.email!) ?? "",
                style: TextStyle(
                  fontSize: currentUser?.displayName == null ? h8 : h5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              currentUser?.displayName != null ? Text(
                currentUser?.email?.capitalize() ?? "",
                style: const TextStyle(
                  fontSize: h10,
                  fontWeight: FontWeight.w500,
                  color: grey400,
                ),
              ) : const SizedBox()
            ],
          ),
        ),
        const Expanded(
          child: SizedBox(
            width: 2,
            height: 64,
            child: VerticalDivider(
              width: 4,
              color: grey400,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            locator<NavigationService>().navigateToAndBack(editUserProfileRoute);
          },
          icon: Icon(Icons.adaptive.arrow_forward_sharp),
        ),
      ],
    );
  }

  Widget _contactSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: grey300,
        )
      ),
      child: Column(
        children: [
          const Text(
            "Share your Nepal experience with us!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: h7,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4.0),
          const Text(
            "Send us your Text travelogue, stories, photos, and feedback to:",
            style: TextStyle(
              color: grey400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24.0),
          CustomButton(
            onPressed: () {
              _launchWhatsapp();
            },
            icon: SvgPicture.asset(
              "assets/icons/whatsapp.svg",
              height: 24,
              width: 24,
            ),
            label: "+977-9818008585",
            buttonColor: Colors.transparent,
            borderColor: grey400,
            textColor: blackColor,
          ),
          const SizedBox(height: 16.0),
          CustomButton(
            onPressed: () {
              _launchEmail();
            },
            icon: const Icon(Icons.email_outlined, size: 24.0,),
            label: "admin@suyatra.com",
            isUppercase: false,
            buttonColor: Colors.transparent,
            borderColor: grey400,
            textColor: blackColor,
          ),
          const SizedBox(height: 8.0),
          const Text(
            "Help enrich our Suyatra community!",
            style: TextStyle(
              fontSize: h11,
              color: grey400,
            ),
          ),
        ],
      ),
    );
  }
}