import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final Color? color;
  final BlendMode? colorBlendMode;
  final BoxFit fit;
  final double? height;
  final double? width;
  final double? opacity;
  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    this.color,
    this.colorBlendMode,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Opacity(
        opacity: opacity ?? 1,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: height,
          width: width,
          errorWidget: (context, url, error) => const Icon(Icons.error),
          placeholder: (context, value) {
            return Image.asset(
              "assets/images/placeholder.jpg",
              fit: BoxFit.cover,
            );
          },
          fit: fit,
          color: color,
          colorBlendMode: colorBlendMode,
        ),
      ),
    );
  }
}
