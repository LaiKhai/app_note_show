import '../../core/gen/index.dart';
import '../pages/create_show_detail/index.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({
    super.key,
    required this.bodyText,
    this.image,
    required this.onPressed,
    required this.onPressedText,
  });

  final String bodyText;
  final Image? image;
  final VoidCallback onPressed;
  final String onPressedText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Assets.images.emptyPage.image(),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Text(
                bodyText,
                textAlign: TextAlign.center,
                style: const TextStyle(color: ColorName.colorGrey2),
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorName.bgAppBar,
              ),
              child: Text(
                onPressedText,
                style: const TextStyle(color: ColorName.colorGrey2),
              ),
            ),
          ),
        )
      ],
    );
  }
}
