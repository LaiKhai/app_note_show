import 'package:intl/intl.dart';

import '../../../../index.dart';

class DateTimeLabel extends StatelessWidget {
  const DateTimeLabel({
    super.key,
    required this.listSelectTime,
  });

  final DateTime? listSelectTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: ColorName.colorSecondaryLight),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              listSelectTime!.day.toString(),
              style: const TextStyle(
                  fontSize: 45,
                  color: ColorName.white,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('MMM').format(DateTime(0, listSelectTime!.month)),
                  style: const TextStyle(
                    color: ColorName.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  listSelectTime!.year.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: ColorName.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
