import 'package:flutter/material.dart';

class SizeConfig {
  late double designScreenWidth;
  late double desginScreenHeight;

  static final SizeConfig instance = SizeConfig._();

  SizeConfig._();

  double get _widthMultipler {
    // if (isLandscape.value) {
    //   return _currentHeightMultipler;
    // }

    return _currentWidthMultipler;
  }

  double get _heightMultipler {
    // if (isLandscape.value) {
    //   return _currentWidthMultipler;
    // }

    return _currentHeightMultipler;
  }

  double get _textMultiplier {
    // if (isLandscape.value) {
    //   return _currentHeightMultipler;
    // }

    return _currentWidthMultipler;
  }

  late double _currentWidthMultipler;

  late double _currentHeightMultipler;

  // final isLandscape = BaseStreamController(false);

  void init(
      {required double screenWidth,
      required double screenHeight,
      required BoxConstraints constraints}) {
    desginScreenHeight = screenHeight;
    designScreenWidth = screenWidth;
    _currentWidthMultipler = constraints.maxWidth / designScreenWidth;
    _currentHeightMultipler = constraints.maxHeight / desginScreenHeight;
  }

  double? getWidth(num? width) {
    if (width == null) {
      return null;
    }
    return width * _widthMultipler;
  }

  double? getHeight(num? height) {
    if (height == null) {
      return null;
    }
    return height * _heightMultipler;
  }

  EdgeInsets? paddingOnly(
      {double? left, double? right, double? top, double? bottom}) {
    // if (isLandscape.value) {
    //   return EdgeInsets.only(
    //     left: left != null ? left * _heightMultipler : 0,
    //     right: right != null ? right * _heightMultipler : 0,
    //     top: top != null ? top * _widthMultipler : 0,
    //     bottom: bottom != null ? bottom * _widthMultipler : 0,
    //   );
    // }
    return EdgeInsets.only(
      left: left != null ? left * _widthMultipler : 0,
      right: right != null ? right * _widthMultipler : 0,
      top: top != null ? top * _heightMultipler : 0,
      bottom: bottom != null ? bottom * _heightMultipler : 0,
    );
  }

  EdgeInsets? paddingAll({double? all}) {
    return EdgeInsets.all(all != null ? all * _widthMultipler : 0);
  }

  EdgeInsets? paddingSymmetric({double? horizontal, double? vertical}) {
    return EdgeInsets.symmetric(
      horizontal: horizontal != null ? horizontal * _widthMultipler : 0,
      vertical: vertical != null ? vertical * _heightMultipler : 0,
    );
  }

  double? getFontSize(num? size) => (size ?? 0) * _textMultiplier;
}
