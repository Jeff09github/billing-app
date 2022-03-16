import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maaa/model/arguments/reading_history_args.dart';
import 'package:maaa/model/reading/reading.dart';
import 'package:maaa/presentation/resources/enum.dart';
import 'package:maaa/resources/maaa_database.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/customer/customer.dart';
import '../../resources/color_manager.dart';
import '../../resources/route_manager.dart';
import '../../resources/style_manager.dart';
import 'bottom_sheet_widget.dart';

enum FormType { addCustomer, addReading, createBill }

class CustomersWaterBillsView extends StatefulWidget {
  const CustomersWaterBillsView({Key? key}) : super(key: key);

  @override
  _CustomersWaterBillsViewState createState() =>
      _CustomersWaterBillsViewState();
}

class _CustomersWaterBillsViewState extends State<CustomersWaterBillsView> {
  late MaaaDatabase _instance;

  @override
  void initState() {
    super.initState();
  }

  Future<Database?> loadDatabase() async {
    _instance = MaaaDatabase.instance;
    await Future.delayed(const Duration(milliseconds: 1000));
    return await _instance.database;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              size: 35.0,
            ),
            onSelected: (Choose value) =>
                _onChoiceSelected(choose: value, context: context),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Choose>>[
              _buildPopupMenuItem(
                text: "Add Customer",
                value: Choose.addCustomer,
              ),
              _buildPopupMenuItem(
                text: "Create New Bill",
                value: Choose.createBills,
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<Database?>(
        future: loadDatabase(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))
              //check database
              : !snapshot.hasData
                  ? Container()
                  : FutureBuilder<List<Customer>?>(
                      future: getAllCustomer(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : (snapshot.data != null &&
                                    snapshot.data!.isNotEmpty)
                                ? SingleChildScrollView(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: DataTable(
                                        headingTextStyle: getBoldStyle(
                                            color: Colors.white,
                                            fontSize: 18.0),
                                        dataTextStyle: getRegularStyle(
                                            color: Colors.white,
                                            fontSize: 14.0),
                                        dividerThickness: 3.0,
                                        border: TableBorder.all(
                                            color: Colors.white),
                                        columnSpacing: 0.0,
                                        horizontalMargin: 0.0,
                                        columns: <DataColumn>[
                                          _buildDataColumn(label: 'Customer'),
                                          _buildDataColumn(
                                              label: 'Previous Reading'),
                                          _buildDataColumn(
                                              label: 'Current Reading'),
                                          _buildDataColumn(label: 'New'),
                                        ],
                                        rows: List<DataRow>.generate(
                                          snapshot.data!.length,
                                          (index) {
                                            return DataRow(
                                              cells: <DataCell>[
                                                DataCell(
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          Routes
                                                              .customerReadingHistory,
                                                          arguments:
                                                              ReadingHistoryArgs(
                                                                  snapshot.data![
                                                                      index],
                                                                  BillType
                                                                      .water),
                                                        );
                                                      },
                                                      child: Text(
                                                        snapshot.data![index]
                                                            .fullName,
                                                        style: getRegularStyle(
                                                            color: ColorManager
                                                                .primary),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  FutureBuilder<List<Reading>?>(
                                                    future: _instance
                                                        .getLastTwoReading(
                                                            snapshot
                                                                .data![index]
                                                                .id!,
                                                            BillType.water),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const CircularProgressIndicator();
                                                      }
                                                      return snapshot.data!
                                                                  .length <
                                                              2
                                                          ? const Text('')
                                                          : Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                '${snapshot.data![1].reading.toString()} - ${DateFormat.yMd().format(snapshot.data![1].createdAt)}',
                                                              ),
                                                            );
                                                    },
                                                  ),
                                                ),
                                                DataCell(
                                                  FutureBuilder<List<Reading>?>(
                                                    future: _instance
                                                        .getLastTwoReading(
                                                            snapshot
                                                                .data![index]
                                                                .id!,
                                                            BillType.water),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const CircularProgressIndicator();
                                                      }
                                                      return snapshot
                                                              .data!.isEmpty
                                                          ? const Text('')
                                                          : Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                '${snapshot.data![0].reading.toString()} - ${DateFormat.yMd().format(snapshot.data![0].createdAt)}',
                                                              ),
                                                            );
                                                    },
                                                  ),
                                                ),
                                                DataCell(
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        _onChoiceSelected(
                                                            choose: Choose
                                                                .addReading,
                                                            context: context,
                                                            customer: snapshot
                                                                .data![index]);
                                                      },
                                                      child: Text(
                                                        'CREATE',
                                                        style: getRegularStyle(
                                                          color: ColorManager
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      'No customer data.',
                                      style: getBoldStyle(
                                        color: Colors.white,
                                        fontSize: 36.0,
                                      ),
                                    ),
                                  );
                      },
                    );
        },
      ),
    );
  }

  PopupMenuItem<Choose> _buildPopupMenuItem({
    required String text,
    required Choose value,
  }) {
    return PopupMenuItem(
      child: Text(text),
      value: value,
    );
  }

  DataColumn _buildDataColumn({required String label}) {
    return DataColumn(
      label: Expanded(
        child: Text(
          label,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _onChoiceSelected(
      {required Choose choose,
      required BuildContext context,
      Customer? customer}) {
    showModalBottomSheet<void>(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext context) {
        switch (choose) {
          case Choose.addCustomer:
            return BottomSheetWidget(
              formType: FormType.addCustomer,
              setState: () {
                setState(() {});
              },
            );
          case Choose.addReading:
            return BottomSheetWidget(
              formType: FormType.addReading,
              customer: customer,
              setState: () {
                setState(() {});
              },
            );
          case Choose.createBills:
            return BottomSheetWidget(
              formType: FormType.createBill,
              setState: () {},
            );
        }
      },
    );
  }

  Future<List<Customer>?> getAllCustomer() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return await _instance.getAllCustomer();
  }
}
