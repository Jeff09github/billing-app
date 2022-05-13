import 'package:flutter/material.dart';
import 'package:maaa/presentation/resources/color_manager.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: ColorManager.secondary),
    );
  }
}
