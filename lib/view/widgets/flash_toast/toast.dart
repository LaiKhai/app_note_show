import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../res/responsive/reponsive_extension.dart';
import 'flash.dart';

void showSimpleToast(String content) {
  showFlash(
    context: navigatorKey.currentContext!,
    duration: const Duration(seconds: 2),

    // persistent: false,
    builder: (_, controller) {
      return Flash(
        borderRadius: BorderRadius.circular(8),
        margin: padding(all: 24),
        controller: controller,
        backgroundColor: Colors.red,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(2.0, 2.0),
            blurRadius: 4.0,
          ),
        ],
        barrierDismissible: true,
        behavior: FlashBehavior.floating,
        position: FlashPosition.bottom,
        child: Container(
          // width: width(160),
          // height: height(45),
          padding: padding(horizontal: 38, vertical: 13),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      );
    },
  );
}
