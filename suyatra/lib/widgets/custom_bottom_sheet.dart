import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_colors.dart';
import '../constants/enums.dart';
import '../constants/font_sizes.dart';
import '../core/service_locator.dart';
import '../services/navigation_service.dart';

customBottomSheet(
  BuildContext context, {
  List<Widget>? leadingActions,
  List<Widget>? actions,
  String? title,
  IconPosition closeIconPositon = IconPosition.left,
  Widget? child,
  Widget? builder,
  bool canClose = true,
  bool hasMargin = false,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) {
      return builder ?? BottomSheetHeadBuilder(
        children: [
          canClose || leadingActions != null || actions != null ? Row(
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    closeIconPositon == IconPosition.left && canClose
                      ? InkWell(
                          onTap: () {
                            locator<NavigationService>().goBack();
                          },
                          child: SvgPicture.asset("assets/icons/close.svg"),
                        )
                      : SizedBox(width: leadingActions != null ? 0.0 : 24.0,),
                    leadingActions != null 
                      ? Row(children: [...leadingActions])
                      : const SizedBox(),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title ?? "",
                    style: const TextStyle(
                      fontSize: h4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  actions != null 
                    ? Row(children: [...actions])
                    : const SizedBox(),
                  closeIconPositon == IconPosition.right && canClose
                    ? InkWell(
                        onTap: () {
                          locator<NavigationService>().goBack();
                        },
                        child: SvgPicture.asset("assets/icons/close.svg"),
                      )
                    : SizedBox(width: actions != null ? 0.0 : 24.0,),
                ],
              ),
            ],
          ) : const SizedBox(),
          const SizedBox(height: 8.0),
          child ?? const SizedBox(),
        ],
      );
    },
  );
}

class BottomSheetHeadBuilder extends StatelessWidget {
  final List<Widget> children;
  final bool hasMargin;
  const BottomSheetHeadBuilder({super.key, required this.children, this.hasMargin = false});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          margin: hasMargin ? const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 16.0) : null,
          padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(bottom: 24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: !hasMargin ? const BorderRadius.only(
              topLeft: Radius.circular(28.0),
              topRight: Radius.circular(28.0),
            ) : BorderRadius.circular(28.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8.0),
              Container(
                height: 4,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: grey200,
                ),
              ),
              const SizedBox(height: 8.0),
              ...children,
            ],
          ),
        );
      }
    );
  }
}