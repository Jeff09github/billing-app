import 'package:flutter/material.dart';
import 'package:maaa/presentation/resources/color_manager.dart';

import 'package:maaa/presentation/view/customer_view/billing_history.dart';
import 'package:maaa/presentation/view/customer_view/customer_details.dart';
import 'package:maaa/presentation/view/customer_view/payment_history.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({Key? key}) : super(key: key);

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      selectedIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        // centerTitle: true,
        // title: Text(
        //   'Customer View',
        //   style: getBoldStyle(color: Colors.white, fontSize: 36.0),
        // ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Tab>[
            Tab(
              child: Text('Customer Details'),
            ),
            Tab(
              child: Text('Billing History'),
            ),
            Tab(
              child: Text('Payment History'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          CustomerDetails(),
          BillingHistory(),
          PaymentHistory(),
        ],
      ),
    );
  }
}
