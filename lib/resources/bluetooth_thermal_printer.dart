import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BluetoothThermalPrinter extends StatefulWidget {
  const BluetoothThermalPrinter({Key? key}) : super(key: key);

  @override
  State<BluetoothThermalPrinter> createState() =>
      _BluetoothThermalPrinterState();
}

class _BluetoothThermalPrinterState extends State<BluetoothThermalPrinter> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  late BluetoothDevice _device;
  bool _connected = false;
  bool _pressed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException catch (e) {
      print(e.message);
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            _pressed = false;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
