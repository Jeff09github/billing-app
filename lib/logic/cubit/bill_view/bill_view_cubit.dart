import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:equatable/equatable.dart';
import 'package:maaa/data/model/model.dart';
import 'package:maaa/logic/bloc/bloc.dart';

import '../../../data/provider/bluetooth_therman_printer.dart';

part 'bill_view_state.dart';

class BillViewCubit extends Cubit<BillViewState> {
  final CustomerDetailsBloc customerDetailsBloc;
  final BluetoothThermalPrinter bluetoothThermalPrinter;
  late StreamSubscription bluetoothConnectivityStreamSubs;

  BillViewCubit(
      {required this.customerDetailsBloc,
      required this.bluetoothThermalPrinter})
      : super(BillViewLoading()) {
    bluetoothConnectivityStreamSubs =
        bluetoothThermalPrinter.onStateChange.listen(
      (event) {
        switch (event) {
          case BlueThermalPrinter.CONNECTED:
            setConnection(true);
            break;
          case BlueThermalPrinter.DISCONNECTED:
            setConnection(false);
            break;
          default:
            print(state);
            break;
        }
      },
    );
  }

  void loadData(WaterBill waterBill) async {
    final customer = customerDetailsBloc.getCustomerDetails;
    try {
      emit(
        BillViewSuccess(
            waterBill: waterBill,
            customer: customer,
            devices: [],
            device: null,
            connected: false),
      );
    } catch (_) {
      emit(BillViewFailure(waterBill: waterBill));
    }
  }

  void setConnection(bool connected) {
    final state = this.state;
    if (state is BillViewSuccess) {
      emit(BillViewLoading());
      try {
        emit(
          BillViewSuccess(
            waterBill: state.waterBill,
            customer: state.customer,
            devices: state.devices,
            device: null,
            connected: connected,
          ),
        );
      } catch (e) {
        print(e);
        emit(
          BillViewFailure(waterBill: state.waterBill),
        );
      }
    }
  }

  void getBluetoothdevices() async {
    final state = this.state;
    if (state is BillViewSuccess) {
      emit(BillViewLoading());
      try {
        final devices = await bluetoothThermalPrinter.getDevices();

        emit(
          BillViewSuccess(
              waterBill: state.waterBill,
              customer: state.customer,
              devices: devices,
              device: null,
              connected: state.connected),
        );
      } catch (e) {
        print(e);
        emit(
          BillViewFailure(waterBill: state.waterBill),
        );
      }
    }
  }

  void selectBluetoothDevice(BluetoothDevice device) {
    final state = this.state;
    if (state is BillViewSuccess) {
      emit(BillViewLoading());
      try {
        emit(
          BillViewSuccess(
              waterBill: state.waterBill,
              customer: state.customer,
              devices: state.devices,
              device: device,
              connected: state.connected),
        );
      } catch (e) {
        emit(
          BillViewFailure(waterBill: state.waterBill),
        );
      }
    }
  }

  bool get connected => (state as BillViewSuccess).connected;
}
