

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:servitel_chip/routes/routes.dart';
import 'package:servitel_chip/src/bloc/home_bloc.dart';
import 'package:servitel_chip/src/bloc/login_bloc.dart';
import 'package:servitel_chip/src/bloc/main_menu_bloc.dart';
import 'package:servitel_chip/src/bloc/record_bloc.dart';
import 'package:servitel_chip/src/ui/home_screen.dart';
import 'package:servitel_chip/src/ui/login_screen.dart';
import 'package:servitel_chip/src/ui/main_menu_screen.dart';
import 'package:servitel_chip/src/ui/record_screen.dart';
import 'package:servitel_chip/src/utils/extensions.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'),
      ],
      title: 'Servitel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Routes.LOGIN_SCREEN,
      onGenerateRoute: (settings){

        switch (settings.name){

          case Routes.MAIN_MENU:
            return fadeTransition(
                settings: settings,
                pageBuilder: (routeContext, __, _) =>
                    Provider<MainMenuBloc>(
                      create: (_) => generateMenuBloc(routeContext),
                      dispose: (_, bloc) => bloc.dispose(),
                      child: MainMenuScreen(),
                    )
            );

            break;

          case Routes.LOGIN_SCREEN:
            return fadeTransition(
                settings: settings,
                pageBuilder: (routeContext, __, _) =>
                    Provider<LoginBloc>(
                      create: (_) => generateLoginBloc(routeContext),
                      dispose: (_, bloc) => bloc.dispose(),
                      child: LoginScreen(),
                    )
            );

            break;

          case Routes.HOME_SCREEN:
            return fadeTransition(
                settings: settings,
                pageBuilder: (routeContext, __, _) =>
                    Provider<HomeBloc>(
                      create: (_) => generateHomeBloc(routeContext),
                      dispose: (_, bloc) => bloc.dispose(),
                      child: HomeScreen(),
                    )
            );

            break;

          case Routes.RECORD_SCREEN:
            return fadeTransition(
                settings: settings,
                pageBuilder: (routeContext, __, _) =>
                    Provider<RecordBloc>(
                      create: (_) => generateRecordBloc(routeContext),
                      dispose: (_, bloc) => bloc.dispose(),
                      child: RecordScreen(),
                    )
            );

          default:
            throw Exception('Invalid route name: ${settings.name}');
        }
      },
    );
  }
}
