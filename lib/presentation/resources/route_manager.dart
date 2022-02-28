import 'package:flutter/material.dart';
import 'package:maaa/presentation/splash/splash_view.dart';

import '../water_bills/customer_waterbill_history/customer_waterbill_history.dart';
import '../selection/selection_view.dart';
import '../water_bills/customers_waterbills/customers_waterbills.dart';

class Routes {
  static const String splashRoute = '/';
  static const String selectionRoute = '/selection';
  static const String customersWaterBills = '/customersWaterBills';
  static const String customerWaterHistory = '/customerWaterHistory';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.selectionRoute:
        return MaterialPageRoute(builder: (_) => const SelectionView());
      case Routes.customersWaterBills:
        return MaterialPageRoute(
            builder: (_) => const CustomersWaterBillsView());
      case Routes.customerWaterHistory:
        return MaterialPageRoute(
            builder: (_) => const CustomerWaterBillHistoryView());
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
