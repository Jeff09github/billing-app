import 'package:flutter/material.dart';

import '../resources/color_manager.dart';

class CustomerBillsView extends StatefulWidget {
  const CustomerBillsView({Key? key}) : super(key: key);

  @override
  _CustomerBillsViewState createState() => _CustomerBillsViewState();
}

class _CustomerBillsViewState extends State<CustomerBillsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
    );
  }
}
