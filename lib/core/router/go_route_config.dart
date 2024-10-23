import 'package:Noteshow/view/pages/create_show_detail/index.dart';

import '../../main.dart';
import '../../view/pages/calendar/index.dart';
import '../../view/pages/home/index.dart';
import '../../view/pages/login/index.dart';
import '../../view/pages/profile/profile/index.dart';

class GoRouteConfig {
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: LoginPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: CreateShowDetailPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          Map<String, dynamic> extra = state.extra as Map<String, dynamic>;

          return CreateShowDetailPage(controller: extra['controller']);
        },
      ),
      GoRoute(
        path: CalendarPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const CalendarPage();
        },
      ),
      GoRoute(
        path: HomePage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: ProfilePage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfilePage();
        },
      ),
    ],
  );
}
