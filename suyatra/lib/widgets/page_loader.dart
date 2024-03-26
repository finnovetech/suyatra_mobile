import 'dart:io';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class PageLoader extends StatelessWidget {
  final Color? backgroundColor;
  final Color? valueColor;
  final double? height;
  final double? width;
  const PageLoader({Key? key, this.backgroundColor, this.valueColor, this.height, this.width,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: SizedBox(
          height: height ?? 24,
          width: width ?? 24,
          child: CircularProgressIndicator.adaptive(
            backgroundColor: backgroundColor ?? (Platform.isIOS
                  ? Colors.black
                  : grey100),
                  strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(valueColor ?? himalayanBlue),
          ),
        ),
      ),
    );
  }
}
