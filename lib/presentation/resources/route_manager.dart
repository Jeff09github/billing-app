import 'package:flutter/material.dart';
import 'package:maaa/presentation/splash/splash_view.dart';

import '../selection/selection_view.dart';

class Routes {
  static const String splashRoute = '/';
  static const String selectionRoute = '/selection';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.selectionRoute:
        return MaterialPageRoute(builder: (_) => const SelectionView());

      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('No Route Found'),
        ),
      ),
    );
  }
}
