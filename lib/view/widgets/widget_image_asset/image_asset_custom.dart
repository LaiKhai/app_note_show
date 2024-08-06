import 'package:flutter/material.dart';
import 'package:flutter_base_project/view/res/responsive/reponsive_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageAssetCustom extends StatelessWidget {
  final String imagePath;
  final double? size;
  final double? width;
  final double? height;
  final Color? color;
  final bool? sizeBaseOnWidth;
  final BoxFit? boxFit;
  const ImageAssetCustom({
    super.key,
    required this.imagePath,
    this.size,
    this.width,
    this.height,
    this.color,
    this.boxFit,
    this.sizeBaseOnWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.contains('svg')) {
      return SvgPicture.asset(
        imagePath,
        color: color,
        width: width ?? (sizeBaseOnWidth! ? size?.w : size?.h),
        height: height != null
            ? height?.h
            : sizeBaseOnWidth!
                ? width?.h
                : height?.h,
        fit: boxFit ?? BoxFit.contain,
      );
    }
    return Image.asset(
      imagePath,
      color: color,
      width: width ?? (sizeBaseOnWidth! ? size?.w : size?.h),
      height: height != null
          ? height?.h
          : sizeBaseOnWidth!
              ? width?.h
              : height?.h,
      fit: boxFit ?? BoxFit.contain,
    );

    // return Image(
    //   image: Svg(
    //     imagePath,
    //     size: Size(
    //       width ?? size,
    //       height ?? size,
    //     ),
    //   ),
    //   fit: BoxFit.contain,
    //   color: color,
    //   gaplessPlayback: true,
    // );
  }
}
