import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/core/app_status.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/account/presentation/cubit/account_cubit.dart';
import 'package:suyatra/features/authentication/domain/entities/user_entity.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:suyatra/services/navigation_service.dart';
import 'package:suyatra/widgets/card_widget.dart';
import 'package:suyatra/widgets/custom_button.dart';
import 'package:suyatra/widgets/page_loader.dart';

import '../../../../services/app_routes.dart';
import '../../../../widgets/custom_list_tile.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _appVersion = "";
  
  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }
  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return BlocProvider<AccountCubit>(
      create: (context) => AccountCubit(),
      child: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          switch (state.accountStatus) {
            case AppStatus.loading:
              return const PageLoader();
            default:
              return _scaffold(BlocProvider.of<AccountCubit>(context), authCubit);
          }
        },
      ),
    );
  }

  Widget _scaffold(AccountCubit cubit, AuthCubit authCubit) {
    UserEntity? user = authCubit.state.user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Account",
          style: TextStyle(
            fontSize: h6,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomListTile(
              onTap: () {
                if(user != null) {

                } else {
                  locator<NavigationService>().navigateToAndBack(guestAccountSettingsRoute);
                }
              },
              leading: Container(
                height: 64.0,
                width: 64.0,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: himalayanNight,
                ),
                child: user?.profileUrl != null 
                  ? Image.network(user!.profileUrl!)
                  : Image.asset("assets/images/guest_placeholder.png"),
              ),
              titleText: user?.firstName ?? "Sherpa Guest",
              subTitleText: user?.email ?? "Signup now to explore more",
            ),
            const SizedBox(height: 24.0),
            CustomListTile(
              onTap: () {},
              leading: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SvgPicture.asset("assets/icons/premium.svg"),
              ),
              leadingWidth: 24,
              titleText: "Get Premium for Free",
              subTitleText: "Earn up to \$9.99",
            ),
            const SizedBox(height: 24.0),
            CardWidget(
              label: "Account Settings",
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  CustomListTile(
                    isDense: true,
                    hasRadius: false,
                    onTap: () {},
                    titleText: "Subscription",
                    leading: SvgPicture.asset("assets/icons/payment_filled.svg"),
                    leadingWidth: 24.0,
                  ),
                  const SizedBox(height: 2.0),
                  CustomListTile(
                    isDense: true,
                    hasRadius: false,
                    onTap: () {},
                    titleText: "Language",
                    trailingText: "English",
                    leading: const Icon(Icons.language, color: blackColor),
                    leadingWidth: 24.0,
                  ),
                  const SizedBox(height: 2.0),
                  CustomListTile(
                    isDense: true,
                    hasRadius: false,
                    onTap: () {},
                    titleText: "Currency",
                    trailingText: "USD",
                    leading: const Icon(Icons.monetization_on_outlined, color: blackColor),
                    leadingWidth: 24.0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            CardWidget(
              label: "Support",
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  CustomListTile(
                    isDense: true,
                    hasRadius: false,
                    onTap: () {
                      locator<NavigationService>().navigateToAndBack(supportRoute);
                    },
                    titleText: "Support & Feedback",
                    leading: const Icon(Icons.live_help_outlined, color: blackColor),
                    leadingWidth: 24.0,
                  ),
                  const SizedBox(height: 2.0),
                  CustomListTile(
                    isDense: true,
                    hasRadius: false,
                    onTap: () {},
                    titleText: "About Us",
                    leading: const Icon(Icons.info_outline, color: blackColor),
                    leadingWidth: 24.0,
                  ),
                  const SizedBox(height: 2.0),
                  CustomListTile(
                    isDense: true,
                    hasRadius: false,
                    onTap: () {},
                    titleText: "Rate the app",
                    leading: const Icon(Icons.stars_outlined, color: blackColor),
                    leadingWidth: 24.0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            CustomButton(
              borderRadius: 12.0,
              onPressed: () {
                authCubit.signOutUser();
              },
              isUppercase: false,
              isLoading: authCubit.state.authStatus == AppStatus.loading,
              label: "Log out",
              buttonColor: whiteColor,
              textColor: sunsetRed,
            ),
            const SizedBox(height: 16.0),
            Text(
              "Budget Sherpa Version $_appVersion",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: grey70,
              ),
            )
          ],
        ),
      ),
    );
  }
}