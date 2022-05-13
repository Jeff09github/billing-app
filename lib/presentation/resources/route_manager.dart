import 'package:flutter/material.dart';
import '../view/bill_view.dart';
import '../view/view.dart';

class Routes {
  static const String splashRoute = '/';
  static const String homeView = '/homeView';
  static const String customerView = '/customerView';
  static const String billView = '/billView';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.homeView:
        return MaterialPageRoute(
          builder: (_) => const HomeView(),
        );
      case Routes.customerView:
        return MaterialPageRoute(
          builder: (context) => const CustomerView(),
        );
      case Routes.billView:
        // final args = routeSettings.arguments as BillArgs;
        return MaterialPageRoute(
          builder: (context) => const BillView(),
        );
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
