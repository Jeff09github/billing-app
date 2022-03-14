import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maaa/presentation/resources/enum.dart';
import 'package:maaa/resources/maaa_database.dart';

import '../../../model/customer/customer.dart';
import '../../../model/reading/reading.dart';
import '../../resources/color_manager.dart';
import '../../resources/style_manager.dart';

class ReadingHistoryView extends StatefulWidget {
  const ReadingHistoryView(
      {required this.customer, required this.billType, Key? key})
      : super(key: key);

  final Customer customer;
  final BillType billType;

  @override
  _ReadingHistoryViewState createState() => _ReadingHistoryViewState();
}

class _ReadingHistoryViewState extends State<ReadingHistoryView> {
  final _db = MaaaDatabase.instance;

  void _onCreateTap({
    required BuildContext context,
    required Customer customer,
    required Reading currentReading,
    required Reading previousReading,
  }) {
    showModalBottomSheet<void>(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure?',
                  style:
                      getBoldStyle(fontSize: 24.0, color: ColorManager.primary),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _db.createBill(
                          customer: customer,
                          currentReading: currentReading,
                          previousReading: previousReading,
                          billType: BillType.water,
                        );
                      },
                      child: const Text('OK'),
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('CANCEL'),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: FutureBuilder<List<Reading>?>(
              future: _db.getReadings(widget.customer.id!, widget.billType),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                print(snapshot.data!.length);
                return DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Date'),
                    ),
                    DataColumn(
                      label: Text('Reading'),
                    ),
                    DataColumn(
                      label: Text('Billing'),
                    ),
                  ],
                  rows: List.generate(
                    snapshot.data!.length,
                    (index) => DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            DateFormat.yMd()
                                .format(snapshot.data![index].createdAt),
                          ),
                        ),
                        DataCell(
                          Text(
                            snapshot.data![index].reading.toString(),
                          ),
                        ),
                        index == 0
                            ? const DataCell(
                                Text(
                                  '',
                                ),
                              )
                            : DataCell(
                                const Text(
                                  'Create',
                                ),
                                onTap: () {
                                  _onCreateTap(
                                    context: context,
                                    customer: widget.customer,
                                    currentReading: snapshot.data![index],
                                    previousReading: snapshot.data![index - 1],
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
