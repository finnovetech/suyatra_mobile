import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/constants/string_constants.dart';
import 'package:suyatra/widgets/custom_button.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Support"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 64.0),
            Image.asset("assets/images/support.png"),
            const SizedBox(height: 64.0),
            CustomButton(
              onPressed: () {
        
              },
              icon: const Icon(Icons.email, color: blackColor),
              label: supportMail,
              fontSize: h8,
              fontWeight: FontWeight.w700,
              isUppercase: false,
              isSecondary: true,
            ),
            const SizedBox(height: 24.0),
            CustomButton(
              onPressed: () {
        
              },
              icon: SvgPicture.asset(
                "assets/icons/whatsapp.svg",
                height: 24.0,
                width: 24.0,
              ),
              label: supportNumber,
              fontSize: h8,
              fontWeight: FontWeight.w700,
              textColor: blackColor,
              buttonColor: grey10,
            )
          ],
        ),
      ),
    );
  }
}