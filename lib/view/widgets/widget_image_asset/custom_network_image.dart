import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_project/view/widgets/widget_image_asset/default_image.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    this.imageUrl,
    this.boxFit,
    this.height,
    this.width,
    this.size,
  });

  final String? imageUrl;
  final double? size;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      height: size ?? height,
      width: size ?? width,
      fit: boxFit,
      errorWidget: (context, url, error) => const DefaultImage(),
      placeholder: (context, url) => const DefaultImage(),
    );
  }
}
