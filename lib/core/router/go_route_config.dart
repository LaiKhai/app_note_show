import 'package:flutter/material.dart';
import 'package:flutter_base_project/view/pages/calendar/index.dart';
import 'package:flutter_base_project/view/pages/home/home_page.dart';
import 'package:flutter_base_project/view/pages/home/home_screen.dart';
import 'package:flutter_base_project/view/pages/login/index.dart';
import 'package:go_router/go_router.dart';

class GoRouteConfig {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const CalendarPage();
        },
      ),
      GoRoute(
        path: LoginPage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: HomePage.routeName,
        builder: (BuildContext context, GoRouterState state) {
          return HomePage();
        },
      ),
    ],
  );
}
