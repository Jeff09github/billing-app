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
import '../../widgets/single_form.dart';

enum FormType { addCustomer, addReading, payment }

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
            onSelected: (FormType formType) =>
                _onFormSelected(formType, context, null),
            itemBuilder: (BuildContext context) => _buildPopupMenuList(),
          ),
        ],
      ),
      body: FutureBuilder<Database?>(
        future: loadDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else {
            if (!snapshot.hasData) {
              return Container();
            } else {
              return FutureBuilder<List<Customer>?>(
                future: getAllCustomer(),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : (snapshot.data != null && snapshot.data!.isNotEmpty)
                          ? SingleChildScrollView(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: DataTable(
                                  headingTextStyle: getBoldStyle(
                                      color: Colors.white, fontSize: 18.0),
                                  dataTextStyle: getRegularStyle(
                                      color: Colors.white, fontSize: 14.0),
                                  dividerThickness: 3.0,
                                  border: TableBorder.all(color: Colors.white),
                                  columnSpacing: 0.0,
                                  horizontalMargin: 0.0,
                                  columns: <DataColumn>[
                                    _buildDataColumn(label: 'Customer'),
                                    _buildDataColumn(label: 'Previous Reading'),
                                    _buildDataColumn(label: 'Current Reading'),
                                    _buildDataColumn(label: 'New Reading'),
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
                                                            customer: snapshot
                                                                .data![index],
                                                            billType:
                                                                BillType.water),
                                                  );
                                                },
                                                child: Text(
                                                  snapshot
                                                      .data![index].fullName,
                                                  style: getRegularStyle(
                                                      color:
                                                          ColorManager.primary),
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            FutureBuilder<List<Reading>?>(
                                              future:
                                                  _instance.getLastTwoReading(
                                                      snapshot.data![index].id!,
                                                      BillType.water),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                }
                                                return snapshot.data!.length < 2
                                                    ? const Text('')
                                                    : Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          '${snapshot.data![1].reading.toString()} - ${DateFormat.yMd().format(snapshot.data![1].createdAt)}',
                                                        ),
                                                      );
                                              },
                                            ),
                                          ),
                                          DataCell(
                                            FutureBuilder<List<Reading>?>(
                                              future:
                                                  _instance.getLastTwoReading(
                                                      snapshot.data![index].id!,
                                                      BillType.water),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                }
                                                return snapshot.data!.isEmpty
                                                    ? const Text('')
                                                    : Align(
                                                        alignment:
                                                            Alignment.center,
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
                                                  _onFormSelected(
                                                      FormType.addReading,
                                                      context,
                                                      snapshot.data![index]);
                                                },
                                                child: Text(
                                                  'CREATE',
                                                  style: getRegularStyle(
                                                    color: ColorManager.primary,
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
            }
          }
        },
      ),
    );
  }

  List<PopupMenuItem<FormType>> _buildPopupMenuList() {
    final popupMenuList = [
      PopupMenuItem(
        child: _getPopupMenuItemText(data: 'Add Customer'),
        value: FormType.addCustomer,
      ),
      PopupMenuItem(
        child: _getPopupMenuItemText(data: 'Payment'),
        value: FormType.payment,
      ),
      // PopupMenuItem(
      //   child: _getPopupMenuItemText(data: 'Create Bills'),
      //   value: ,
      // ),
    ];
    return popupMenuList;
  }

  Text _getPopupMenuItemText({required String data}) {
    return Text(
      data,
      style: getBoldStyle(color: ColorManager.primary, fontSize: 18.0),
    );
  }

  DataColumn _buildDataColumn({required String label}) {
    return DataColumn(
      label: Expanded(
        child: Text(
          label,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ),
    );
  }

  Future<bool> addCustomer({required String fullName}) async {
    final _db = MaaaDatabase.instance;
    Customer? _customer;
    await Future.delayed(const Duration(milliseconds: 1000));
    _customer = await _db.addCustomer(fullName: fullName);
    if (_customer != null) {
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addReading(
      {required String reading, required int customerId}) async {
    Reading? _reading;
    final _db = MaaaDatabase.instance;
    await Future.delayed(const Duration(milliseconds: 1000));
    _reading = await _db.addReading(
      reading: reading,
      billType: BillType.water,
      customerId: customerId,
    );
    if (_reading != null) {
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  void _onFormSelected(
      FormType formType, BuildContext context, Customer? customer) {
    showModalBottomSheet<void>(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext context) {
        switch (formType) {
          case FormType.addCustomer:
            return SingleForm(
              label: 'Full Name',
              textInputType: TextInputType.name,
              validation: isTextValid,
              success: (value) => addCustomer(fullName: value),
            );
          case FormType.payment:
            return Text('');
          case FormType.addReading:
            return SingleForm(
              label: 'Create New Reading',
              textInputType: TextInputType.phone,
              validation: isCMValid,
              success: (value) =>
                  addReading(reading: value, customerId: customer!.id!),
            );
          // case FormType.createBill:
          //   return BottomSheetWidget(
          //     formType: FormType.payment,
          //     setState: () {},
          //   );
        }
      },
    );
  }

  String? isTextValid(String? value) {
    return (value != null && value.trim().isNotEmpty)
        ? null
        : 'Input your full name';
  }

  String? isCMValid(String? value) {
    return (value != null && value.length == 4)
        ? null
        : 'Input a correct reading with 4 characters. ';
  }

  Future<List<Customer>?> getAllCustomer() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return await _instance.getAllCustomer();
  }
}
