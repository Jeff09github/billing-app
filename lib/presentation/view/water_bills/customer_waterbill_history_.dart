// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:maaa/data/arguments/reading_history_args.dart';
// import 'package:maaa/data/provider/local_database.dart';
// import 'package:maaa/presentation/resources/color_manager.dart';
// import 'package:maaa/presentation/resources/enum.dart';
// import 'package:maaa/presentation/resources/route_manager.dart';
// import 'package:maaa/presentation/resources/style_manager.dart';

// import '../../../data/model/model.dart';




// class ReadingHistoryView extends StatefulWidget {
//   const ReadingHistoryView(
//       {required this.customer, required this.billType, Key? key})
//       : super(key: key);

//   final Customer customer;
//   final BillType billType;

//   @override
//   _ReadingHistoryViewState createState() => _ReadingHistoryViewState();
// }

// class _ReadingHistoryViewState extends State<ReadingHistoryView> {
//   final _db = MaaaDatabase.instance;

//   void _onCreateTap({
//     required BuildContext context,
//     required Customer customer,
//     required Reading currentReading,
//     required Reading previousReading,
//   }) {
//     showModalBottomSheet<void>(
//       isDismissible: false,
//       isScrollControlled: true,
//       context: context,
//       clipBehavior: Clip.hardEdge,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: MediaQuery.of(context).viewInsets,
//           child: Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Are you sure?',
//                   style:
//                       getBoldStyle(fontSize: 24.0, color: ColorManager.primary),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () async {
//                         await _db.createBill(
//                           customer: customer,
//                           currentReading: currentReading,
//                           previousReading: previousReading,
//                           billType: BillType.water,
//                         );
//                         setState(() {});
//                         Navigator.pop(context);
//                       },
//                       child: const Text('OK'),
//                     ),
//                     const SizedBox(
//                       width: 12.0,
//                     ),
//                     OutlinedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text('CANCEL'),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorManager.primary,
//       appBar: AppBar(
//         title: Text(
//             '${widget.customer.fullName} Balance: ${widget.customer.toPay} '),
//       ),
//       body: SingleChildScrollView(
//         child: Align(
//           alignment: Alignment.topCenter,
//           child: FutureBuilder<List<Reading>?>(
//               future: _db.getReadings(widget.customer.id!, widget.billType),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(color: Colors.white),
//                   );
//                 }
//                 return DataTable(
//                   columns: <DataColumn>[
//                     _buildDataColumn(label: 'Date'),
//                     _buildDataColumn(label: 'Reading'),
//                     _buildDataColumn(label: 'Billing'),
//                   ],
//                   rows: List.generate(
//                     snapshot.data!.length,
//                     (index) => DataRow(
//                       cells: <DataCell>[
//                         _buildDataCellText(
//                           text: DateFormat.yMd()
//                               .format(snapshot.data![index].createdAt),
//                         ),
//                         _buildDataCellText(
//                           text: snapshot.data![index].reading.toString(),
//                         ),
//                         index == 0
//                             ? _buildDataCellText(text: '')
//                             : DataCell(
//                                 FutureBuilder<Bill?>(
//                                   future: _db.getBill(
//                                       readingId: snapshot.data![index].id!),
//                                   builder: (context, billSnapshot) {
//                                     return billSnapshot.connectionState ==
//                                             ConnectionState.waiting
//                                         ? const CircularProgressIndicator()
//                                         : TextButton(
//                                             onPressed: billSnapshot.data == null
//                                                 ? () {
//                                                     _onCreateTap(
//                                                       context: context,
//                                                       customer: widget.customer,
//                                                       currentReading:
//                                                           snapshot.data![index],
//                                                       previousReading: snapshot
//                                                           .data![index - 1],
//                                                     );
//                                                   }
//                                                 : () {
//                                                     Navigator.pushNamed(
//                                                       context,
//                                                       Routes.billView,
//                                                       arguments: BillArgs(
//                                                         bill:
//                                                             billSnapshot.data!,
//                                                         customer:
//                                                             widget.customer,
//                                                       ),
//                                                     );
//                                                   },
//                                             child: Text(
//                                               billSnapshot.data == null
//                                                   ? 'Create'
//                                                   : 'View',
//                                               style: getRegularStyle(
//                                                   fontSize: 18.0,
//                                                   color: ColorManager.primary),
//                                             ),
//                                           );
//                                   },
//                                 ),
//                               ),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // showModalBottomSheet<void>(
//           //   context: context,
//           //   builder: (BuildContext context) {
//           //     return SingleForm(
//           //       label: 'Enter ${widget.customer.fullName} payment amount',
//           //       keyboardInputType: TextInputType.number,
//           //       validation: Validation().amountValidation,
//           //       success: (value) =>
//           //           postPayment(amount: value, customer: widget.customer),
//           //     );
//           //   },
//           // );
//         },
//         child: Icon(
//           Icons.payment,
//           color: ColorManager.primary,
//         ),
//         backgroundColor: ColorManager.secondary,
//       ),
//     );
//   }

//   DataColumn _buildDataColumn({required String label}) {
//     return DataColumn(
//       label: Text(
//         label,
//         style: getBoldStyle(color: ColorManager.secondary, fontSize: 24.0),
//       ),
//     );
//   }

//   DataCell _buildDataCellText({required String text}) {
//     return DataCell(
//       Text(
//         text,
//         style: getRegularStyle(color: ColorManager.secondary, fontSize: 18.0),
//       ),
//     );
//   }

//   Future<bool> postPayment(
//       {required String amount, required Customer customer}) async {
//     final _result = await _db.postPayment(amount: amount, customer: customer);
//     return _result != null ? true : false;
//   }
// }
