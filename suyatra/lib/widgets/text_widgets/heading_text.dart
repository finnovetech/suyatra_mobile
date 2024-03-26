import 'package:flutter/material.dart';
import 'package:suyatra/constants/app_colors.dart';

import '../../constants/font_sizes.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final TextStyle? style;
  final FontWeight? fontWeight;
  final bool isUpperCase;
  const HeadingText(this.text, {super.key, this.textColor, this.style, this.fontWeight, this.isUpperCase = true});

  @override
  Widget build(BuildContext context) {
    return Text(
      isUpperCase ? text.toUpperCase() : text,
      style: style ?? TextStyle(
        fontSize: h1,
        fontWeight: fontWeight ?? FontWeight.w700,
        color: textColor ?? blackColor,
      ),
    );
  }
}