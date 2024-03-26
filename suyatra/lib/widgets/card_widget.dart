import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/font_sizes.dart';

class CardWidget extends StatelessWidget {
  final String? label;
  final Widget? card;
  final EdgeInsets? margin;
  final bool hasMargin;
  final EdgeInsets? labelMargin;
  final List<Widget>? actions;
  final Widget? child;
  final Clip? clipBehavior;
  const CardWidget({super.key, this.label, this.card, this.margin, this.hasMargin = true, this.labelMargin, this.actions, this.child, this.clipBehavior,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null || actions != null ? Padding(
          padding: labelMargin?.copyWith(bottom: 12.0) ?? const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              label != null ? Text(
                label!,
                style: const TextStyle(
                  fontSize: h8,
                  fontWeight: FontWeight.w500,
                  color: grey70,
                ),
              ) : const SizedBox(),
              actions != null ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...actions!,
                ],
              ) : const SizedBox()
            ],
          ),
        ) : const SizedBox(),
        Padding(
          padding: hasMargin ? (margin ?? const EdgeInsets.symmetric(horizontal: 16.0)) : EdgeInsets.zero,
          child: card ?? Container(
            clipBehavior: clipBehavior ?? Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: child,
          ),
        )
      ],
    );
  }
}