import '../../pages/create_show_detail/index.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.bodyText,
    required this.specialText,
    required this.acceptText,
    required this.denyText,
    this.onAccept,
    this.onDeny,
  });
  final double? height = AppSize.s120;
  final double? width = AppSize.s120;
  final String bodyText;
  final String specialText;
  final String acceptText;
  final String denyText;
  final VoidCallback? onAccept;
  final VoidCallback? onDeny;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          return SizedBox(
            height: height,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: AppSize.s10),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(text: bodyText),
                          TextSpan(
                              text: specialText,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: ColorName.bgAppBar,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s8))),
                          onPressed: onAccept,
                          child: Text(acceptText)),
                    ),
                    const SizedBox(
                      width: AppSize.s10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: onDeny,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorName.bgAppBar,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s8))),
                          child: Text(
                            denyText,
                            style: const TextStyle(color: ColorName.white),
                          )),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
