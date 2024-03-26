import 'package:flutter/material.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';

class CustomListTile extends StatelessWidget {
  final String? titleText;
  final String? subTitleText;
  final Widget? title;
  final Widget? subTitle;
  final void Function()? onTap;
  final Widget? trailing;
  final Widget? leading;
  final double? leadingWidth;
  final bool isDense;
  final bool hasRadius;
  final String? trailingText;
  final TextStyle? trailingTextStyle;
  final Color? trailingIconColor;

  const CustomListTile({
    super.key,
    this.titleText,
    this.subTitleText,
    this.title,
    this.subTitle,
    this.onTap,
    this.trailing,
    this.leading,
    this.leadingWidth,
    this.isDense = false,
    this.hasRadius = true,
    this.trailingText,
    this.trailingTextStyle,
    this.trailingIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        onTap: onTap,
        dense: isDense,
        tileColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: hasRadius ? BorderRadius.circular(12.0) : BorderRadius.zero,
        ),
        title: title ?? (titleText != null ? Text(
          titleText!,
          style: TextStyle(
            fontSize: subTitleText != null || subTitle != null ? h7 : h9,
            fontWeight: subTitleText != null || subTitle != null ? FontWeight.w600 : FontWeight.w500,
          ),
        ) : null),
        subtitle: subTitle ?? (subTitleText != null ? Text(
          subTitleText!,
        ) : null),
        leading: leading,
        minLeadingWidth: leadingWidth,
        trailing: trailing ?? InkWell(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              trailingText != null ? Text(
                trailingText!,
                style: trailingTextStyle ?? const TextStyle(
                  fontSize: h9,
                  color: lightGrey,
                ),
              ) : const SizedBox(),
              Icon(
                Icons.chevron_right,
                color: trailingIconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
