import '../../../index.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _homeBloc = HomeBloc(const UnHomeState());
  final IsarServices isarServices = di.get();
  final HomePageImpl homePageImpl = di.get();
  final NetworkController networkController = di.get();
  final BottomSheetModal bottomSheetModal = di.get();
  DateTime? startDateTimeValue;
  DateTime? endDateTimeValue;
  @override
  void initState() {
    networkController.onInit();
    super.initState();
  }

  bool hidden = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Assets.images.appLauchIcon.svg(height: 60),
        backgroundColor: ColorName.white,
      ),
      body: SafeArea(
          child: HomeScreen(
        homeBloc: _homeBloc,
        callback: (bool isVisible) {
          setState(() {
            hidden = isVisible;
          });
        },
      )),
      floatingActionButton: Visibility(
          visible: hidden,
          child: FloatingActionButton(
              heroTag: "post",
              backgroundColor: ColorName.bgAppBar,
              onPressed: () {
                GoRouter.of(navigatorKey.currentContext!)
                    .pushReplacement(CalendarPage.routeName);
              },
              child: const Icon(Icons.post_add_rounded,
                  color: ColorName.colorGrey2))),
    );
  }
}
