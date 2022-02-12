import 'package:flutter/material.dart';
import 'package:maaa/presentation/resources/route_manager.dart';

import '../presentation/resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const MyApp instance = MyApp._internal();

  factory MyApp() => instance;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => RouteGenerator.getRoute(settings),
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
