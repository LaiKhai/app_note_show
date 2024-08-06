import 'package:flutter/material.dart';
import 'package:flutter_base_project/core/di.dart';
import 'package:flutter_base_project/core/gen/colors.gen.dart';
import 'package:flutter_base_project/core/gen/fonts.gen.dart';
import 'package:flutter_base_project/core/router/go_route_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();

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
          theme: ThemeData(
              fontFamily: FontFamily.dMSans,
              appBarTheme:
                  const AppBarTheme(backgroundColor: ColorName.bgAppBar),
              scaffoldBackgroundColor: ColorName.bgLight,
              textSelectionTheme:
                  const TextSelectionThemeData(cursorColor: Colors.red)),
        );
      },
    );
  }
}
