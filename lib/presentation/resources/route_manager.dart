import 'package:flutter/material.dart';
import 'package:maaa/presentation/splash/splash_view.dart';

class Routes {
  static const String splashRoute = '/';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
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
