import 'package:animated_digit/animated_digit.dart';

import '../../../../index.dart';

class StatisticalWidget extends StatelessWidget {
  final String? title;
  final double? fontSize;
  final AnimatedDigitController controller;
  const StatisticalWidget({
    super.key,
    this.title,
    required this.controller,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 80,
            decoration: BoxDecoration(
                color: ColorName.colorGrey3,
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedDigitWidget(
                    autoSize: false,
                    controller: controller,
                    textStyle: DefaultTextStyle.of(context).style.copyWith(
                        color: ColorName.black,
                        fontSize: fontSize ?? FontSize.s14,
                        fontWeight: FontWeight.bold),
                    enableSeparator: true,
                  ),
                  Text(
                    title ?? AppLocalizations.of(context)!.totalShowPerMonth,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: ColorName.colorGrey2, fontSize: 10),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
