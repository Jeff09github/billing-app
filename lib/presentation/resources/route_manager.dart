import 'package:flutter/material.dart';
import 'package:maaa/presentation/splash/splash_view.dart';
import 'package:maaa/presentation/water_bills/customer_reading_history/customer_waterbill_history.dart';

import '../../model/arguments/reading_history_args.dart';
import '../selection/selection_view.dart';
import '../water_bills/customers_waterbills/customers_waterbills.dart';

class Routes {
  static const String splashRoute = '/';
  static const String selectionRoute = '/selection';
  static const String customersWaterBills = '/customersWaterBills';
  static const String customerReadingHistory = '/customerReadingHistory';
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
      case Routes.customerReadingHistory:
        final args = routeSettings.arguments as ReadingHistoryArgs;
        return MaterialPageRoute(
            builder: (context) => ReadingHistoryView(
                  customer: args.customer,
                  billType: args.billType,
                ));
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
