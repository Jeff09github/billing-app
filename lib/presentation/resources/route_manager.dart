import 'package:flutter/material.dart';
import 'package:maaa/presentation/splash/splash_view.dart';


import '../customer_bills/customer_bills.dart';
import '../customer_history/customer_history.dart';
import '../selection/selection_view.dart';

class Routes {
  static const String splashRoute = '/';
  static const String selectionRoute = '/selection';
  static const String customerBills = '/customerBills';
  static const String customerHistory = '/customerHistory';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.selectionRoute:
        return MaterialPageRoute(builder: (_) => const SelectionView());
      case Routes.customerBills:
        return MaterialPageRoute(builder: (_) => const CustomerBillsView());
      case Routes.customerHistory:
        return MaterialPageRoute(builder: (_) => const CustomerHistoryView());
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
