import 'package:flutter/material.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/services/app_routes.dart';
import 'package:suyatra/services/navigation_service.dart';
import 'package:suyatra/widgets/custom_list_tile.dart';

class GuestAccountSettingsPage extends StatelessWidget {
  const GuestAccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Guest Account"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "You are using an anonymous sherpa guest account. To avoid potential data loss and add companions, sign up now.",
              style: TextStyle(
                fontSize: h9,
                color: lightGrey,
              ),
            ),
            const SizedBox(height: 24.0),
            CustomListTile(
              onTap: () {

              },
              leading: const Icon(
                Icons.person_outline,
                color: blackColor,
              ),
              leadingWidth: 24.0,
              titleText: "Signup Now",
            ),
            const SizedBox(height: 48.0),
            const Text(
              "Already have an account?",
              style: TextStyle(
                fontSize: h9,
                color: lightGrey,
              ),
            ),
            const SizedBox(height: 24.0),
            CustomListTile(
              onTap: () {
                locator<NavigationService>().navigateToAndBack(guestAccountDeleteRoute);
              },
              leading: const Icon(Icons.delete_forever_rounded, color: blackColor),
              titleText: "Delete Guest Account",
            ),
          ],
        ),
      ),
    );
  }
}