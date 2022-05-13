import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class BluetoothThermalPrinter {
  BlueThermalPrinter bluetoothThermalPrinter = BlueThermalPrinter.instance;

  Future<List<BluetoothDevice>> getDevices() async {
    return await bluetoothThermalPrinter.getBondedDevices();
  }

  Stream<int?> get onStateChange => bluetoothThermalPrinter.onStateChanged();

  
}
