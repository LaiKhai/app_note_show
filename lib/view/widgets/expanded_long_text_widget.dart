import 'package:flutter/widgets.dart';

import '../pages/create_show_detail/index.dart';

class ExpandedLongTextWidget extends StatefulWidget {
  final String text;
  const ExpandedLongTextWidget({super.key, required this.text});

  @override
  State<ExpandedLongTextWidget> createState() => _ExpandedLongTextWidgetState();
}

class _ExpandedLongTextWidgetState extends State<ExpandedLongTextWidget> {
  late String firstHaft;
  late String secondHaft;
  bool flag = true;
  @override
  void initState() {
    super.initState();
    if (widget.text.length > 150) {
      firstHaft = "${widget.text.substring(0, 150)}...";
      secondHaft = widget.text.substring(151, widget.text.length);
    } else {
      firstHaft = widget.text;
      secondHaft = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          flag = !flag;
        });
      },
      child: Container(
          child: secondHaft == ""
              ? Text(
                  widget.text,
                  style: const TextStyle(
                    color: ColorName.colorGrey2,
                    fontSize: AppSize.s14,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flag ? firstHaft : widget.text,
                      style: const TextStyle(
                        color: ColorName.colorGrey2,
                        fontSize: AppSize.s14,
                      ),
                    )
                  ],
                )),
    );
  }
}
