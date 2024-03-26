import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/widgets/custom_button.dart';
import 'package:suyatra/widgets/text_widgets/heading_text.dart';
import 'package:suyatra/widgets/text_widgets/sub_heading_text.dart';

class GuestAccountDeletePage extends StatelessWidget {
  const GuestAccountDeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SvgPicture.asset("assets/icons/delete_account.svg"),
                    const SizedBox(height: 24.0),
                    const HeadingText("DELETE GUEST ACCOUNT", textAlign: TextAlign.center),
                    const SizedBox(height: 16.0),
                    const SubHeadingText(
                      "All your data will be deleted irrecoverably. If you want to delete guest account click on confirm deletion button.",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            CustomButton(
              onPressed: () {
                
              },
              buttonColor: red50,
              label: "delete guest account",
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              onPressed: () {
                
              },
              isTextButton: true,
              label: "keep using guest account",
            )
          ],
        ),
      ),
    );
  }
}