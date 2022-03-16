import 'package:flutter/material.dart';
import 'package:maaa/presentation/resources/color_manager.dart';

class BillView extends StatefulWidget {
  const BillView({Key? key}) : super(key: key);

  @override
  State<BillView> createState() => _BillViewState();
}

class _BillViewState extends State<BillView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(),
    );
  }
}
