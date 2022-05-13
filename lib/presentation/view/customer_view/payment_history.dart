import 'package:flutter/material.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({ Key? key }) : super(key: key);

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build;
    return Center(child: Text('Payment History'));
  }

  @override
  bool get wantKeepAlive => true;
}