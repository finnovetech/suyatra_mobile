import 'package:flutter/material.dart';
import 'package:suyatra/constants/app_colors.dart';

import '../../constants/font_sizes.dart';

class SubHeadingText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final TextStyle? style;
  final FontWeight? fontWeight;
  final bool isUpperCase;
  const SubHeadingText(this.text, {super.key, this.textColor, this.style, this.fontWeight, this.isUpperCase = true});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? TextStyle(
        fontSize: h9,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: textColor ?? grey400,
      ),
    );
  }
}