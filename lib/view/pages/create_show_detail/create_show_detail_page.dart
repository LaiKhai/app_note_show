import 'package:Noteshow/view/pages/create_show_detail/index.dart';

class CreateShowDetailPage extends StatefulWidget {
  static const String routeName = '/createShowDetail';
  final DateRangePickerController controller;
  const CreateShowDetailPage({super.key, required this.controller});

  @override
  CreateShowDetailPageState createState() => CreateShowDetailPageState();
}

class CreateShowDetailPageState extends State<CreateShowDetailPage> {
  final _createShowDetailBloc =
      CreateShowDetailBloc(const UnCreateShowDetailState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorName.colorGrey3,
      ),
      backgroundColor: ColorName.colorGrey3,
      body: CreateShowDetailScreen(
        controller: widget.controller,
        createShowDetailBloc: _createShowDetailBloc,
      ),
    );
  }
}
