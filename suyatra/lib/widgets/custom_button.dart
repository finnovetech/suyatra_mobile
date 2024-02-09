import 'package:flutter/material.dart';
import 'package:suyatra/widgets/page_loader.dart';

import '../constants/app_colors.dart';
import '../constants/enums.dart';
import '../constants/font_sizes.dart';

class CustomButton extends StatelessWidget {
  final String? label;
  final TextStyle? labelStyle;
  final void Function()? onPressed;
  final Widget? icon;
  final IconPosition iconPosition;
  final Color? buttonColor;
  final Color? textColor;
  final bool fullWidth;
  final double verticalPadding;
  final double horizontalPadding;
  final double elevation;
  final bool isExpanded;
  final bool isDisabled;
  final EdgeInsetsGeometry? margin;
  final bool isUppercase;
  final double? fontSize;
  final Color? borderColor;
  final bool isLoading;
  const CustomButton({
    super.key,
    this.isExpanded = false,
    this.label,
    this.elevation = 0,
    this.labelStyle,
    this.onPressed,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.buttonColor,
    this.textColor,
    this.fullWidth = true,
    this.verticalPadding = 16,
    this.horizontalPadding = 16,
    this.isDisabled = false,
    this.margin,
    this.isUppercase = true,
    this.fontSize,
    this.borderColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? Expanded(
            child: _body(),
          )
        : _body();
  }

  Widget _body() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: isDisabled ? grey400 : (buttonColor ?? blackColor),
          foregroundColor: textColor ?? whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
            side: BorderSide(
              color: borderColor ?? buttonColor ?? blackColor,
            )
          ),
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
        ),
        onPressed: isDisabled || isLoading ? null : onPressed,
        child: isLoading ? const PageLoader(height: 20, width: 20,) : Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null && iconPosition == IconPosition.left
                ? Padding(
                    padding: label != null
                        ? const EdgeInsets.only(right: 16.0)
                        : EdgeInsets.zero,
                    child: icon!,
                  )
                : const SizedBox(),
            label != null
                ? Text(
                    isUppercase ? label!.toUpperCase() : label!,
                    style: labelStyle ??
                        TextStyle(
                          fontSize: fontSize ?? h9,
                          fontWeight: FontWeight.w500,
                          color: textColor ?? whiteColor,
                        ),
                  )
                : const SizedBox(),
            icon != null && iconPosition == IconPosition.right
                ? Padding(
                    padding: label != null
                        ? const EdgeInsets.only(left: 16.0)
                        : EdgeInsets.zero,
                    child: icon!,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
