import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class BluetoothThermalPrinter {
  final BlueThermalPrinter _bluetoothThermalPrinter = BlueThermalPrinter.instance;

  Future<List<BluetoothDevice>> getDevices() async {
    return await _bluetoothThermalPrinter.getBondedDevices();
  }

  Future<bool> connectDevice(BluetoothDevice device) async {
    return await _bluetoothThermalPrinter.connect(device);
  }

  Future<void> disconnect() async {
    await _bluetoothThermalPrinter.disconnect();
  }

  Future<bool?> isAvailable() async {
    return await _bluetoothThermalPrinter.isAvailable;
  }

  Future<bool?> isConnected() async {
    return await _bluetoothThermalPrinter.isConnected;
  }

  Future<bool?> isDeviceConnected(BluetoothDevice device) async {
    return await _bluetoothThermalPrinter.isDeviceConnected(device);
  }

 

  BlueThermalPrinter get blueThermalPrinter => _bluetoothThermalPrinter;

  Stream<int?> get onStateChange => _bluetoothThermalPrinter.onStateChanged();
}
