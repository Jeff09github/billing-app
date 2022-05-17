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
    // bluetoothConnectivityStreamSubs =
    //     bluetoothThermalPrinter.onStateChange.listen(
    //   (event) {
    //     switch (event) {
    //       case BlueThermalPrinter.CONNECTED:
    //         setConnection(true);
    //         break;
    //       case BlueThermalPrinter.DISCONNECTED:
    //         setConnection(false);
    //         break;
    //       default:
    //         print(state);
    //         break;
    //     }
    //   },
    // );
  }

  void loadData(WaterBill waterBill) async {
    final customer = customerDetailsBloc.getCustomerDetails;
    final connected = await bluetoothThermalPrinter.isConnected();
    if (connected != null && connected) {
      await bluetoothThermalPrinter.disconnect();
    }
    try {
      emit(
        BillViewSuccess(
          waterBill: waterBill,
          customer: customer,
          devices: const [],
          device: null,
          enablePrint: false,
        ),
      );
    } catch (_) {
      emit(BillViewFailure(waterBill: waterBill, errorMsg: ''));
    }
  }

  // void update({
  //   WaterBill? waterBill,
  //   Customer? customer,
  //   List<BluetoothDevice>? devices,
  //   BluetoothDevice? device,
  //   bool? deviceConnected,}
  // ) {
  //   final state = this.state;

  //   if (state is BillViewSuccess) {
  //     emit(BillViewLoading());
  //     try {
  //       emit(
  //         BillViewSuccess(
  //           waterBill: waterBill ?? state.waterBill,
  //           customer:customer ?? state.customer,
  //           devices:devices ?? state.devices,
  //           device: device ?? state.device,
  //           connected:deviceConnected ?? state.connected,
  //         ),
  //       );
  //     } catch (e) {
  //       print(e);
  //       emit(
  //         BillViewFailure(waterBill: state.waterBill, errorMsg: ''),
  //       );
  //     }
  //   }
  // }

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
            enablePrint: connected,
          ),
        );
      } catch (e) {
        emit(
          BillViewFailure(waterBill: state.waterBill, errorMsg: ''),
        );
      }
    }
  }

  Future<void> connect() async {
    final state = this.state;
    if (state is BillViewSuccess) {
      emit(BillViewLoading());
      try {
        final result =
            await bluetoothThermalPrinter.connectDevice(state.device!);
        state.device!.connected = result;
        emit(
          BillViewSuccess(
            waterBill: state.waterBill,
            customer: state.customer,
            devices: state.devices,
            device: state.device,
            enablePrint: result,
          ),
        );
      } catch (e) {
        emit(
          BillViewFailure(waterBill: state.waterBill, errorMsg: ''),
        );
      }
    }
  }

  Future<void> disconnect() async {
    final state = this.state;
    if (state is BillViewSuccess) {
      emit(BillViewLoading());
      try {
        await bluetoothThermalPrinter.disconnect();
        state.device!.connected = false;
        emit(
          BillViewSuccess(
            waterBill: state.waterBill,
            customer: state.customer,
            devices: state.devices,
            device: state.device,
            enablePrint: false,
          ),
        );
      } catch (e) {
        emit(
          BillViewFailure(waterBill: state.waterBill, errorMsg: ''),
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
            enablePrint: state.enablePrint,
          ),
        );
      } catch (e) {
        emit(
          BillViewFailure(
              waterBill: state.waterBill,
              errorMsg: 'Check if the Bluetooth is On'),
        );
      }
    }
  }

  void print() async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    final state = this.state;
    if (state is BillViewSuccess) {
      bluetoothThermalPrinter.blueThermalPrinter.printNewLine();
      bluetoothThermalPrinter.blueThermalPrinter
          .printCustom("WATER RECEIPT", 2, 1);
      bluetoothThermalPrinter.blueThermalPrinter.printNewLine();
      bluetoothThermalPrinter.blueThermalPrinter
          .printCustom(state.customer.fullName, 1, 0);
      bluetoothThermalPrinter.blueThermalPrinter
          .printCustom("================================", 1, 0);
      bluetoothThermalPrinter.blueThermalPrinter.printLeftRight(
          'Bill Date', state.waterBill.dateCreated.toString(), 0);
      bluetoothThermalPrinter.blueThermalPrinter
          .printLeftRight('Prev. Reading', state.waterBill.previousReading, 0);
      bluetoothThermalPrinter.blueThermalPrinter
          .printLeftRight('Pres. Reading', state.waterBill.currentReading, 0);
      bluetoothThermalPrinter.blueThermalPrinter.printLeftRight(
          'Consumption', state.waterBill.consumption.toString(), 0);
      bluetoothThermalPrinter.blueThermalPrinter
          .printCustom("================================", 1, 0);
      bluetoothThermalPrinter.blueThermalPrinter.printLeftRight(
          'Current Charge', state.waterBill.charges.toString(), 0);
      bluetoothThermalPrinter.blueThermalPrinter
          .printLeftRight('Balance',state.waterBill.balance.toString(), 0);
      bluetoothThermalPrinter.blueThermalPrinter.printLeftRight(
          'Total Amount',state.waterBill.total.toString(), 1);
      bluetoothThermalPrinter.blueThermalPrinter
          .printCustom("================================", 1, 0);
      bluetoothThermalPrinter.blueThermalPrinter
          .printLeftRight('Due Date',state.waterBill.dueDate.toString(), 1);
      bluetoothThermalPrinter.blueThermalPrinter.paperCut();
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
            enablePrint: state.enablePrint,
          ),
        );
      } catch (e) {
        emit(
          BillViewFailure(waterBill: state.waterBill, errorMsg: ''),
        );
      }
    }
  }

  Future<bool?> get connected async =>
      await bluetoothThermalPrinter.isConnected();
}
