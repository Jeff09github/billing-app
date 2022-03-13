import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maaa/presentation/resources/enum.dart';
import 'package:maaa/resources/maaa_database.dart';

import '../../../model/customer/customer.dart';
import '../../../model/reading/reading.dart';
import '../../resources/color_manager.dart';

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
                                  'Add',
                                ),
                                onTap: () {
                                  _db.createBill(
                                    customer: widget.customer,
                                    currentReading: snapshot.data![index],
                                    previousReading: snapshot.data![index - 1],
                                    billType: BillType.water,
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
