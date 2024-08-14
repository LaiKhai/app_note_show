import 'package:Noteshow/core/network/network_controller.dart';
import 'package:Noteshow/view/pages/calendar/calendar_page.dart';
import 'package:Noteshow/view/pages/create_show_detail/index.dart';
import 'package:go_router/go_router.dart';

import '../../../main.dart';
import 'index.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _homeBloc = HomeBloc(const UnHomeState());
  final NetworkController networkController = di.get();
  @override
  void initState() {
    networkController.onInit();
    super.initState();
  }

  bool hidden = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          backgroundColor: ColorName.bgAppBar,
          onPressed: () {
            GoRouter.of(navigatorKey.currentContext!)
                .pushReplacement(CalendarPage.routeName);
          },
          child: const Icon(Icons.post_add_rounded),
        ),
      ),
    );
  }
}
