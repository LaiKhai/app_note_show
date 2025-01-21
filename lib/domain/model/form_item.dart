import '../../index.dart';

class FormItem {
  late final GlobalKey<FormState> formKey;
  late final FocusNode titleFocusNode;
  late final FocusNode priceFocusNode;
  late final FocusNode descriptionFocusNode;
  late final TextEditingController titleController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;
  late final DateTime startTime;
  late final DateTime endTime;

  FormItem({
    required this.formKey,
    required this.titleFocusNode,
    required this.priceFocusNode,
    required this.descriptionFocusNode,
    required this.titleController,
    required this.priceController,
    required this.descriptionController,
    required this.startTime,
    required this.endTime,
  });
}
