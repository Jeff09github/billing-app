// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';

// import '../model/model.dart';




// class BluetoothThermalPrinter extends StatefulWidget {
//   const BluetoothThermalPrinter(
//       {Key? key, required this.bill, required this.customer})
//       : super(key: key);

//   final WaterBill bill;
//   final Customer customer;

//   @override
//   State<BluetoothThermalPrinter> createState() =>
//       _BluetoothThermalPrinterState();
// }

// class _BluetoothThermalPrinterState extends State<BluetoothThermalPrinter> {
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

//   List<BluetoothDevice> _devices = [];
//   BluetoothDevice? _device;
//   bool _connected = false;
//   bool _pressed = false;

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   Future<void> initPlatformState() async {
//     List<BluetoothDevice> devices = [];

//     try {
//       devices = await bluetooth.getBondedDevices();
//     } on PlatformException catch (e) {
//       print(e.message);
//       // TODO - Error
//     }

//     bluetooth.onStateChanged().listen((state) {
//       switch (state) {
//         case BlueThermalPrinter.CONNECTED:
//           setState(() {
//             _connected = true;
//             _pressed = false;
//           });
//           break;
//         case BlueThermalPrinter.DISCONNECTED:
//           setState(() {
//             _connected = false;
//             _pressed = false;
//           });
//           break;
//         default:
//           print(state);
//           break;
//       }
//     });

//     if (!mounted) return;
//     setState(() {
//       _devices = devices;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Blue Thermal Printer'),
//       ),
//       body: SizedBox(
//         child: ListView(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   const Text(
//                     'Device:',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   DropdownButton(
//                     items: _getDeviceItems(),
//                     onChanged: (BluetoothDevice? value) =>
//                         setState(() => _device = value!),
//                     value: _device,
//                   ),
//                   RaisedButton(
//                     onPressed: _pressed
//                         ? null
//                         : _connected
//                             ? _disconnect
//                             : _connect,
//                     child: Text(_connected ? 'Disconnect' : 'Connect'),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
//               child: TextButton(
//                 onPressed: _connected ? _tesPrint : null,
//                 child: const Text('Print'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
//     List<DropdownMenuItem<BluetoothDevice>> items = [];
//     if (_devices.isEmpty) {
//       items.add(
//         const DropdownMenuItem(
//           child: Text('NONE'),
//         ),
//       );
//     } else {
//       for (var device in _devices) {
//         items.add(
//           DropdownMenuItem(
//             child: Text(device.name ?? ''),
//             value: device,
//           ),
//         );
//       }
//     }
//     return items;
//   }

//   void _connect() {
//     if (_device == null) {
//       show('No device selected.');
//     } else {
//       bluetooth.isConnected.then((isConnected) {
//         if (!isConnected!) {
//           bluetooth.connect(_device!).catchError((error) {
//             setState(() => _pressed = false);
//           });
//           setState(() => _pressed = true);
//         }
//       });
//     }
//   }

//   void _disconnect() {
//     bluetooth.disconnect();
//     setState(() => _pressed = true);
//   }

//   void _tesPrint() async {
//     final _format = NumberFormat('#,##0.00', 'en_US');
//     final _total = _format.format(widget.bill.total);
//     //SIZE
//     // 0- normal size text
//     // 1- only bold text
//     // 2- bold with medium text
//     // 3- bold with large text
//     //ALIGN
//     // 0- ESC_ALIGN_LEFT
//     // 1- ESC_ALIGN_CENTER
//     // 2- ESC_ALIGN_RIGHT
//     bluetooth.isConnected.then((isConnected) {
//       if (isConnected != null && isConnected) {
//         bluetooth.printNewLine();
//         bluetooth.printCustom('WATER RECEIPT', 3, 1);
//         bluetooth.printCustom(
//             DateFormat.yMd().format(widget.customer.dateCreated), 2, 1);
//         bluetooth.printNewLine();
//         // bluetooth.printImage(pathImage); //path of your image/logo
//         // bluetooth.printNewLine();
//         //bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
//         bluetooth.printCustom('Name: ${widget.customer.fullName}', 1, 0);
//         bluetooth.printCustom(
//             'Present Reading: ${widget.bill.currentReading}', 1, 0);
//         bluetooth.printCustom(
//             'Previous Reading ${widget.bill.previousReading}', 1, 0);
//         bluetooth.printCustom('CU.M: ${widget.bill.consumption}', 1, 0);
//         bluetooth.printCustom('Amount: $_total', 1, 0);
//         bluetooth.printCustom('Balance: ', 1, 0);
//         bluetooth.printCustom('Total: ', 1, 0);
//         bluetooth.printCustom(
//             'Due Date: ${DateFormat.yMd().format(widget.customer.dateCreated.add(const Duration(days: 3)))}',
//             1,
//             0);
//         bluetooth.printNewLine();
//         bluetooth.printCustom('_________________', 3, 1);
//         bluetooth.printCustom('Signature', 3, 1);
//         bluetooth.printQRcode("Hello : Thank You)", 200, 200, 1);
//         bluetooth.printNewLine();
//         bluetooth.printNewLine();
//         bluetooth.paperCut();
//       }
//     });
//   }

//   Future show(
//     String message, {
//     Duration duration = const Duration(seconds: 3),
//   }) async {
//     await new Future.delayed(new Duration(milliseconds: 100));
//     Scaffold.of(context).showSnackBar(
//       new SnackBar(
//         content: new Text(
//           message,
//           style: new TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         duration: duration,
//       ),
//     );
//   }
// }
