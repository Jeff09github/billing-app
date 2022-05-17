import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maaa/presentation/resources/color_manager.dart';
import 'package:maaa/presentation/resources/style_manager.dart';
import 'package:maaa/presentation/widgets/state_failure.dart';

import '../../logic/cubit/bill_view/bill_view_cubit.dart';
import '../widgets/custom_progressindicator.dart';

class BillView extends StatefulWidget {
  const BillView({Key? key}) : super(key: key);

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
      body: BlocBuilder<BillViewCubit, BillViewState>(
        builder: (context, state) {
          if (state is BillViewLoading) {
            return const CustomProgressIndicator();
          } else if (state is BillViewSuccess) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    _buildText(label: 'Full Name: ${state.customer.fullName}'),
                    _buildText(
                        label:
                            'Date Created: ${DateFormat.yMd().format(state.waterBill.dateCreated)}'),
                    _buildText(
                        label:
                            'Present Reading: ${state.waterBill.currentReading}'),
                    _buildText(
                        label:
                            'Previous Reading: ${state.waterBill.previousReading}'),
                    _buildText(
                        label:
                            'Actual Consumption: ${state.waterBill.consumption}'),
                    _buildText(
                        label:
                            'Current Charges: ₱${_format.format(state.waterBill.charges)}'),
                    _buildText(
                        label:
                            'Balance from Previous Bill: ${state.waterBill.balance}'),
                    _buildText(
                        label:
                            'Total Amount Due: ${_format.format(state.waterBill.total)}'),
                    _buildText(
                        label: 'Due Date: ${DateFormat.yMd().format(
                      state.waterBill.dateCreated.add(
                        const Duration(days: 3),
                      ),
                    )}'),
                  ],
                ),
                Column(
                  children: [
                    const Text('Note: Bluetooth must be On!'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DropdownButton<BluetoothDevice>(
                          dropdownColor: ColorManager.primary,
                          items: _getDeviceItems(state.devices),
                          value: state.device,
                          onChanged: (value) {
                            if (value == null) {
                              final snackBar = SnackBar(
                                content: const Text('No Device Found!'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              context
                                  .read<BillViewCubit>()
                                  .selectBluetoothDevice(value);
                            }
                          },
                        ),
                        if (state.device != null)
                          TextButton(
                            onPressed: () {
                              if (state.device!.connected) {
                                context.read<BillViewCubit>().disconnect();
                              } else {
                                context.read<BillViewCubit>().connect();
                              }
                            },
                            child: Text(state.device!.connected
                                ? 'Disconnect'
                                : 'Connect'),
                          ),
                        _getGetDeviceOrPrintButton(state),
                      ],
                    ),
                  ],
                ),
              ],
            );
          } else {
            return StateFailureWidget(
              onPressed: () {
                context
                    .read<BillViewCubit>()
                    .loadData((state as BillViewFailure).waterBill);
              },
            );
          }
        },
      ),
    );
  }

  TextButton _getGetDeviceOrPrintButton(BillViewSuccess state) {
    return TextButton(
      onPressed: (state.enablePrint)
          ? () {
              context.read<BillViewCubit>().print();
            }
          : () => context.read<BillViewCubit>().getBluetoothdevices(),
      child: Text(state.enablePrint ? 'PRINT' : 'GET DEVICES'),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems(
      List<BluetoothDevice> devices) {
    List<DropdownMenuItem<BluetoothDevice>> _items = [];
    if (devices.isEmpty) {
      _items.add(
        const DropdownMenuItem<BluetoothDevice>(
          child: Text(
            'None',
          ),
        ),
      );
    } else {
      for (var element in devices) {
        _items.add(
          DropdownMenuItem<BluetoothDevice>(
            child: Text(
              '${element.name} : ${element.connected ? 'Connected' : 'Disconnected'}',
              style: TextStyle(color: ColorManager.secondary),
            ),
            value: element,
          ),
        );
      }
    }
    return _items;
  }

  Text _buildText({required String label}) {
    return Text(
      label,
      style: getRegularStyle(color: ColorManager.secondary, fontSize: 18.0),
    );
  }
}
