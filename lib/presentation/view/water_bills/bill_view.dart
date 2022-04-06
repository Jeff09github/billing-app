import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maaa/data/provider/bluetooth_thermal_printer.dart';
import 'package:maaa/presentation/resources/color_manager.dart';
import 'package:maaa/presentation/resources/style_manager.dart';

import '../../../data/model/model.dart';



class BillView extends StatefulWidget {
  const BillView({Key? key, required this.bill, required this.customer})
      : super(key: key);
  final Bill bill;
  final Customer customer;

  @override
  State<BillView> createState() => _BillViewState();
}

class _BillViewState extends State<BillView> {
  final _format = NumberFormat('#,##0.00', 'en_US');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        title: const Text('Water Receipt'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              _buildText(label: 'Name: ${widget.customer.fullName}'),
              _buildText(
                  label:
                      'Date: ${DateFormat.yMd().format(widget.bill.createdAt)}'),
              _buildText(
                  label: 'Present Reading: ${widget.bill.currentReading}'),
              _buildText(
                  label: 'Previous Reading: ${widget.bill.previousReading}'),
              _buildText(label: 'CU.M: ${widget.bill.consumeCM}'),
              _buildText(
                  label: 'Amount: ₱${_format.format(widget.bill.billAmount)}'),
              _buildText(label: 'Balance: ${widget.bill.previousbalance}'),
              _buildText(
                  label:
                      'Total: ${_format.format(widget.bill.previousbalance + widget.bill.billAmount)}'),
              _buildText(
                  label: 'Due Date: ${DateFormat.yMd().format(
                widget.bill.createdAt.add(
                  const Duration(days: 3),
                ),
              )}'),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => BluetoothThermalPrinter(
                    bill: widget.bill,
                    customer: widget.customer,
                  ),
                ),
              );
            },
            child: const Text('PRINT'),
          ),
        ],
      ),
    );
  }

  Text _buildText({required String label}) {
    return Text(
      label,
      style: getRegularStyle(color: ColorManager.secondary, fontSize: 18.0),
    );
  }
}
