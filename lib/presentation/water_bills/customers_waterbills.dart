import 'package:flutter/material.dart';
import 'package:maaa/presentation/resources/enum.dart';

import '../resources/color_manager.dart';

class CustomersWaterBillsView extends StatefulWidget {
  const CustomersWaterBillsView({Key? key}) : super(key: key);

  @override
  _CustomersWaterBillsViewState createState() =>
      _CustomersWaterBillsViewState();
}

class _CustomersWaterBillsViewState extends State<CustomersWaterBillsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              size: 35.0,
            ),
            onSelected: _onChoiceSelected,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Choose>>[
              _buildPopupMenuItem(
                text: "Add Customer",
                value: Choose.addCustomer,
              ),
              _buildPopupMenuItem(
                text: "Create New Bill",
                value: Choose.createNewBill,
                // onTap: () {},s
              ),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<Choose> _buildPopupMenuItem({
    required String text,
    required Choose value,
  }) {
    return PopupMenuItem(
      child: Text(text),
      value: value,
      // onTap: onTap,
    );
  }

  void _onChoiceSelected(Choose choose) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        switch (choose) {
          case Choose.addCustomer:
            return Container();
          case Choose.createNewBill:
            return Container();
        }
      },
    );
  }
}
