import 'package:flutter/material.dart';
import 'package:maaa/presentation/resources/color_manager.dart';

import '../resources/enum.dart';
import '../resources/route_manager.dart';

class SelectionView extends StatefulWidget {
  const SelectionView({Key? key}) : super(key: key);

  @override
  _SelectionViewState createState() => _SelectionViewState();
}

class _SelectionViewState extends State<SelectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _texttButton(
              text: 'Water Billing',
              onPressed: () => goNext(BillType.water),
            ),
            const SizedBox(
              height: 24.0,
            ),
            _texttButton(
              text: 'Electricity Billing',
              onPressed: () => goNext(BillType.water),
            )
          ],
        ),
      ),
    );
  }

  void goNext(BillType billType) {
    switch (billType) {
      case BillType.water:
        Navigator.pushNamed(context, Routes.customersWaterBills);
        break;
      case BillType.electricity:
        break;
    }
  }

  TextButton _texttButton(
      {required String text, required void Function() onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 24.0),
      ),
    );
  }
}
