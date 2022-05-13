import 'package:flutter/material.dart';

class StateFailureWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const StateFailureWidget({Key? key,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.refresh_outlined),
          ),
          Text('Loading Data Error!'),
        ],
      ),
    );
  }
}
