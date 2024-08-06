import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_project/core/gen/assets.gen.dart';
import 'package:flutter_base_project/view/res/responsive/reponsive_extension.dart';
import 'package:flutter_base_project/view/widgets/widget_image_asset/image_asset_custom.dart';

class CircleAvatarCustom extends StatelessWidget {
  const CircleAvatarCustom({
    super.key,
    this.imageUrl = '',
    this.size = 24,
    this.imageFile,
  });

  final String imageUrl;
  final double size;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(1000),
      child: imageFile != null
          ? Image.file(
              imageFile!,
              width: size.w,
              height: size.w,
              fit: BoxFit.cover,
              errorBuilder: (context, url, error) => ImageAssetCustom(
                imagePath: Assets.images.emptyAvatar.path,
                size: size.w,
                boxFit: BoxFit.cover,
              ),
            )
          : CachedNetworkImage(
              imageUrl: imageUrl,
              width: size.w,
              height: size.w,
              fit: BoxFit.cover,
              placeholder: (context, url) => ImageAssetCustom(
                imagePath: Assets.images.emptyAvatar.path,
                boxFit: BoxFit.cover,
                size: size.w,
              ),
              errorWidget: (context, url, error) => ImageAssetCustom(
                imagePath: Assets.images.emptyAvatar.path,
                size: size.w,
                boxFit: BoxFit.cover,
              ),
            ),
    );
  }
}
