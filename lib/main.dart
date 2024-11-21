import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/di.dart';
import 'core/gen/colors.gen.dart';
import 'core/gen/fonts.gen.dart';
import 'core/router/go_route_config.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

enum NotesEnum { ALL, PAID, UNPAID, OVERDUE }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();
  configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: GoRouteConfig.router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: EasyLoading.init(),
          theme: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: ColorName.bgAppBar,
              ),
              fontFamily: FontFamily.dMSans,
              appBarTheme:
                  const AppBarTheme(backgroundColor: ColorName.bgAppBar),
              textSelectionTheme:
                  const TextSelectionThemeData(cursorColor: Colors.red)),
        );
      },
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
