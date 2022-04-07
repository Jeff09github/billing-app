import 'package:flutter/material.dart';
import 'package:maaa/data/arguments/reading_history_args.dart';
import 'package:maaa/presentation/view/splash_view.dart';
import 'package:maaa/presentation/view/water_bills/bill_view.dart';
import 'package:maaa/presentation/view/water_bills/home_view.dart';
import '../view/water_bills/customer_bill_history.dart';


class Routes {
  static const String splashRoute = '/';
  static const String homeView = '/homeView';
  static const String customerReadingHistory = '/customerReadingHistory';
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
      case Routes.customerReadingHistory:
        final args = routeSettings.arguments as ReadingHistoryArgs;
        return MaterialPageRoute(
          builder: (context) => ReadingHistoryView(
            customer: args.customer,
            billType: args.billType,
          ),
        );
      case Routes.billView:
        final args = routeSettings.arguments as BillArgs;
        return MaterialPageRoute(
          builder: (context) => BillView(
            bill: args.bill,
            customer: args.customer,
          ),
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
