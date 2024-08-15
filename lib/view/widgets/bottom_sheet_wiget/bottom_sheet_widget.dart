import 'package:injectable/injectable.dart';

import '../../pages/create_show_detail/index.dart';

@singleton
class BottomSheetModal {
  showBottomSheet(BuildContext context, Widget widget,
      {EdgeInsetsDirectional? padding}) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: padding ?? const EdgeInsetsDirectional.all(AppSize.s8),
          child: widget,
        );
      },
    );
  }
}
